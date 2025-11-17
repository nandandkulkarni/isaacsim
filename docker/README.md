# Isaac Sim Docker Build

This directory contains the Dockerfile and related files for building a comprehensive Isaac Sim Docker image.

## What's Included

- **Isaac Sim 5.1.0** - Full installation with Python API
- **ROS 2 Humble** - Desktop + Navigation2 + SLAM Toolbox + MoveIt
- **TurboVNC 3.1.1** - Remote 3D graphics viewing (port 5901, password: `IsaacSim2025!`)
- **CUDA 12.8** - GPU acceleration configured
- **Python Dev Tools** - Jupyter, IPython, black, pylint, pytest
- **ML Libraries** - PyTorch, gymnasium, stable-baselines3, wandb
- **Robot Models** - Directory structure for URDF/USD files at `/opt/robots/`
- **Scripts** - All scripts from the isaacsim repository

## Building the Image

### Quick Build

```bash
cd /workspace/isaacsim/docker
bash build.sh
```

### Manual Build

```bash
cd /workspace/isaacsim/docker
docker build -t isaac-sim-full:5.1.0 .
```

**Build time:** 30-60 minutes  
**Final size:** ~50-60GB

## Running the Container

### With VNC (GUI access)

```bash
docker run -d --gpus all \
  -p 5901:5901 \
  -p 8888:8888 \
  --name isaac-sim \
  isaac-sim-full:5.1.0
```

Connect with VNC viewer to `localhost:5901` (password: `IsaacSim2025!`)

### Headless (Python scripts only)

```bash
docker run --rm --gpus all \
  -v $(pwd)/scripts:/workspace/scripts \
  isaac-sim-full:5.1.0 \
  python3 /workspace/scripts/your_script.py
```

### Interactive Shell

```bash
docker run -it --gpus all isaac-sim-full:5.1.0 /bin/bash
```

## Testing the Image

```bash
# Test Python API
docker run --rm --gpus all isaac-sim-full:5.1.0 \
  python3 -c "from isaacsim import SimulationApp; print('✓ Isaac Sim OK')"

# Test CUDA
docker run --rm --gpus all isaac-sim-full:5.1.0 \
  python3 -c "import torch; print('CUDA available:', torch.cuda.is_available())"

# Test ROS 2
docker run --rm --gpus all isaac-sim-full:5.1.0 \
  bash -c "source /opt/ros/humble/setup.bash && ros2 --version"
```

## Saving and Loading

### Save to file

```bash
docker save isaac-sim-full:5.1.0 | gzip > /workspace/isaac-sim-full-5.1.0.tar.gz
```

### Load from file

```bash
docker load < /workspace/isaac-sim-full-5.1.0.tar.gz
```

### Push to Docker Hub

```bash
docker tag isaac-sim-full:5.1.0 YOUR_USERNAME/isaac-sim:5.1.0
docker push YOUR_USERNAME/isaac-sim:5.1.0
```

## Environment Variables

The container sets the following environment variables:

- `OMNI_KIT_ALLOW_ROOT=1` - Allow Isaac Sim to run as root
- `DISPLAY=:1` - VNC display
- `CUDA_HOME=/usr/local/cuda-12.8` - CUDA toolkit location
- `LD_LIBRARY_PATH` - CUDA libraries configured
- `LD_PRELOAD` - CUDA 12.8 libraries preloaded for Isaac Sim

## Ports Exposed

- `5901` - TurboVNC server
- `6080` - noVNC web interface (if configured)
- `8888` - Jupyter Lab
- `47995-48012` - Isaac Sim livestream
- `49000-49007` - Isaac Sim additional services

## Directory Structure

```
/workspace/              # Working directory (mount your code here)
/opt/isaacsim/          # Cloned isaacsim repository
/opt/robots/            # Robot models (URDF/USD)
/opt/startup_scripts/   # Startup scripts from repo
/root/.vnc/             # VNC configuration
```

## Troubleshooting

### Build fails on CUDA installation

The base image `nvcr.io/nvidia/isaac-sim:5.1.0` already includes CUDA. If the CUDA installation step fails, it may be redundant and can be commented out.

### Container won't start

Check GPU availability:
```bash
docker run --rm --gpus all nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi
```

### VNC connection refused

Make sure port 5901 is exposed:
```bash
docker ps -a  # Check port mappings
```

## Updating the Image

To rebuild with latest code from GitHub:

```bash
cd /workspace/isaacsim/docker
docker build --no-cache -t isaac-sim-full:5.1.0 .
```

The git clone happens in a late layer, so most cached layers will be reused.

## Files

- `Dockerfile` - Main image definition
- `.dockerignore` - Files to exclude from build context
- `build.sh` - Build script
- `README.md` - This file
- `build-notes/PROJECT-STATUS.md` - Project documentation
