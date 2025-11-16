#!/bin/bash
# Run Isaac Sim test scripts

cd /workspace
source /workspace/isaac-venv-py311/bin/activate
export DISPLAY=:1
export OMNI_KIT_ALLOW_ROOT=1

# Use CUDA 12.8 libraries
export LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64:/usr/local/cuda-12.8/targets/x86_64-linux/lib:$LD_LIBRARY_PATH
export LD_PRELOAD=/usr/local/cuda-12.8/targets/x86_64-linux/lib/libnvJitLink.so.12:/usr/local/cuda-12.8/targets/x86_64-linux/lib/libcusparse.so.12:/usr/local/cuda-12.8/targets/x86_64-linux/lib/libcublas.so.12:$LD_PRELOAD

echo "Running Isaac Sim test: $1"
python "$1"
