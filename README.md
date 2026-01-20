# Ansible Vultr VM Provisioning

This repository contains Ansible configuration for provisioning a Vultr VM.

## Prerequisites

- Ansible installed on your local machine
- SSH access to your Vultr VM (207.148.116.91)
- SSH key configured for authentication

## Setup

1. Ensure your SSH key is set up:
   ```bash
   ssh-copy-id root@207.148.116.91
   ```

2. Update `inventory.yml` if you use a different SSH key path

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

Install and configure HAProxy:
```bash
make haproxy
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
- `haproxy.yml` - HAProxy installation and configuration playbook
- `cloudflare-tunnel.yml` - Cloudflare Tunnel setup playbook
- `templates/haproxy.cfg.j2` - HAProxy configuration template
- `templates/cloudflared-config.yml.j2` - Cloudflare Tunnel configuration template
- `Makefile` - Common commands for easier usage

## HAProxy Configuration

The `haproxy.yml` playbook installs and configures HAProxy as a load balancer.

### Configuration Variables

Edit the following variables in `haproxy.yml`:

- `haproxy_frontend_port`: Frontend port (default: 80)
- `haproxy_stats_port`: Stats interface port (default: 8404)
- `haproxy_stats_user`: Stats authentication username (default: admin)
- `haproxy_stats_password`: Stats authentication password (default: changeme)
- `backend_servers`: List of backend servers to load balance

Example backend server configuration:
```yaml
backend_servers:
  - name: web1
    address: 192.168.1.10
    port: 8080
  - name: web2
    address: 192.168.1.11
    port: 8080
```

### Deploy HAProxy

```bash
make haproxy
```

### Access HAProxy Stats

After deployment, access the stats interface at:
```
http://207.148.116.91:8404/stats
```

Default credentials: `admin` / `changeme` (change this in `haproxy.yml`)

## Cloudflare Tunnel Setup

Cloudflare Tunnel provides secure access to your services without exposing ports or using a public IP.

### Prerequisites

1. A Cloudflare account with a domain configured
2. Access to Cloudflare Zero Trust dashboard

### Setup Steps

1. Go to [Cloudflare Zero Trust Dashboard](https://one.dash.cloudflare.com/)
2. Navigate to Networks > Tunnels
3. Click "Create a tunnel"
4. Choose "Cloudflared" and give it a name (e.g., "vultr-tunnel")
5. Copy the tunnel token provided

### Deploy Cloudflare Tunnel

1. Edit `cloudflare-tunnel.yml` and add your tunnel token:
   ```yaml
   tunnel_token: "your-token-here"
   ```

2. Run the playbook:
   ```bash
   make cloudflare-tunnel
   ```

### Configure Tunnel Routes

After deployment, configure your tunnel routes in the Cloudflare dashboard:
- Public Hostname: your-domain.com
- Service: http://localhost:80 (HAProxy)

For HAProxy stats:
- Public Hostname: stats.your-domain.com
- Service: http://localhost:8404

### Verify Tunnel Status

SSH into your VM and check:
```bash
systemctl status cloudflared
journalctl -u cloudflared -f
```

## Customization

Edit `provision.yml` to add your own provisioning tasks such as:
- Installing additional packages
- Configuring web servers (Nginx, Apache)
- Setting up databases (PostgreSQL, MySQL)
- Deploying applications
- Managing users and permissions

## Troubleshooting

If you encounter SSH issues:
1. Verify you can SSH manually: `ssh root@207.148.116.91`
2. Check your SSH key path in `inventory.yml`
3. Ensure `host_key_checking = False` in `ansible.cfg` for first connection
