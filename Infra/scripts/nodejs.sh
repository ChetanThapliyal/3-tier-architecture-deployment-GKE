#!/bin/bash
sudo apt-get update
sudo apt-get install -y ca-certificates git build-essential
# Install Node.js
# Set up and install NVM
export NVM_DIR="/opt/nodejs/.nvm"
mkdir -p "$NVM_DIR"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | NVM_DIR="$NVM_DIR" bash
# Source nvm script to load it into the current session
source "$NVM_DIR/nvm.sh"
# Install Node.js using NVM
nvm install 21
# Post-install verification
echo "Node version:"
node -v
echo "NPM version:"
npm -v

cd ~
cd /opt
git clone https://github.com/ChetanThapliyal/yelpcamp-devops-gcp-docker-gke.git
cd yelpcamp-devops-gcp-docker-gke
git pull
cd src
npm install
touch .env
echo "CLOUDINARY_CLOUD_NAME=" >> .env
echo "CLOUDINARY_KEY=" >> .env
echo "CLOUDINARY_SECRET=" >> .env
echo "MAPBOX_TOKEN=" >> .env
echo "DB_URL=" >> .env
echo "SECRET=" >> .env
cd ..

#Run following after SSH to VM:
# export NVM_DIR="/opt/nodejs/.nvm" && source "$NVM_DIR/nvm.sh"
# npm start
# access Application at http://ExternalIP:3000/