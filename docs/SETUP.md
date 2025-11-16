# Isaac Sim on RunPod - Complete Setup Guide

## Overview
This guide documents the complete setup for running NVIDIA Isaac Sim 5.1.0 (pip installation) on RunPod with GPU support via VNC.

## System Configuration
- **Platform**: RunPod GPU instance
- **OS**: Ubuntu 22.04
- **GPU**: NVIDIA RTX 4000 Ada Generation
- **CUDA**: 12.8 (upgraded from 12.6)
- **Python**: 3.11.14
- **Storage**: /workspace (persistent network volume)

## Critical Setup Steps

### 1. CUDA 12.8 Installation
Isaac Sim 5.1.0's bundled PyTorch requires CUDA 12.8. The default RunPod image has CUDA 12.6.

```bash
apt-get update
apt-get install -y cuda-toolkit-12-8
```

**Why**: Isaac Sim's bundled PyTorch (in `omni.isaac.ml_archive`) requires `libnvJitLink` with symbols from CUDA 12.8. Using older versions causes `undefined symbol: __nvJitLinkCreate_12_8` errors.

### 2. Replace Bundled CUDA Libraries
The pip installation includes older CUDA libraries that conflict with system libraries.

```bash
cd /root/.local/share/ov/data/Kit/Isaac-Sim\ Full/5.1/exts/3/omni.isaac.ml_archive-3.0.4+107.3.3.lx64.cp311/pip_prebundle/nvidia

# Replace libnvJitLink
cd nvjitlink/lib
mv libnvJitLink.so.12 libnvJitLink.so.12.old
ln -s /usr/local/cuda-12.8/targets/x86_64-linux/lib/libnvJitLink.so.12.8.93 libnvJitLink.so.12

# Replace libcusparse
cd ../../cusparse/lib
mv libcusparse.so.12 libcusparse.so.12.old
ln -s /usr/local/cuda-12.8/targets/x86_64-linux/lib/libcusparse.so.12 libcusparse.so.12

# Replace libcublas
cd ../../cublas/lib
mv libcublas.so.12 libcublas.so.12.old
ln -s /usr/local/cuda-12.8/targets/x86_64-linux/lib/libcublas.so.12 libcublas.so.12
mv libcublasLt.so.12 libcublasLt.so.12.old
ln -s /usr/local/cuda-12.8/targets/x86_64-linux/lib/libcublasLt.so.12 libcublasLt.so.12

# Replace libnvrtc
cd ../../cuda_nvrtc/lib
mv libnvrtc.so.12 libnvrtc.so.12.old
ln -s /usr/local/cuda-12.8/targets/x86_64-linux/lib/libnvrtc.so.12 libnvrtc.so.12
```

**Why**: The bundled libraries are from an older CUDA version and cause symbol resolution failures. Symlinking to system CUDA 12.8 libraries resolves these conflicts.

### 3. Python Virtual Environment
```bash
python3.11 -m venv /workspace/isaac-venv-py311
source /workspace/isaac-venv-py311/bin/activate
pip install --upgrade pip
```

### 4. Isaac Sim Installation
```bash
# Install base Isaac Sim
pip install isaacsim[all,extscache]==5.1.0 --extra-index-url https://pypi.nvidia.com

# Install additional required packages for Python scripting
pip install isaacsim-app isaacsim-core isaacsim-gui isaacsim-robot isaacsim-sensor --extra-index-url https://pypi.nvidia.com
```

**Required Packages**:
- `isaacsim-app` - Application framework and SimulationApp class
- `isaacsim-core` - Core APIs and physics
- `isaacsim-gui` - GUI components
- `isaacsim-robot` - Robot models and controllers
- `isaacsim-sensor` - Sensor simulation

**Note**: The pip installation is lighter (~7GB) compared to the full binary installation (~30GB) but requires online registry access for some extensions.

### 5. Desktop Environment (for VNC)
```bash
apt-get install -y xfce4 xfce4-goodies
```

**Startup Script**: `/workspace/isaacsim/ubuntu22.04/startup-part6a-desktop.sh`

### 6. Launch Configuration

**Environment Variables Required**:
```bash
export DISPLAY=:1
export OMNI_KIT_ALLOW_ROOT=1
export LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64:/usr/local/cuda-12.8/targets/x86_64-linux/lib:$LD_LIBRARY_PATH
export LD_PRELOAD=/usr/local/cuda-12.8/targets/x86_64-linux/lib/libnvJitLink.so.12:/usr/local/cuda-12.8/targets/x86_64-linux/lib/libcusparse.so.12:/usr/local/cuda-12.8/targets/x86_64-linux/lib/libcublas.so.12:$LD_PRELOAD
```

**Why LD_PRELOAD**: Forces the system to load CUDA 12.8 libraries before any bundled versions, preventing runtime symbol resolution errors.

## Launch Scripts

### Main Application
`/workspace/launch-isaac-sim.sh` - Launches full Isaac Sim GUI with logging

### Test Runner
`/workspace/run-test.sh <script.py>` - Runs Python scripts with proper environment

### Example Test
`/workspace/isaacsim/scripts/test_simple_scene.py` - Creates cube and sphere with physics

## Known Issues & Warnings

### Non-Critical Warnings (Safe to Ignore)
- `prometheus_client` module not found - Optional monitoring features
- ROS2 Bridge startup failed - Requires separate ROS2 setup
- Audio device misconfigured - Expected in headless/VNC environment
- NGX context failures - NVIDIA RTX features (DLSS) not critical for basic operation

### Critical Errors to Watch For
- `undefined symbol: __nvJitLinkCreate_12_8` - CUDA library version mismatch
- `Inconsistency detected by ld.so` - Library loading order issue
- `SimulationApp is None` - Missing Isaac Sim app packages

## File Locations

### Persistent Storage (/workspace)
- `/workspace/isaac-venv-py311/` - Python virtual environment
- `/workspace/isaacsim/` - Scripts and startup configurations
- `/workspace/launch-isaac-sim.sh` - Main launcher
- `/workspace/run-test.sh` - Test script runner
- `/workspace/isaac-sim-*.log` - Application logs

### Ephemeral Storage (Root Filesystem)
- `/root/.local/share/ov/data/Kit/Isaac-Sim Full/5.1/` - Downloaded extensions (regenerated on restart)
- `/usr/local/cuda-12.8/` - System CUDA installation (must reinstall on restart)
- XFCE desktop, system packages (must reinstall on restart)

## Startup Sequence

The startup scripts in `/workspace/isaacsim/ubuntu22.04/` run in this order:
1. `startup-part1-install.sh` - System packages (git, xvfb, vnc, nginx, xfce4)
2. `startup-part2-install-vscode.sh` - VS Code installation
3. `startup-part3-code-tunnel.sh` - VS Code tunnel setup
4. `startup-part4-ssh.sh` - SSH configuration
5. `startup-part5-xvfb.sh` - Virtual display (Xvfb on :1)
6. `startup-part6-vnc.sh` - VNC server (x11vnc on port 5901)
7. `startup-part6a-desktop.sh` - XFCE desktop startup
8. `startup-part7-web.sh` - Nginx/supervisord
9. `startup-part8-vscode.sh` - VS Code server
10. `startup-part9-python.sh` - Python environment
11. `startup-part10-isaac-venv.sh` - Isaac Sim Python virtual environment

## Important Notes

### On Every RunPod Restart
You must re-run these steps because root filesystem is ephemeral:
1. Install CUDA 12.8: `apt-get install -y cuda-toolkit-12-8`
2. Replace bundled CUDA libraries (symlink script above)
3. Run startup scripts: `/workspace/isaacsim/ubuntu22.04/startup.sh`

The `/workspace` directory persists, so Isaac Sim pip installation and virtual environment remain intact.

### VNC Access
- **Internal Port**: 5901
- **External Port**: Check RunPod dashboard (e.g., 24657)
- **Connection**: `<runpod-ip>:<external-port>` in VNC viewer
- **No Password Required**

### Git Configuration
```bash
cd /workspace/isaacsim
git config user.name "nandandkulkarni"
git config user.email "nandandkulkarni@gmail.com"
git remote set-url origin https://github.com/nandandkulkarni/isaacsim
```

## Testing Isaac Sim

### GUI Test
```bash
/workspace/launch-isaac-sim.sh
```
Wait for "app ready" message, then interact with GUI via VNC.

### Python Script Test
```bash
/workspace/run-test.sh /workspace/isaacsim/scripts/test_simple_scene.py
```
Creates a scene with physics-enabled cube and sphere. Click Play (▶) in viewport to see simulation.

## Troubleshooting

### Isaac Sim Won't Start
1. Check logs: `ls -t /workspace/isaac-sim-*.log | head -1 | xargs tail -100`
2. Verify CUDA 12.8: `ls -la /usr/local/cuda`
3. Check symlinks: `ls -la /root/.local/share/ov/data/Kit/Isaac-Sim\ Full/5.1/exts/3/omni.isaac.ml_archive-*/pip_prebundle/nvidia/*/lib/*.so.12`

### Black Screen in VNC
Desktop not started. Run: `/workspace/isaacsim/ubuntu22.04/startup-part6a-desktop.sh`

### Extension Download Failures
Isaac Sim pip version downloads extensions on first run. Requires internet connectivity and can take several minutes.

## Version Information
- **Isaac Sim**: 5.1.0
- **Kit Version**: 107.3.3
- **USD Version**: 24.05
- **Python**: 3.11
- **CUDA**: 12.8
- **Last Updated**: 2025-11-16

## References
- [Isaac Sim Documentation](https://docs.isaacsim.omniverse.nvidia.com/latest/)
- [Isaac Sim Python Installation](https://docs.isaacsim.omniverse.nvidia.com/latest/installation/install_python.html)
- [Isaac Sim Quick Start Tutorial](https://docs.isaacsim.omniverse.nvidia.com/latest/introduction/quickstart_isaacsim.html)
