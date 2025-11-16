#!/bin/bash
echo "=== Part 11: Auto-Install CUDA 12.8 (if needed) ==="

# Only run if Isaac Sim extensions are already downloaded
ML_ARCHIVE_PATH="/root/.local/share/ov/data/Kit/Isaac-Sim Full/5.1/exts/3"
ML_ARCHIVE_DIR=$(find "$ML_ARCHIVE_PATH" -maxdepth 1 -type d -name "omni.isaac.ml_archive-*" 2>/dev/null | head -1)

if [ -z "$ML_ARCHIVE_DIR" ]; then
    echo "ℹ Isaac Sim extensions not yet downloaded, skipping CUDA 12.8 auto-install"
    echo "  Run 'bash /workspace/isaacsim/ubuntu22.04/setup-isaac-cuda.sh' after first Isaac Sim launch"
    exit 0
fi

# Check if CUDA 12.8 is installed
if [ -d "/usr/local/cuda-12.8" ]; then
    echo "✓ CUDA 12.8 already installed"
    exit 0
fi

# Check if we have cached CUDA debs
CUDA_CACHE="/workspace/downloads/apt-archives"
if [ -d "$CUDA_CACHE" ] && [ "$(find "$CUDA_CACHE" -name "cuda-toolkit-12-8*.deb" | wc -l)" -gt 0 ]; then
    echo "Found cached CUDA 12.8 packages, installing..."
    
    apt-get update -qq
    apt-get install -y -o Dir::Cache::archives="$CUDA_CACHE/" cuda-toolkit-12-8
    
    echo "✓ CUDA 12.8 installed from cache"
    echo "  Now running setup-isaac-cuda.sh to configure libraries..."
    
    bash /workspace/isaacsim/ubuntu22.04/setup-isaac-cuda.sh
else
    echo "ℹ No cached CUDA packages found"
    echo "  Run: bash /workspace/isaacsim/ubuntu22.04/setup-isaac-cuda.sh"
fi

echo "Part 11 complete"
