# GitHub Actions Setup for Ansible Automation

This guide explains how to set up automatic deployment via GitHub Actions.

## Required GitHub Secrets

Go to your repo → Settings → Secrets and variables → Actions → New repository secret

Add these secrets:

### 1. SSH_PRIVATE_KEY
Your private SSH key to connect to the VM.

```bash
# Generate if you don't have one
ssh-keygen -t ed25519 -C "github-actions"

# Copy the private key
cat ~/.ssh/id_ed25519
```

Paste the entire private key (including `-----BEGIN` and `-----END` lines).

### 2. VM_HOST
Your VM's IP address or hostname.

Example: `123.456.789.0` or `vm.example.com`

## How It Works

1. **Push to main/master branch** → Triggers deployment
2. GitHub Actions runner:
   - Checks out your code
   - Installs Ansible
   - Sets up SSH connection
   - Runs your playbook

## Manual Trigger

You can also manually trigger deployment:
- Go to Actions tab
- Select "Deploy with Ansible" workflow
- Click "Run workflow"

## Testing Locally First

Always test locally before pushing:

```bash
ansible-playbook -i inventory.yml cloudflare-tunnel.yml --check
```

## Security Best Practices

1. **Never commit secrets** to git
2. Use GitHub Secrets for sensitive data
3. Consider using Ansible Vault for playbook secrets
4. Limit SSH key permissions (read-only if possible)

## Monitoring Deployments

- Check Actions tab for deployment status
- Review logs for any errors
- Set up notifications for failed deployments

## Alternative: Deploy on Pull Request

To deploy only after PR approval, change workflow trigger:

```yaml
on:
  pull_request:
    branches:
      - main
    types: [closed]
```

Then add condition:
```yaml
if: github.event.pull_request.merged == true
```
