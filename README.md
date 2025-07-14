# Kali SSH Docker Container

## Overview
Secure and hardened Kali Linux container with:
- SSH key-based access (no passwords)
- Hardened SSH configs (root login only via keys)
- Pentesting tools installed
- Persistent workspace with Docker volume
- fail2ban monitoring
- Easy Docker Compose deployment

## Usage

```bash
git clone https://github.com/YOUR_USERNAME/kali-ssh.git
cd kali-ssh
cat ~/.ssh/id_rsa.pub > authorized_keys
docker-compose up -d --build
