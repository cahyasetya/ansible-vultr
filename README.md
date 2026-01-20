# Ansible Vultr VM Provisioning

This repository contains Ansible configuration for provisioning a Vultr VM with automated CI/CD via GitHub Actions.

## Prerequisites

- Ansible installed on your local machine
- SSH access to your Vultr VM
- SSH key configured for authentication

## Setup

1. Copy `.env.example` to `.env` and set your VM IP:
   ```bash
   cp .env.example .env
   # Edit .env and set VULTR_VM_IP
   ```

2. Ensure your SSH key is set up:
   ```bash
   ssh-copy-id root@YOUR_VM_IP
   ```

3. Source environment variables before running playbooks:
   ```bash
   source .env
   ```

## Quick Start

### Using Make

Test connection:
```bash
make ping
```

Run provisioning:
```bash
make provision
```

Check syntax:
```bash
make check
```

### Using Ansible directly

Test connection:
```bash
ansible vultr-vm -m ping
```

Run provisioning playbook:
```bash
ansible-playbook provision.yml
```

Dry run (check mode):
```bash
ansible-playbook provision.yml --check
```

## Files

- `inventory.yml` - Ansible inventory with Vultr VM configuration
- `ansible.cfg` - Ansible configuration
- `provision.yml` - Main provisioning playbook
- `cloudflare-tunnel.yml` - Cloudflare Tunnel setup playbook (quick tunnel with free domain)
- `Makefile` - Common commands for easier usage
- `.github/workflows/deploy.yml` - GitHub Actions CI/CD workflow

## Cloudflare Quick Tunnel Setup

Get a free Cloudflare tunnel URL (no account required!)

### What is Quick Tunnel?

Cloudflare Quick Tunnels provide temporary public URLs (`https://xxx-xxx-xxx.trycloudflare.com`) that tunnel to your local service. No authentication or Cloudflare account needed.

### Deploy

```bash
ansible-playbook -i inventory.yml cloudflare-tunnel.yml
```

The playbook will:
1. Install cloudflared
2. Create a systemd service that runs `cloudflared tunnel --url localhost:5001`
3. Display your free tunnel URL

### Get Your Tunnel URL

After deployment, SSH into your VM and check the logs:
```bash
journalctl -u cloudflared-quick -n 100 | grep trycloudflare.com
```

You'll see something like:
```
https://random-words-1234.trycloudflare.com
```

### Change Local Service Port

Edit `cloudflare-tunnel.yml` and change:
```yaml
vars:
  local_service_url: "localhost:YOUR_PORT"
```

## Customization

Edit `provision.yml` to add your own provisioning tasks such as:
- Installing additional packages
- Configuring web servers (Nginx, Apache)
- Setting up databases (PostgreSQL, MySQL)
- Deploying applications
- Managing users and permissions

## GitHub Actions CI/CD

This repo includes automated deployment via GitHub Actions.

### Setup

Add these secrets to your GitHub repo (Settings → Secrets and variables → Actions):

1. **SSH_PRIVATE_KEY** - Your SSH private key to access the VM
2. **VULTR_VM_IP** - Your Vultr VM IP address

### How It Works

Every push to `main`/`master` branch automatically:
1. Installs Ansible
2. Connects to your VM via SSH
3. Runs the playbook

### Manual Trigger

Go to Actions tab → Deploy with Ansible → Run workflow

## Security

All secrets are stored as environment variables or GitHub Secrets.

**Never commit:**
- `.env` files
- SSH keys
- Passwords or tokens

## Troubleshooting

If you encounter SSH issues:
1. Verify you can SSH manually: `ssh root@YOUR_VM_IP`
2. Check your SSH key path in `inventory.yml`
3. Ensure `host_key_checking = False` in `ansible.cfg` for first connection
4. Make sure `VULTR_VM_IP` environment variable is set
