# Start from the latest official n8n image
FROM n8nio/n8n:latest

# Switch to the root user to gain installation permissions
USER root

# ----------------------------------------------------------------------------------
# STEP 1: Install Custom System Packages (Optional)
# Uncomment and modify if you need specific operating system tools (e.g., git, curl, python)


# ----------------------------------------------------------------------------------
# STEP 2: Install Custom NPM Packages (Crucial for Function nodes)
# Replace 'package-name-1' and 'package-name-2' with the libraries you need.
# Example: RUN npm install -g node-fetch ethers
RUN npm install -g ethers node-fetch dotenv crypto express cors nodemailer

# ----------------------------------------------------------------------------------

# Switch back to the non-root 'node' user for security best practices
USER node