#!/bin/bash
echo "=== Part 1: Installing Dependencies ==="

# Check if already installed
if command -v sshd &> /dev/null && [ -d /var/run/sshd ] && command -v git &> /dev/null && command -v Xvfb &> /dev/null && command -v x11vnc &> /dev/null && command -v nginx &> /dev/null && command -v netstat &> /dev/null && command -v xfce4-session &> /dev/null; then
    echo "✓ Dependencies already installed"
    exit 0
fi

apt-get update -qq

echo "Installing base system tools..."
apt-get install -y \
    wget \
    curl \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

echo "Installing OpenSSH Server..."
apt-get install -y openssh-server openssh-client

echo "Installing Git..."
apt-get install -y git

echo "Installing network tools..."
apt-get install -y net-tools iproute2 dnsutils

echo "Installing X11 and VNC tools..."
apt-get install -y xvfb x11vnc

echo "Installing web server (nginx)..."
apt-get install -y nginx

echo "Installing process management tools..."
apt-get install -y supervisor psmisc procps

echo "Installing XFCE desktop environment..."
apt-get install -y xfce4 xfce4-terminal

echo "Verifying SSH setup..."
mkdir -p /var/run/sshd

echo "Part 1 complete: Dependencies installed"
