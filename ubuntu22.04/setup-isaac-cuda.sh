#!/bin/bash
# Automated setup for Isaac Sim on RunPod restart
# Run this script after each RunPod instance restart
# Location: /workspace/isaacsim/ubuntu22.04/setup-isaac-cuda.sh

set -e  # Exit on error

echo "================================================"
echo "Isaac Sim CUDA 12.8 Setup - RunPod Ephemeral Fix"
echo "================================================"
echo ""

# 1. Install CUDA 12.8
echo "[1/3] Installing CUDA 12.8..."
if [ ! -d "/usr/local/cuda-12.8" ]; then
    # Configure APT to cache .deb files in workspace
    mkdir -p /workspace/downloads/apt-archives
    
    echo "  Updating package list..."
    apt-get update -qq
    
    echo "  Downloading CUDA 12.8 toolkit..."
    echo "  (Downloads cached to /workspace/downloads/apt-archives for future restarts)"
    
    # Download .debs to workspace cache
    apt-get install -y --download-only -o Dir::Cache::archives="/workspace/downloads/apt-archives/" cuda-toolkit-12-8
    
    # Install from cache
    apt-get install -y -o Dir::Cache::archives="/workspace/downloads/apt-archives/" cuda-toolkit-12-8
    
    echo "✓ CUDA 12.8 installed (cached for future use)"
else
    echo "✓ CUDA 12.8 already installed"
fi

# 2. Verify Isaac Sim ml_archive extension exists
echo ""
echo "[2/3] Checking Isaac Sim installation..."
ML_ARCHIVE_PATH="/root/.local/share/ov/data/Kit/Isaac-Sim Full/5.1/exts/3"
ML_ARCHIVE_DIR=$(find "$ML_ARCHIVE_PATH" -maxdepth 1 -type d -name "omni.isaac.ml_archive-*" 2>/dev/null | head -1)

if [ -z "$ML_ARCHIVE_DIR" ]; then
    echo "⚠ Isaac Sim extensions not yet downloaded."
    echo "  They will be downloaded on first Isaac Sim launch."
    echo "  Run this script again after first launch."
    exit 0
fi

echo "✓ Found: $ML_ARCHIVE_DIR"

# 3. Replace bundled CUDA libraries with CUDA 12.8 symlinks
echo ""
echo "[3/3] Replacing bundled CUDA libraries..."

NVIDIA_DIR="$ML_ARCHIVE_DIR/pip_prebundle/nvidia"

if [ ! -d "$NVIDIA_DIR" ]; then
    echo "✗ NVIDIA directory not found: $NVIDIA_DIR"
    exit 1
fi

# Function to replace library
replace_lib() {
    local lib_path="$1"
    local lib_name="$2"
    local cuda_lib="$3"
    
    if [ -f "$lib_path/$lib_name" ] && [ ! -L "$lib_path/$lib_name" ]; then
        echo "  Replacing $lib_name..."
        mv "$lib_path/$lib_name" "$lib_path/${lib_name}.old" 2>/dev/null || true
        ln -sf "$cuda_lib" "$lib_path/$lib_name"
        echo "  ✓ $lib_name -> $cuda_lib"
    elif [ -L "$lib_path/$lib_name" ]; then
        echo "  ✓ $lib_name already symlinked"
    else
        echo "  ⚠ $lib_name not found at $lib_path"
    fi
}

# Replace libnvJitLink
replace_lib "$NVIDIA_DIR/nvjitlink/lib" "libnvJitLink.so.12" \
    "/usr/local/cuda-12.8/targets/x86_64-linux/lib/libnvJitLink.so.12.8.93"

# Replace libcusparse
replace_lib "$NVIDIA_DIR/cusparse/lib" "libcusparse.so.12" \
    "/usr/local/cuda-12.8/targets/x86_64-linux/lib/libcusparse.so.12"

# Replace libcublas
replace_lib "$NVIDIA_DIR/cublas/lib" "libcublas.so.12" \
    "/usr/local/cuda-12.8/targets/x86_64-linux/lib/libcublas.so.12"

replace_lib "$NVIDIA_DIR/cublas/lib" "libcublasLt.so.12" \
    "/usr/local/cuda-12.8/targets/x86_64-linux/lib/libcublasLt.so.12"

# Replace libnvrtc
replace_lib "$NVIDIA_DIR/cuda_nvrtc/lib" "libnvrtc.so.12" \
    "/usr/local/cuda-12.8/targets/x86_64-linux/lib/libnvrtc.so.12"

echo ""
echo "================================================"
echo "✓ Setup complete!"
echo "================================================"
echo ""
echo "You can now launch Isaac Sim:"
echo "  /workspace/isaacsim/launcher/launch-isaac-sim.sh"
echo ""
