#!/bin/bash
# MAX BOT - Full Deploy Script
# Run this on your Oracle Cloud VPS after uploading code

echo "========================================"
echo "  MAX BOT - Deploying to Server"
echo "========================================"

BOT_DIR="/opt/maxbot"

# Create directories
mkdir -p $BOT_DIR/logs

# Create virtual environment
python3.11 -m venv $BOT_DIR/venv
source $BOT_DIR/venv/bin/activate

# Install dependencies
pip install --upgrade pip
pip install -r $BOT_DIR/requirements.txt

# Install systemd services
cp $BOT_DIR/deploy/maxbot-bot.service /etc/systemd/system/
cp $BOT_DIR/deploy/maxbot-dashboard.service /etc/systemd/system/
cp $BOT_DIR/deploy/maxbot-tunnel.service /etc/systemd/system/

# Reload systemd
systemctl daemon-reload

# Enable services (auto-start on boot)
systemctl enable maxbot-bot
systemctl enable maxbot-dashboard
systemctl enable maxbot-tunnel

# Start services
systemctl start maxbot-bot
systemctl start maxbot-dashboard
systemctl start maxbot-tunnel

# Get tunnel URL (wait for it)
sleep 10
TUNNEL_URL=$(grep -oP 'https://[a-z0-9-]+\.trycloudflare\.com' /opt/maxbot/logs/tunnel.log | tail -1)

echo ""
echo "========================================"
echo "  DEPLOY COMPLETE!"
echo "========================================"
echo ""
echo "  Bot:       systemctl status maxbot-bot"
echo "  Dashboard: systemctl status maxbot-dashboard"
echo "  Tunnel:    systemctl status maxbot-tunnel"
echo ""
echo "  Tunnel URL: $TUNNEL_URL"
echo ""
echo "  Logs:"
echo "    tail -f /opt/maxbot/logs/bot.log"
echo "    tail -f /opt/maxbot/logs/dashboard.log"
echo "    tail -f /opt/maxbot/logs/tunnel.log"
echo ""
echo "  Commands:"
echo "    systemctl restart maxbot-bot"
echo "    systemctl restart maxbot-dashboard"
echo "    systemctl stop maxbot-bot"
echo "========================================"
