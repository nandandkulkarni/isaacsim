#!/bin/bash
echo "=== Part 1: Installing Dependencies ==="
apt-get update -qq

echo "Installing OpenSSH Server..."
apt-get install -y openssh-server

echo "Verifying SSH tools..."
which ssh-keygen || apt-get install -y openssh-client
mkdir -p /var/run/sshd

echo "Part 1 complete: Dependencies installed"
