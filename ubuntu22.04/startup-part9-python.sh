#!/bin/bash
echo "=== Part 9: Installing Python 3.11 for Isaac Sim ==="

# Check if Python 3.11 is already installed
if command -v python3.11 &> /dev/null; then
    echo "✓ Python 3.11 already installed"
    python3.11 --version
    exit 0
fi

echo "Installing Python 3.11 from apt..."
apt-get update -qq
apt-get install -y software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa
apt-get update -qq
apt-get install -y python3.11 python3.11-venv python3.11-dev python3-pip

echo "Verifying Python 3.11 installation..."
python3.11 --version

echo "Part 9 complete: Python 3.11 installed"
