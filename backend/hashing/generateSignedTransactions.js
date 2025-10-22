// Add this line at the top of your script
const fetch = require("node-fetch");
const { ethers } = require("ethers");
const fs = require("fs");
const path = require("path");
const crypto = require("crypto");
require("dotenv").config();

// Function to hash a file using a stream
function hashFileWithStream(filePath) {
  return new Promise((resolve, reject) => {
    const hash = crypto.createHash("sha256");
    const stream = fs.createReadStream(filePath);
    stream.on("data", (chunk) => hash.update(chunk));
    stream.on("end", () => resolve(hash.digest("hex")));
    stream.on("error", (err) => reject(err));
  });
}

async function generateProofTx() {
  const [imagePath] = process.argv.slice(2);

  if (!imagePath) {
    console.error("Usage: node generateProofTx_webhook.js <path_to_file>");
    process.exit(1);
  }

  if (!process.env.PRIVATE_KEY || !process.env.INFURA_PROJECT_ID) {
    console.error("Please set PRIVATE_KEY and INFURA_PROJECT_ID in your .env file.");
    process.exit(1);
  }

  if (!fs.existsSync(imagePath)) {
    console.error(`Error: File not found at ${imagePath}`);
    process.exit(1);
  }

  const provider = new ethers.InfuraProvider("sepolia", process.env.INFURA_PROJECT_ID);
  const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  try {
    const network = await provider.getNetwork(); // ✅ Fetch network info
    const chainId = network.chainId; // ✅ Automatically get Sepolia chain ID (11155111)

    const imageHash = "0x" + (await hashFileWithStream(path.resolve(__dirname, imagePath)));
    const signature = await signer.signMessage(ethers.getBytes(imageHash));
    const nonce = await provider.getTransactionCount(signer.address);

    // Combine hash + signature as payload data
    const transactionData = imageHash + signature.substring(2);

    const transaction = {
      to: signer.address,
      value: ethers.parseEther("0"),
      nonce,
      type: 2,
      chainId, // ✅ REQUIRED for EIP-2718
      gasLimit: 60000,
      maxPriorityFeePerGas: ethers.parseUnits("1", "gwei"),
      maxFeePerGas: ethers.parseUnits("50", "gwei"),
      data: transactionData,
    };

    const signedTx = await signer.signTransaction(transaction);

    // --- Post the payload to the n8n webhook ---
    const webhookUrl = process.env.WEBSOCKET_URL;
    const payload = {
      filePath: imagePath,
      fileHash: imageHash,
      signature,
      signedTx,
    };

    console.log(`Sending payload to webhook: ${webhookUrl}`);

    const response = await fetch(webhookUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });

    if (response.ok) {
      console.log("Webhook triggered successfully!");
    } else {
      console.error(`Error triggering webhook: ${response.status} - ${response.statusText}`);
    }
  } catch (error) {
    console.error("Error in transaction generation:", error);
    process.exit(1);
  }
}

generateProofTx();