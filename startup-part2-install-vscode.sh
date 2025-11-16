#!/bin/bash
echo "=== Part 2: Installing VS Code ==="

# Check if VS Code is already installed
if command -v code &> /dev/null; then
    echo "VS Code is already installed"
    code --version
    exit 0
fi

# Install dependencies
echo "Installing dependencies..."
apt-get update -qq
apt-get install -y wget gpg apt-transport-https

# Add Microsoft GPG key
echo "Adding Microsoft repository..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
rm /tmp/packages.microsoft.gpg

# Add VS Code repository
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null

# Install VS Code
echo "Installing VS Code..."
apt-get update -qq
apt-get install -y code

# Verify installation
if command -v code &> /dev/null; then
    echo "✓ VS Code installed successfully"
    code --version
else
    echo "✗ VS Code installation failed"
    exit 1
fi

echo "Part 2 complete: VS Code Installation Complete"
