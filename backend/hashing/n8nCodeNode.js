// This function hashes file data (Buffer/Data input)
async function hashFile(fileData) {
    const crypto = require("crypto"); // crypto is a built-in Node.js module
    const hash = crypto.createHash("sha256");
    hash.update(fileData);
    return "0x" + hash.digest("hex");
}

/**
 * Main function for the n8n Code node.
 * This node expects binary file data (e.g., from an HTTP Request node)
 * and JSON credentials (PRIVATE_KEY, INFURA_PROJECT_ID) from a preceding 'Edit Fields' node.
 */
async function generateProofTx() {
    // --- 1. Get Inputs from Previous Nodes ---
    const inputItem = $input.first();
    const jsonInput = inputItem.json;

    // Accessing the binary file data and its name
    const binaryData = inputItem.binary.file;
    const fileName = inputItem.binary.file.fileName;

    if (!binaryData) {
        throw new Error("File data is empty. Ensure the preceding node provides binary data under the key 'file'.");
    }

    // --- 2. Get Credentials/Config from n8n Environment/JSON Input ---
    // 'ethers' is an external module and must be enabled in n8n's settings (NODE_FUNCTION_ALLOW_EXTERNAL=*)
    const { ethers } = require("ethers");

    // Credentials are pulled from the JSON output of the 'Edit Fields' node.
    const privateKey = jsonInput.PRIVATE_KEY;
    const infuraProjectId = jsonInput.INFURA_PROJECT_ID;

    // Basic validation for credentials
    if (!privateKey || !infuraProjectId) {
        throw new Error("PRIVATE_KEY and INFURA_PROJECT_ID must be provided in the preceding 'Edit Fields' node.");
    }

    // --- 3. Transaction Logic ---
    try {
        const provider = new ethers.InfuraProvider("sepolia", infuraProjectId);
        const signer = new ethers.Wallet(privateKey, provider);

        const network = await provider.getNetwork();
        const chainId = network.chainId;

        // Hash the file content
        const imageHash = await hashFile(binaryData.data); // Use binaryData.data for the actual Buffer
        console.log("Generated Image Hash:", imageHash);

        const signature = await signer.signMessage(ethers.getBytes(imageHash));
        const nonce = await provider.getTransactionCount(signer.address);
        const transactionData = imageHash + signature.substring(2);

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
        console.log("Signed Transaction:", signedTx);

        // --- 4. Prepare Output for Next Node (e.g., HTTP Request to Infura) ---
        const payload = {
            filePath: fileName || "proof_file",
            fileHash: imageHash,
            signature,
            signedTx
        };

        // --- 5. Return Output ---
        // The output will be an array of objects, each with a 'json' property.
        return [{ json: payload }];

    } catch (error) {
        // Catch and re-throw errors for better visibility in n8n
        throw new Error(`Error in transaction generation: ${error.message}`);
    }
}

// Execute the main function for the n8n Code node
return generateProofTx();