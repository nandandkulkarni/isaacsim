#!/bin/bash
echo "=== Part 1: Installing Dependencies ==="

# Check if already installed
if command -v sshd &> /dev/null && [ -d /var/run/sshd ] && command -v git &> /dev/null; then
    echo "✓ Dependencies already installed"
    exit 0
fi

apt-get update -qq

echo "Installing OpenSSH Server..."
apt-get install -y openssh-server

echo "Installing Git..."
apt-get install -y git

echo "Verifying SSH tools..."
which ssh-keygen || apt-get install -y openssh-client
mkdir -p /var/run/sshd

echo "Part 1 complete: Dependencies installed"
