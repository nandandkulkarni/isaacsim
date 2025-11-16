#!/bin/bash
echo "=== Part 1: Installing Dependencies ==="
apt-get update -qq

echo "Installing OpenSSH Server..."
apt-get install -y openssh-server

echo "Verifying SSH tools..."
which ssh-keygen || apt-get install -y openssh-client
mkdir -p /var/run/sshd

echo "Installing Python 3.11 for Isaac Sim..."
apt-get install -y software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa
apt-get update -qq
apt-get install -y python3.11 python3.11-venv python3.11-dev python3-pip

echo "Setting Python 3.11 as python3 alternative..."
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 2
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

echo "Part 1 complete: Dependencies installed"
