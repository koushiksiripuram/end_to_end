#!/bin/bash

# 1. Install Docker using the official convenience script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 2. Install Docker Compose plugin (modern v2 version)
sudo apt-get update
sudo apt-get install -y docker-compose-plugin

# 3. Add current user to the docker group
sudo usermod -aG docker $USER

# 4. Cleanup
rm get-docker.sh

sudo apt install certbot -y
echo "Installation complete. Please log out and back in for group changes to take effect."
