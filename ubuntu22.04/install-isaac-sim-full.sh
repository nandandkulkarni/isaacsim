#!/bin/bash
# Isaac Sim Full Installation Script
# Downloads and installs Isaac Sim from NVIDIA

set -e

ISAAC_DIR="/workspace/isaac-sim"
DOWNLOAD_DIR="/workspace/downloads"

echo "=== Isaac Sim Full Installation ==="
echo ""

# Check if already installed
if [ -d "${ISAAC_DIR}" ] && [ -f "${ISAAC_DIR}/isaac-sim.sh" ]; then
    echo "✓ Isaac Sim already installed at ${ISAAC_DIR}"
    echo "To reinstall, remove the directory first: rm -rf ${ISAAC_DIR}"
    exit 0
fi

# Create directories
mkdir -p ${DOWNLOAD_DIR}
mkdir -p ${ISAAC_DIR}

echo "Step 1: Installing NGC CLI..."
pip install ngc-cli

echo ""
echo "Step 2: NGC Configuration"
echo "You need to configure NGC with your API key"
echo ""
echo "To get your API key:"
echo "  1. Go to: https://ngc.nvidia.com/setup/api-key"
echo "  2. Sign in with your NVIDIA account"
echo "  3. Generate an API key"
echo ""
read -p "Press Enter after you have your API key ready..."
echo ""

# Configure NGC
ngc config set

echo ""
echo "Step 3: Downloading Isaac Sim..."
echo "This will download ~30GB and may take 30-60 minutes"
echo ""

cd ${DOWNLOAD_DIR}
ngc registry resource download-version "nvidia/isaac-sim:4.2.0"

echo ""
echo "Step 4: Extracting Isaac Sim to ${ISAAC_DIR}..."

# Find the downloaded file and extract
if [ -f "${DOWNLOAD_DIR}/isaac-sim_4.2.0/isaac-sim.tar.gz" ]; then
    tar -xzf "${DOWNLOAD_DIR}/isaac-sim_4.2.0/isaac-sim.tar.gz" -C ${ISAAC_DIR} --strip-components=1
    echo "✓ Isaac Sim extracted successfully"
elif [ -d "${DOWNLOAD_DIR}/isaac-sim_4.2.0" ]; then
    mv ${DOWNLOAD_DIR}/isaac-sim_4.2.0/* ${ISAAC_DIR}/
    echo "✓ Isaac Sim moved successfully"
else
    echo "✗ Could not find downloaded files"
    echo "Please check ${DOWNLOAD_DIR}"
    exit 1
fi

echo ""
echo "Step 5: Setting up environment..."
cat >> ~/.bashrc << 'EOF'

# Isaac Sim Environment
export ISAAC_SIM_PATH="/workspace/isaac-sim"
alias isaac-sim="${ISAAC_SIM_PATH}/isaac-sim.sh"
EOF

echo "✓ Environment setup complete"
echo ""
echo "=== Installation Complete ==="
echo "Isaac Sim is installed at: ${ISAAC_DIR}"
echo ""
echo "To run Isaac Sim:"
echo "  cd ${ISAAC_DIR}"
echo "  ./isaac-sim.sh"
echo ""
echo "Or use the alias: isaac-sim"
echo ""

