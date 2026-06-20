#!/bin/bash
# MAX BOT - Oracle Cloud Setup Script
# Run this on your Ubuntu VPS

echo "========================================"
echo "  MAX BOT - Server Setup"
echo "========================================"

# Update system
sudo apt update && sudo apt upgrade -y

# Install Python 3.11 + pip
sudo apt install -y python3.11 python3.11-venv python3-pip git

# Install cloudflared
curl -fsSL https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /tmp/cloudflared
sudo mv /tmp/cloudflared /usr/local/bin/cloudflared
sudo chmod +x /usr/local/bin/cloudflared

# Create bot directory
sudo mkdir -p /opt/maxbot
sudo chown $USER:$USER /opt/maxbot

echo "========================================"
echo "  System packages installed!"
echo "  Next: upload bot code to /opt/maxbot"
echo "========================================"
