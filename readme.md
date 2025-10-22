# Anti-Ghost-Project (AGP) 🌟

## Overview 🚀
The Anti-Ghost-Project (AGP) implements Web3 Ethereum smart contracts to ensure immutability of government and non-government project transactions and records. It leverages n8n for no-code automation, utilizing built-in nodes to validate and automate form checking of raw data (images, videos, audio, text) before storing them in the database.

**Main Goal**: Increase transparency by keeping citizens informed about upcoming, ongoing, and overdue projects.

## Features ✨

### 1. AI-Powered Data Verification
- Authenticates raw data using AI with a 0-10 authenticity rating
- Ratings < 3: Data is discarded
- Ratings < 9: Data requires human authentication
- Ratings ≥ 9: Data is automatically authenticated

### 2. Blockchain Integration
- Mints authenticated project data and transactions
- Ensures immutability through Ethereum smart contracts

### 3. Automated Notifications
- Email alerts for near-overdue/overdue projects
- Notifications sent to government officials and project personnel

## Directory Structure 🗺️
```
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
│   ├── contracts/
│   ├── scripts/
│   └── tests/
├── artifacts/
├── dockerfile
├── hashing/
└── n8n/
```

## Installation ⚙️

### Prerequisites
- Node.js (v18+)
- Docker Desktop
- Remix IDE (for contract compilation & deployment)
- Crypto Wallet (MetaMask or Infura-supported alternatives)
- Infura Account
  - API Key
  - Project ID
- Gemini API Key
- Supabase Account
  - Secret Key/Anon Key
  - Host URL: `https://SUPABASE_ID.supabase.co`
  - Storage Buckets ([Setup Guide](https://supabase.com/docs/guides/storage/buckets/fundamentals))

### Setup Steps

1. **Clone the repository**
```bash
git clone https://github.com/AvanirOmitsumete/Anti-Ghost-Project---AGP.git
```

2. **Install dependencies**
```bash
npm install
```

3. **Deploy and Rebuild Docker**
```bash
# Stop existing n8n container
docker compose down

# Build and deploy new container
docker compose up -d --build
```

### Project Startup
1. Run Docker Image
2. Run Docker Container
3. Run Docker Create Workflow
4. Import `AGP_Backend_.json`
5. Configure API credentials
6. Execute Triggers

## Usage 🚦

### Accessing the Application
- TODO MEL and KENT (In Development)

### Documentation & Testing 📚
- n8n Webhooks available for testing
- Backend testing via Test URLs

## Future Enhancements 🔮
- KENT J. TODO LIST (In Development)

## Contributing 🤝
We welcome contributions! Please review our contribution guidelines before submitting pull requests.

## API Documentation
For detailed API documentation and examples, visit our [documentation website][docs-link].

[docs-link]: # "Documentation link to be added"