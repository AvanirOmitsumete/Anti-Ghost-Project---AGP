# Anti-Ghost-Project (AGP) 🌟

## Overview 🚀
The Anti-Ghost-Project (AGP) is a blockchain-based system designed to bring transparency and immutability to government and non-government projects. By leveraging Ethereum smart contracts and n8n for workflow automation, AGP ensures that all project transactions and records are securely stored and publicly accessible.

**Main Goal**: To increase transparency and keep citizens informed about the status of various projects, including upcoming, ongoing, and overdue ones.

## Features ✨

### 1. AI-Powered Data Verification
- Utilizes AI to authenticate raw data (images, videos, audio, text) with a 0-100 authenticity rating.
- Data with a rating below 3 is discarded.
- Data with a rating below 9 requires human authentication.
- Data with a rating of 9 or higher is automatically authenticated.

### 2. Blockchain Integration
- Mints authenticated project data and transactions onto the Ethereum blockchain.
- Ensures data immutability and resistance to tampering through smart contracts.

### 3. Automated Notifications
- Sends email alerts for projects that are approaching their deadline or are overdue.
- Notifies relevant government officials and project personnel to ensure accountability.

## Tech Stack 🛠️
- **Blockchain**: Ethereum (Solidity)
- **Automation**: n8n
- **Database**: Supabase (PostgreSQL)
- **Backend**: Node.js, Express
- **Libraries**: Ethers.js, Web3.js

## Directory Structure 🗺️
```
.
├── .docker-compose.yml
├── .env.example
├── .gitignore
├── dockerfile
├── README.md
├── backend/
│   ├── agp-contracts/
│   │   ├── contracts/
│   │   ├── scripts/
│   │   └── tests/
│   ├── database/
│   │   └── db_schema.sql
│   ├── hashing/
│   └── n8n/
└── ...
```

## Prerequisites
- Node.js (v18+)
- Docker Desktop
- A crypto wallet (e.g., MetaMask)
- An Infura account and Project ID
- A Gemini API Key
- A Supabase account and project

## Installation & Setup ⚙️

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AvanirOmitsumete/Anti-Ghost-Project---AGP.git
   cd Anti-Ghost-Project---AGP
   ```

2. **Set up environment variables:**
   - Create a `.env` file by copying the `.env.example`.
   - Fill in the required credentials for Supabase, Infura, Gemini, and your Ethereum wallet.

3. **Install backend dependencies:**
   ```bash
   cd backend/hashing
   npm install
   cd ../../
   ```

4. **Deploy with Docker:**
   ```bash
   # Stop any existing containers
   docker compose down

   # Build and run the new container in detached mode
   docker compose up -d --build
   ```

## Usage 🚦
The application is primarily operated through n8n workflows, which handle data validation, processing, and notifications.

- **Accessing the Application**: The frontend for this project is still under development.
- **Testing**: The backend can be tested using the n8n webhook URLs and Test URLs.

## Smart Contracts 📝
The core logic of the AGP system is encapsulated in three main smart contracts:
- `project.sol`: Manages the creation and lifecycle of projects.
- `projectEvidence.sol`: Handles the submission and verification of project evidence.
- `transaction.sol`: Records all financial transactions related to the projects.

## Database Schema 🗄️
The database schema is defined in `backend/database/db_schema.sql`. It includes tables for projects, users, evidence, transactions, and more.

## Contributing 🤝
We welcome contributions to the Anti-Ghost-Project! To contribute, please follow these steps:

1. **Fork the repository.**
2. **Create a new branch** for your feature or bug fix:
   ```bash
   git checkout -b feature-or-bugfix-name
   ```
3. **Make your changes** and ensure that the code follows the project's style and conventions.
4. **Write tests** for your changes, if applicable.
5. **Commit your changes** with a clear and descriptive commit message.
6. **Push your branch** to your forked repository.
7. **Create a pull request** to the `main` branch of the original repository.

Please make sure your pull request is well-documented and explains the changes you have made.

## Future Possible Enhancements 🔮
- Implement more advanced AI models for data verification.
- Expand the notification system to include more channels (e.g., SMS, push notifications).

## License 📄
This project is licensed under the MIT License. See the `LICENSE` file for more details.
