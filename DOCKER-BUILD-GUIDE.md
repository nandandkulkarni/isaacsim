# Docker Image Build Guide - Isaac Sim 5.1.0

This guide walks you through building a complete Docker image for Isaac Sim with ROS 2, TurboVNC, and Python development tools.

---

## 📋 Prerequisites

Before you begin, ensure you have:

1. **Docker installed** on your build machine
   - Windows: [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Mac: [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Linux: `curl -fsSL https://get.docker.com | sh`

2. **NVIDIA GPU** and drivers (for running the container)
   - Install [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

3. **GitHub Personal Access Token** (PAT)
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Select scopes: `repo` (all)
   - Copy the token (you'll need it for building)

4. **Disk space**: At least 60GB free

---

## 🚀 Quick Start

### Step 1: Clone the Repository

```bash
git clone https://github.com/nandandkulkarni/isaacsim.git
cd isaacsim/docker
```

### Step 2: Set Your GitHub PAT

```bash
# Linux/Mac
export GITHUB_PAT=your_github_token_here

# Windows PowerShell
$env:GITHUB_PAT="your_github_token_here"

# Windows CMD
set GITHUB_PAT=your_github_token_here
```

**Replace** `your_github_token_here` with your actual GitHub Personal Access Token.

### Step 3: Build the Docker Image

```bash
# Using the build script (recommended)
bash build.sh

# Or manually with docker build
docker build --build-arg GITHUB_PAT=$GITHUB_PAT -t isaac-sim-full:5.1.0 .
```

**Build time:** 30-60 minutes  
**Final image size:** ~50-60GB

---

## 📦 What's Included

The Docker image contains:

| Component | Version | Description |
|-----------|---------|-------------|
| **Isaac Sim** | 5.1.0 | Full Python API with SimulationApp |
| **Python** | 3.11 | With complete Isaac Sim packages |
| **ROS 2** | Humble | Desktop + Nav2 + SLAM + MoveIt |
| **CUDA** | 12.8 | GPU acceleration configured |
| **TurboVNC** | 3.1.1 | Remote 3D graphics (port 5901) |
| **PyTorch** | 2.7.0 | Deep learning framework |
| **OpenCV** | Latest | Computer vision library |
| **Jupyter** | Latest | Interactive development |
| **ML Tools** | - | gymnasium, stable-baselines3, wandb |

---

## 🎯 Running the Container

### Option 1: With GUI (VNC Access)

```bash
docker run -d \
  --name isaac-sim \
  --gpus all \
  -p 5901:5901 \
  -p 8888:8888 \
  -v $(pwd)/workspace:/workspace \
  isaac-sim-full:5.1.0
```

**Connect with VNC:**
- Address: `localhost:5901`
- Password: `IsaacSim2025!`
- Use any VNC client (RealVNC, TigerVNC, TurboVNC Viewer)

### Option 2: Headless (Python Scripts Only)

```bash
docker run --rm \
  --gpus all \
  -v $(pwd)/scripts:/workspace/scripts \
  isaac-sim-full:5.1.0 \
  python3 /workspace/scripts/your_script.py
```

### Option 3: Interactive Shell

```bash
docker run -it \
  --gpus all \
  -v $(pwd)/workspace:/workspace \
  isaac-sim-full:5.1.0 \
  /bin/bash
```

Inside the container:
```bash
# Run Isaac Sim Python API
python3 -c "from isaacsim import SimulationApp; print('Isaac Sim Ready!')"

# Source ROS 2
source /opt/ros/humble/setup.bash
ros2 --version

# Start Jupyter Lab
jupyter lab --ip=0.0.0.0 --allow-root
```

---

## ✅ Testing the Image

After building, verify everything works:

### Test 1: Isaac Sim Python API
```bash
docker run --rm --gpus all isaac-sim-full:5.1.0 \
  python3 -c "from isaacsim import SimulationApp; print('✓ Isaac Sim OK')"
```

### Test 2: CUDA GPU Access
```bash
docker run --rm --gpus all isaac-sim-full:5.1.0 \
  python3 -c "import torch; print('CUDA available:', torch.cuda.is_available())"
```

### Test 3: ROS 2 Installation
```bash
docker run --rm --gpus all isaac-sim-full:5.1.0 \
  bash -c "source /opt/ros/humble/setup.bash && ros2 --version"
```

### Test 4: VNC Server
```bash
docker run -d --gpus all -p 5901:5901 --name test-vnc isaac-sim-full:5.1.0
# Connect with VNC viewer to localhost:5901
docker stop test-vnc && docker rm test-vnc
```

---

## 💾 Saving and Sharing

### Save to File

```bash
# Save the image
docker save isaac-sim-full:5.1.0 | gzip > isaac-sim-full-5.1.0.tar.gz

# Later, load it on another machine
docker load < isaac-sim-full-5.1.0.tar.gz
```

### Push to Docker Hub

```bash
# Login to Docker Hub
docker login

# Tag the image
docker tag isaac-sim-full:5.1.0 YOUR_USERNAME/isaac-sim:5.1.0

# Push to registry
docker push YOUR_USERNAME/isaac-sim:5.1.0
```

### Use on RunPod

1. Push image to Docker Hub (see above)
2. Create new RunPod pod with custom image: `YOUR_USERNAME/isaac-sim:5.1.0`
3. Or upload compressed image to RunPod and load it:
```bash
docker load < isaac-sim-full-5.1.0.tar.gz
```

---

## 🔧 Customization

### Adding More Python Packages

Edit `Dockerfile` in the "Stage 6" section:

```dockerfile
RUN pip3 install --no-cache-dir \
    your-package-here \
    another-package
```

### Adding Robot Models

Place URDF/USD files in the image:

```dockerfile
# In Dockerfile, Stage 8
COPY ./robot_models/*.urdf /opt/robots/urdf/
COPY ./robot_models/*.usd /opt/robots/usd/
```

### Changing VNC Password

Edit the entrypoint script or modify during build:

```dockerfile
RUN echo "YourNewPassword" | /opt/TurboVNC/bin/vncpasswd -f > /root/.vnc/passwd
```

---

## 🐛 Troubleshooting

### Build Fails: "Cannot fetch rule set generation id"

**Issue:** Docker daemon permission errors  
**Solution:** Make sure Docker daemon is running with proper permissions:
```bash
sudo systemctl start docker
sudo usermod -aG docker $USER
# Log out and back in
```

### Build Fails: "No space left on device"

**Issue:** Insufficient disk space  
**Solution:** Clean up Docker and free space:
```bash
docker system prune -a
docker volume prune
```

### Container Won't Start: GPU Errors

**Issue:** NVIDIA runtime not configured  
**Solution:** Install NVIDIA Container Toolkit:
```bash
# Ubuntu/Debian
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

### VNC Connection Refused

**Issue:** Port not exposed or VNC not started  
**Solution:** Check container logs and port mapping:
```bash
docker logs isaac-sim
docker ps  # Check port mappings
```

### Import Error: "No module named isaacsim"

**Issue:** Isaac Sim packages didn't install  
**Solution:** The base image includes Isaac Sim. If using a different base, install:
```bash
pip install isaacsim==5.1.0 --extra-index-url https://pypi.nvidia.com
```

---

## 📁 Directory Structure

Inside the container:

```
/workspace/              # Mount your code here
/opt/isaacsim/          # Cloned isaacsim repository
/opt/robots/            # Robot models
  ├── urdf/            # URDF files
  ├── usd/             # USD files
  └── meshes/          # Mesh files
/opt/ros/humble/        # ROS 2 installation
/opt/TurboVNC/          # VNC server
/root/.vnc/             # VNC configuration
```

---

## 🔐 Security Notes

- **GitHub PAT:** Never commit your PAT to the repository. It's passed as a build argument.
- **VNC Password:** Change the default password (`IsaacSim2025!`) for production use.
- **Root User:** Container runs as root by default. For production, create a non-root user.

---

## 📚 Additional Resources

- **Isaac Sim Documentation:** https://docs.isaacsim.omniverse.nvidia.com/
- **ROS 2 Humble Docs:** https://docs.ros.org/en/humble/
- **Docker Documentation:** https://docs.docker.com/
- **TurboVNC Guide:** https://turbovnc.org/Documentation

---

## 🆘 Getting Help

If you encounter issues:

1. Check the [troubleshooting section](#-troubleshooting) above
2. Review Docker logs: `docker logs <container-name>`
3. Open an issue on GitHub: https://github.com/nandandkulkarni/isaacsim/issues

---

## 📝 Example Workflow

Here's a complete example from start to finish:

```bash
# 1. Clone repository
git clone https://github.com/nandandkulkarni/isaacsim.git
cd isaacsim/docker

# 2. Set GitHub PAT
export GITHUB_PAT=ghp_your_token_here

# 3. Build image (30-60 minutes)
bash build.sh

# 4. Test the build
docker run --rm --gpus all isaac-sim-full:5.1.0 \
  python3 -c "from isaacsim import SimulationApp; print('✓ Ready!')"

# 5. Run with VNC for GUI development
docker run -d \
  --name isaac-dev \
  --gpus all \
  -p 5901:5901 \
  -p 8888:8888 \
  -v $(pwd)/../scripts:/workspace/scripts \
  isaac-sim-full:5.1.0

# 6. Connect with VNC to localhost:5901
# Password: IsaacSim2025!

# 7. Or access Jupyter at http://localhost:8888

# 8. When done, stop and remove
docker stop isaac-dev
docker rm isaac-dev
```

---

**Built with ❤️ for robotics simulation and development**

Last Updated: November 16, 2025
