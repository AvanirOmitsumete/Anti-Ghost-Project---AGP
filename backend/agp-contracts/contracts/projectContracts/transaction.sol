//
// License Identifier: Compiler Version
//
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TransactionContract
 * @dev Manages transactions related to projects.
 */
contract TransactionContract {

    /**
     * @dev Structure to hold transaction details related to a project.
     */
    struct Transaction {
        uint256 transactionId;
        uint256 projectId;
        string productType;
        string productName;
        uint256 productCost;
    }

    // Counter to generate unique IDs for each transaction.
    uint256 private nextTransactionId = 1;

    // Mapping from the unique transaction ID to the Transaction struct.
    mapping(uint256 => Transaction) private idToTransaction;

    // Mapping to retrieve all transaction IDs for a specific project.
    mapping(uint256 => uint256[]) private projectToTransactionIds;

    /**
     * @dev Emitted when a new transaction is added.
     * @param transactionId The unique ID of the new transaction.
     * @param projectId The ID of the project this transaction is for.
     */
    event TransactionAdded(uint256 transactionId, uint256 projectId);

    /**
     * @notice Adds a new transaction record.
     * @param _projectId The ID of the project this transaction is associated with.
     * @param _productType The type of product or service.
     * @param _productName The name of the product or service.
     * @param _productCost The cost of the product or service.
     */
    function addTransaction(
        uint256 _projectId,
        string memory _productType,
        string memory _productName,
        uint256 _productCost
    ) public {
        uint256 newId = nextTransactionId;

        idToTransaction[newId] = Transaction({
            transactionId: newId,
            projectId: _projectId,
            productType: _productType,
            productName: _productName,
            productCost: _productCost
        });

        projectToTransactionIds[_projectId].push(newId);
        nextTransactionId++;

        emit TransactionAdded(newId, _projectId);
    }

    /**
     * @notice Retrieves a transaction by its ID.
     * @param _transactionId The ID of the transaction to retrieve.
     * @return The Transaction struct.
     */
    function getTransaction(uint256 _transactionId)
        public
        view
        returns (Transaction memory)
    {
        return idToTransaction[_transactionId];
    }

    /**
     * @notice Retrieves all transaction IDs for a given project.
     * @param _projectId The ID of the project.
     * @return An array of transaction IDs.
     */
    function getAllTransactionsForProject(uint256 _projectId)
        public
        view
        returns (uint256[] memory)
    {
        return projectToTransactionIds[_projectId];
    }
}