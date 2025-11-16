#!/bin/bash
echo "=== Part 9: Installing Python 3.11 for Isaac Sim ==="

# Check if Python 3.11 is already installed
if command -v python3.11 &> /dev/null; then
    echo "✓ Python 3.11 already installed"
    python3.11 --version
    exit 0
fi

echo "Installing Python 3.11 from source..."
apt-get update -qq
apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev \
    libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev \
    wget libbz2-dev liblzma-dev

cd /tmp
wget -q https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz
tar -xf Python-3.11.9.tgz
cd Python-3.11.9

echo "Configuring and building Python 3.11.9 (fast mode)..."
./configure --with-ensurepip=install --prefix=/usr/local
make -j$(nproc)
make altinstall

cd /
rm -rf /tmp/Python-3.11.9*

echo "Verifying Python 3.11 installation..."
/usr/local/bin/python3.11 --version

echo "Part 9 complete: Python 3.11 installed"
