.PHONY: help ping provision check install list haproxy haproxy-check cloudflare-tunnel

help:
	@echo "Available commands:"
	@echo "  make ping             - Test connection to Vultr VM"
	@echo "  make provision        - Run provisioning playbook"
	@echo "  make check            - Check playbook syntax"
	@echo "  make dry-run          - Run playbook in check mode (no changes)"
	@echo "  make haproxy          - Install and configure HAProxy"
	@echo "  make haproxy-check    - Check HAProxy playbook syntax"
	@echo "  make cloudflare-tunnel - Setup Cloudflare Tunnel"
	@echo "  make install          - Install Ansible (macOS)"
	@echo "  make list             - List all hosts in inventory"

ping:
	ansible vultr-vm -m ping

provision:
	ansible-playbook provision.yml

check:
	ansible-playbook provision.yml --syntax-check

dry-run:
	ansible-playbook provision.yml --check

install:
	@echo "Installing Ansible..."
	brew install ansible

list:
	ansible-inventory --list

haproxy:
	ansible-playbook haproxy.yml

haproxy-check:
	ansible-playbook haproxy.yml --syntax-check

cloudflare-tunnel:
	ansible-playbook cloudflare-tunnel.yml
