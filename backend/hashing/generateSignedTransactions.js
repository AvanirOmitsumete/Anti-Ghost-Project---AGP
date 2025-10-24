const fetch = require("node-fetch");
const { ethers } = require("ethers");
const fs = require("fs");
const path = require("path");
const crypto = require("crypto");
require("dotenv").config();

// Function to hash a local file using a stream
function hashLocalFileWithStream(filePath) {
  return new Promise((resolve, reject) => {
    const hash = crypto.createHash("sha256");
    const stream = fs.createReadStream(filePath);
    stream.on("data", (chunk) => hash.update(chunk));
    stream.on("end", () => resolve(hash.digest("hex")));
    stream.on("error", (err) => reject(err));
  });
}

// Function to hash content from a URL
async function hashUrlContent(url) {
  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`Failed to fetch URL: ${response.statusText}`);
    }
    const buffer = await response.buffer(); // Get content as a Buffer
    const hash = crypto.createHash("sha256");
    hash.update(buffer);
    return hash.digest("hex");
  } catch (error) {
    throw new Error(`Error hashing URL content: ${error.message}`);
  }
}

async function generateProofTx() {
  const [inputPath] = process.argv.slice(2);

  if (!inputPath) {
    console.error("Usage: node generateSignedTransactions.js <local_file_path_or_image_url>");
    process.exit(1);
  }

  if (!process.env.PRIVATE_KEY || !process.env.INFURA_PROJECT_ID) {
    console.error("Please set PRIVATE_KEY and INFURA_PROJECT_ID in your .env file.");
    process.exit(1);
  }

  let contentHash;
  let isUrl = inputPath.startsWith('http://') || inputPath.startsWith('https://');

  if (isUrl) {
    console.log(`Hashing content from URL: ${inputPath}`);
    contentHash = "0x" + (await hashUrlContent(inputPath));
  } else {
    if (!fs.existsSync(inputPath)) {
      console.error(`Error: File not found at ${inputPath}`);
      process.exit(1);
    }
    console.log(`Hashing content from local file: ${inputPath}`);
    contentHash = "0x" + (await hashLocalFileWithStream(path.resolve(__dirname, inputPath)));
  }

  const provider = new ethers.InfuraProvider("sepolia", process.env.INFURA_PROJECT_ID);
  const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  try {
    const network = await provider.getNetwork();
    const chainId = network.chainId;

    const signature = await signer.signMessage(ethers.getBytes(contentHash));
    const nonce = await provider.getTransactionCount(signer.address);

    // Combine hash + signature as payload data (this data will be sent in the transaction)
    const transactionData = contentHash + signature.substring(2);

    const transaction = {
      to: signer.address, // Sending to self for proof of existence
      value: ethers.parseEther("0"),
      nonce,
      type: 2,
      chainId,
      gasLimit: 60000, // Adjust as needed
      maxPriorityFeePerGas: ethers.parseUnits("1", "gwei"),
      maxFeePerGas: ethers.parseUnits("50", "gwei"),
      data: transactionData,
    };

    const signedTx = await signer.signTransaction(transaction);

    // --- Send the signed transaction to Infura via JSON-RPC ---
    const infuraUrl = `https://sepolia.infura.io/v3/${process.env.INFURA_PROJECT_ID}`;
    const jsonRpcPayload = {
      jsonrpc: "2.0",
      method: "eth_sendRawTransaction",
      params: [signedTx],
      id: 1,
    };

    console.log(`Sending raw transaction to Infura: ${infuraUrl}`);

    const response = await fetch(infuraUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(jsonRpcPayload),
    });

    const result = await response.json();

    if (response.ok && result.result) {
      console.log("Transaction sent successfully!");
      console.log("Transaction Hash:", result.result);
    } else {
      console.error(`Error sending transaction: ${response.status} - ${response.statusText}`);
      console.error("Infura Response:", result);
    }
  } catch (error) {
    console.error("Error in transaction generation or sending:", error);
    process.exit(1);
  }
}

generateProofTx();