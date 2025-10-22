🌟 Project Title
Anti-Ghost-Project (AGP)

🚀 Overview
The project aim to implement web 3 ethereum(sol) contracts for immutability of transactions and records of non-government and government projects. Uses n8n for no-code and automation through using in built nodes from n8n to validate and automate form checking of raw data(images, videos, audio, text) and storing them inside the database.

The goal main of the project aims to make guests(citizens) aware of upcoming/ongoing/overdue projects.

✨ Features
List the main functionalities or selling points of your project.

Feature 1: Verification of raw data using AI and has a authenticity rate of 0-10, if < 3 it will be discard, if below < 9 the raw data will be authenticated by a human.

Feature 2: Minting of data transactions and raw data of authenticated projects

Feature 3: If A project is near-overdue/overdue the system will send a email to notify government/assigned project personels.

🗺️ Directory Structure
Directory Structure
.
├── .docker-compose.yml
├── .env
├── .gitignore
├── .states/
│   ├── build-info
│   └── vm-prague
├── agp-contracts/
│   ├── .deps/
│   ├── .states/
│   ├── artifacts/
│   │   └── build-info
│   ├── contracts/
│   ├── scripts/
│   └── tests/
├── artifacts/
│   └── build-info
├── dockerfile
├── hashing/
└── n8n/

Folder Breakdown (The City Districts)
⚙️ Installation
This is the assembly manual—how a user gets the project running on their local machine.

#Prerequisites
Node.js (version 18+)
docker-desktop
Remix-IDE

Steps
Clone the repository: 
git clone https://github.com/AvanirOmitsumete/Anti-Ghost-Project---AGP.git

Install dependencies:
npm install

Deploy and Rebuild Docker:
1. Stop any existing n8n container running from your old setup:
docker compose down

2. Build and Deploy the new container:
docker compose up -d --build

How to Run the Project:
1. Run Docker Image
2. Run Docker Container
3. Run Docker Create Workflow
4. Import AGP_Backend_.json
5. Add all necessary API credentials & empty code blocks
6. 

🚦 Usage
The quick start guide—how to actually run and interact with the application once it's set up.

Starting the Application
To run the application in development mode:

The application should now be accessible at http://localhost:3000.

API Endpoints (For Backend Projects)
📚 Documentation & Testing
Link to any extensive, external documentation and briefly explain how to run tests.

Running Tests
To execute the full test suite and view coverage:

External Docs
For detailed API definitions and usage examples, see our dedicated documentation website: [Link to Docs Site]

🤝 Contributing
We welcome contributions! Please review these documents before submitting a pull request.



📝 License
This project is licensed under the [LICENSE NAME] License - see the file for details.

📞 Contact
Project Maintainer: [Your Name] - [Your Email/GitHub Profile]