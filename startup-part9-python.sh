#!/bin/bash
echo "=== Part 9: Installing Python Environment for Isaac Sim ==="

# Check if already installed
if dpkg -l | grep -q python3-venv; then
    echo "✓ Python venv already installed"
    python3 --version
    exit 0
fi

echo "Installing Python venv and pip..."
apt-get update -qq
apt-get install -y python3-venv python3-pip

echo "Verifying Python installation..."
python3 --version

echo "Part 9 complete: Python environment ready"
