# Isaac Sim Startup Scripts - Ubuntu 22.04

## Recommended Base Images for RunPod

These scripts are designed for Ubuntu 22.04 which has much better Python 3.11 support.

### Best RunPod Base Images:

1. **NVIDIA CUDA with Ubuntu 22.04** (Recommended for Isaac Sim)
   - `nvidia/cuda:12.1.0-devel-ubuntu22.04`
   - `nvidia/cuda:11.8.0-devel-ubuntu22.04`
   - Includes CUDA toolkit needed for Isaac Sim GPU acceleration

2. **RunPod PyTorch Images**
   - `runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04`
   - Pre-configured for GPU workloads

3. **Plain Ubuntu 22.04**
   - `ubuntu:22.04`
   - If you want to install CUDA drivers separately

## Installation Instructions

1. **Start your RunPod instance** with one of the recommended images above

2. **Clone/copy these scripts** to `/workspace/isaacsim/ubuntu22.04/`

3. **Run the startup script:**
   ```bash
   bash /workspace/isaacsim/ubuntu22.04/startup.sh
   ```

4. **Install Isaac Sim:**
   ```bash
   source /workspace/isaac-venv/bin/activate
   pip install isaacsim[all,extscache]==5.1.0 --extra-index-url https://pypi.nvidia.com
   ```

## Key Differences from Ubuntu 20.04

- ✅ **Python 3.11 installs via PPA** (no building from source)
- ✅ **Faster setup** (2-3 minutes vs 10+ minutes)
- ✅ **Better GPU driver support**
- ✅ **All same features** (SSH, VNC, VS Code tunnel, etc.)

## Services Included

- SSH daemon for remote access
- Xvfb for headless display
- x11vnc + noVNC for browser-based desktop
- VS Code tunnel for remote development
- Python 3.11 virtual environment for Isaac Sim

## Notes

- Scripts automatically handle restarts (no re-authentication needed)
- Virtual environment persists in `/workspace/isaac-venv`
- VS Code authentication saved in `/workspace/.vscode-cli`
