#!/bin/bash
echo "=== Part 9: Installing Python 3.11 for Isaac Sim ==="

echo "Installing Python 3.11..."
apt-get install -y software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa
apt-get update -qq
apt-get install -y python3.11 python3.11-venv python3.11-dev python3-pip

echo "Setting Python 3.11 as python3 alternative..."
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 2
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

echo "Verifying Python installation..."
python3 --version

echo "Part 9 complete: Python 3.11 installed"
