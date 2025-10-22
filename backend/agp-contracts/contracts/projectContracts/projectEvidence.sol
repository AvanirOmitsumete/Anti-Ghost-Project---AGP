//
// License Identifier: Compiler Version
//
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ProjectEvidence
 * @dev Manages the recording and authentication of project progress evidence.
 *
 * All variables and functions use camelCase for readability, and the contract
 * and struct names use PascalCase, following Solidity naming conventions.
 */
contract ProjectEvidence {

    // --- STRUCT (PascalCase) ---

    /**
     * @dev Structure to hold evidence details for a specific project milestone.
     */
    struct Evidence {
        uint256 evidenceId;
        uint256 projectId;
        // Data hash or IPFS CID related to the image/document evidence.
        // Using bytes is more efficient than a full image file.
        bytes evidenceDataHash;
        uint256 completionPercentage;
        uint256 authenticityScore;
        string authenticatedBy;
        uint256 authenticatedOn; // Timestamp
        bool isValid;
    }

    // --- STATE VARIABLES (camelCase) ---

    // Counter to generate unique IDs for each piece of evidence added.
    uint256 private nextEvidenceId = 1;

    // Mapping from the unique evidence ID to the Evidence struct.
    mapping(uint256 => Evidence) private idToEvidence;

    // --- EVENTS ---

    /**
     * @dev Emitted when a new piece of project evidence is successfully added.
     * @param evidenceId The unique ID of the new evidence entry.
     * @param projectId The ID of the project this evidence belongs to.
     */
    event EvidenceAdded(uint256 evidenceId, uint256 projectId);

    // --- FUNCTIONS ---

    /**
     * @notice Adds a new evidence record to the contract storage.
     * @dev Increments the evidence counter and stores the new data.
     * @param _projectId The ID of the project the evidence is for.
     * @param _evidenceDataHash A hash or CID pointing to the evidence image/document.
     * @param _completionPercentage The project's completion status at this point (0-100).
     * @param _authenticityScore The calculated score for the evidence.
     * @param _authenticatedBy The entity that verified the evidence (e.g., wallet address or name).
     */
    function addEvidence(
        uint256 _projectId,
        bytes memory _evidenceDataHash,
        uint256 _completionPercentage,
        uint256 _authenticityScore,
        string memory _authenticatedBy
    ) public {
        // Use the current counter value as the new ID
        uint256 newId = nextEvidenceId;

        // Store the new evidence structure in the mapping
        idToEvidence[newId] = Evidence({
            evidenceId: newId,
            projectId: _projectId,
            evidenceDataHash: _evidenceDataHash,
            completionPercentage: _completionPercentage,
            authenticityScore: _authenticityScore,
            authenticatedBy: _authenticatedBy,
            authenticatedOn: block.timestamp, // Use the current block timestamp
            isValid: true
        });

        // Increment the counter for the next entry
        nextEvidenceId++;

        // Emit an event for off-chain listeners
        emit EvidenceAdded(newId, _projectId);
    }

    /**
     * @notice Retrieves the full evidence structure for a given ID.
     * @dev Uses 'view' because it only reads data, and 'public' for external access.
     * @param _evidenceId The unique ID of the evidence to retrieve.
     * @return The complete Evidence struct.
     */
    function getEvidence(uint256 _evidenceId)
        public
        view
        returns (Evidence memory)
    {
        // Simple return from the mapping.
        // If the ID does not exist, Solidity returns a struct with default values (0, "", false).
        return idToEvidence[_evidenceId];
    }
}
