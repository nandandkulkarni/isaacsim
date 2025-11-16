#!/bin/bash
# Launch Isaac Sim

cd /workspace
source /workspace/isaac-venv-py311/bin/activate
export DISPLAY=:1
export OMNI_KIT_ALLOW_ROOT=1

# Use CUDA 12.8 libraries (required for Isaac Sim's bundled PyTorch)
export LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64:/usr/local/cuda-12.8/targets/x86_64-linux/lib:$LD_LIBRARY_PATH

# Preload CUDA 12.8 libraries to ensure they're used first
export LD_PRELOAD=/usr/local/cuda-12.8/targets/x86_64-linux/lib/libnvJitLink.so.12:/usr/local/cuda-12.8/targets/x86_64-linux/lib/libcusparse.so.12:/usr/local/cuda-12.8/targets/x86_64-linux/lib/libcublas.so.12:$LD_PRELOAD

# Create log file with timestamp
LOG_FILE="/workspace/isaac-sim-$(date +%Y%m%d_%H%M%S).log"
echo "Starting Isaac Sim..."
echo "Logging output to: $LOG_FILE"

# Launch Isaac Sim and log both stdout and stderr
isaacsim 2>&1 | tee "$LOG_FILE"
