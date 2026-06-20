# MAX BOT - Oracle Cloud Free VPS Setup Guide

## Step 1: Create Oracle Cloud Account

1. Go to: https://cloud.oracle.com/free
2. Click "Start for free"
3. Fill in:
   - Country: your country
   - Name: your name
   - Email: your email
   - Password: create a password
4. Verify your email
5. Add address (required)
6. Add payment method:
   - Credit/Debit card (charged $1 for verification, refunded)
   - OR PayPal
7. Choose your home region (closest to you)

## Step 2: Create VM Instance

1. Login to: https://cloud.oracle.com
2. Click hamburger menu (top left) → Compute → Instances
3. Click "Create Instance"
4. Fill in:
   - Name: maxbot-server
   - Image: Ubuntu 22.04 (or latest)
   - Shape: VM.Standard.A1.Flex (FREE ARM)
     - OCPU: 4
     - Memory: 24 GB
   - VCN: "Create new VCN" (default)
   - Public IP: Create new
   - Add SSH keys:
     - "Generate SSH key pair"
     - Click "Download Private Key" → save as maxbot-key.key
5. Click "Create"

## Step 3: Connect to Server

### On Windows (PowerShell):
```
ssh -i C:\path\to\maxbot-key.key ubuntu@PUBLIC_IP
```

### Or use PuTTY:
1. Download PuTTY from https://putty.org
2. Host Name: PUBLIC_IP
3. SSH → Auth → Credentials → browse for maxbot-key.key
4. Open

## Step 4: Deploy Bot

### Upload files:
```bash
# From your PC (in a new terminal):
scp -i maxbot-key.key -r C:\Users\USER\Desktop\z1-pro\* ubuntu@PUBLIC_IP:/opt/maxbot/
```

### OR clone from GitHub:
```bash
ssh into server, then:
cd /opt/maxbot
git clone https://github.com/max-bot96/max-bot-add-.git .
```

### Run setup:
```bash
chmod +x deploy/setup.sh deploy/deploy.sh
./deploy/setup.sh
```

### Create .env file:
```bash
nano /opt/maxbot/.env
```
Add:
```
DISCORD_TOKEN=your_bot_token_here
DISCORD_CLIENT_SECRET=your_client_secret_here
FLASK_SECRET_KEY=any_random_string_here
HONEYPOT_SECRET=any_random_string_here
CAPTCHA_SECRET=any_random_string_here
```
Press Ctrl+X, then Y, then Enter

### Deploy:
```bash
./deploy/deploy.sh
```

## Step 5: Check Status

```bash
# Check all services
systemctl status maxbot-bot
systemctl status maxbot-dashboard
systemctl status maxbot-tunnel

# View logs
tail -f /opt/maxbot/logs/bot.log
tail -f /opt/maxbot/logs/tunnel.log

# Restart if needed
systemctl restart maxbot-bot
```

## Step 6: Open Firewall Port

Oracle Cloud blocks ports by default:
1. Go to Cloud Console → Networking → Virtual Cloud Networks
2. Click your VCN → Security Lists
3. Click Default Security List → Add Ingress Rules
4. Add:
   - Source CIDR: 0.0.0.0/0
   - Destination Port: 5001
5. Save

## Step 7: Update Render URL

After deploying, update the tunnel URL in server_url2.txt
The bot will send the URL to your Discord DM.

## Done! 
Your bot now runs 24/7 on a free VPS forever!
