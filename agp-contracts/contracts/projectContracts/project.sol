// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract project {

    // A counter to assign unique IDs to new projects
    uint256 private nextProjectId = 1;

    // The data structure for a single project
    struct ProjectStruc {
        uint256 project_id;
        string project_name;
        string project_description;
        uint256 project_total_cost;
        uint256 project_budget;
        uint256 project_estimated_end_date;
        bytes project_document;
        uint256 importance_level;
        string overdue_level;
        uint256 created_on;
        string created_by;
        bool is_finished;
    }

    // Storage: A mapping to store projects by their unique ID
    mapping(uint256 => ProjectStruc) private projects;

    // An array to keep track of all project IDs, useful for fetching all projects
    uint256[] private projectIds;

    //
    // 1. Adding Projects with Validation
    //

    /**
     * @notice Adds a new project to the contract storage.
     * @dev All required fields are validated to ensure they have non-zero or non-empty values.
     * @param _name The project's name.
     * @param _description The project's description.
     * @param _totalCost The total cost incurred so far.
     * @param _budget The allocated budget.
     * @param _endDate The estimated end date (Unix timestamp).
     * @param _document A byte array representing project document data (e.g., a hash or IPFS URI).
     * @param _importance The importance level (e.g., 1-5).
     * @param _overdueLevel The overdue status (e.g., "On-Time", "Slightly", "Critical").
     * @param _createdBy The user/entity creating the project.
     */
    function addProject(
        string memory _name,
        string memory _description,
        uint256 _totalCost,
        uint256 _budget,
        uint256 _endDate,
        bytes memory _document,
        uint256 _importance,
        string memory _overdueLevel,
        string memory _createdBy
    ) public {
        // --- Validation: Require all fields to have a value ---
        require(bytes(_name).length > 0, "Project Name is required.");
        require(bytes(_description).length > 0, "Description is required.");
        require(_budget > 0, "Budget must be greater than zero.");
        require(_endDate > 0, "Estimated End Date is required.");
        require(bytes(_document).length > 0, "Project Document (e.g., hash) is required.");
        require(_importance > 0, "Importance Level is required.");
        require(bytes(_overdueLevel).length > 0, "Overdue Level is required.");
        require(bytes(_createdBy).length > 0, "Creator is required.");
        // Note: _totalCost can be 0 for a new project.
        
        // Create the new project struct
        ProjectStruc memory newProject = ProjectStruc({
            project_id: nextProjectId,
            project_name: _name,
            project_description: _description,
            project_total_cost: _totalCost,
            project_budget: _budget,
            project_estimated_end_date: _endDate,
            project_document: _document,
            importance_level: _importance,
            overdue_level: _overdueLevel,
            created_on: block.timestamp, // Use the current block timestamp
            created_by: _createdBy,
            is_finished: false
        });

        // Store the project and its ID
        projects[nextProjectId] = newProject;
        projectIds.push(nextProjectId);

        // Increment the ID counter for the next project
        nextProjectId++;
    }

    //
    // 2. Getting Project requiring the project id
    //

    /**
     * @notice Retrieves the details of a single project by its ID.
     * @param _id The unique ID of the project to retrieve.
     * @return A tuple containing all fields of the ProjectStruc.
     */
    function getProject(uint256 _id) 
        public 
        view 
        returns (ProjectStruc memory) 
    {
        require(_id > 0 && projects[_id].project_id != 0, "Project ID does not exist.");
        
        return projects[_id];
    }

    //
    // 3. Getting all projects
    //

    /**
     * @notice Retrieves all projects stored in the contract.
     * @dev Iterates over the array of project IDs to fetch all ProjectStruc objects.
     * @return An array of ProjectStruc containing all projects.
     */
    function getAllProjects() 
        public 
        view 
        returns (ProjectStruc[] memory) 
    {
        ProjectStruc[] memory allProjects = new ProjectStruc[](projectIds.length);

        for (uint i = 0; i < projectIds.length; i++) {
            allProjects[i] = projects[projectIds[i]];
        }

        return allProjects;
    }
}