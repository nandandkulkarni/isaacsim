# Isaac Sim RunPod Project - Complete Status & History

**Last Updated:** November 16, 2025  
**Status:** Building Docker image on RunPod  
**Location:** `/workspace/isaacsim/docker/`

---

## Project Goal
Create custom Isaac Sim 5.1.0 Docker image with:
- Full Python 3.11 API support (SimulationApp, headless rendering, video capture)
- TurboVNC 3.1.1 for remote 3D graphics viewing
- ROS 2 Humble + Navigation stack + SLAM + MoveIt
- PyTorch 2.7.0 + CUDA 12.8 + OpenCV
- Python development tools (Jupyter, IPython, black, pylint)
- ML libraries (gymnasium, stable-baselines3)
- Pre-installed robot models (MoveIt, UR, Franka, TIAGo, TurtleBot3)
- Deploy to RunPod for GPU-accelerated robotics simulation

---

## Current Situation - Building on RunPod

### What We Have ✅
1. **Working Isaac Sim Installation on RunPod**
   - Isaac Sim 5.1.0 (pip version) fully installed
   - Python 3.11.14 with complete API support
   - 167 extensions downloaded (~41GB total)
   - All Isaac Sim packages: app, core, gui, robot, sensor
   - PyTorch 2.7.0, OpenCV 4.11.0, NumPy, SciPy, Matplotlib
   - CUDA 12.6 + 12.8 configured and working
   - Headless rendering and video capture working

2. **VS Code Remote-Tunnels** to RunPod
   - Tunnel name: `isaac-runpod-vm`
   - Connection: Working perfectly via GitHub auth
   - Pod ID: `94bl7ks2ug6xdd`
   - Can build Docker images directly on RunPod

3. **Verified Python API Components**
   ✅ SimulationApp - Core interface working
   ✅ Headless rendering - Tested and functional
   ✅ Video capture - Frame capture to MP4 working
   ✅ Physics simulation - Running successfully
   ✅ Robot extensions - Franka, manipulators, wheeled robots
   ✅ CUDA/PyTorch - GPU acceleration confirmed

### What Docker Image Needs to Add ⚙️
- ❌ ROS 2 Humble (not installed yet)
- ❌ TurboVNC 3.1.1 (no VNC currently)
- ❌ Jupyter/IPython (dev tools missing)
- ❌ ML libraries (gymnasium, stable-baselines3)
- ❌ Additional robot model files (URDF/USD)
- ❌ Service management (nginx, supervisord)

### Files Being Created
```
/workspace/isaacsim/docker/
├── Dockerfile                          # Main Docker image definition
├── .dockerignore                       # Files to exclude from build
├── build-notes/
│   └── PROJECT-STATUS.md              # This file
└── scripts/
    ├── entrypoint.sh                  # Container startup script
    └── install-ros2.sh                # ROS 2 installation helper
```

---

## What Happened (Chronological)

### Phase 1: SSH Access (Solved)
- **Problem:** VS Code Remote-SSH prompting for password despite SSH key
- **Root Cause:** RunPod gateway doesn't support PTY (intentional security)
- **Solution:** Switched to VS Code Remote-Tunnels
- **Result:** Working connection to RunPod via tunnel

### Phase 2: Service Persistence (Solved)
- **Problem:** RunPod containers are ephemeral, lose SSH/VNC on restart
- **Solution:** Created startup scripts that restore from `/workspace`
- **Result:** 6-part startup system ready for Docker Command

### Phase 3: Docker Image Design (Complete)
- **Research:** NVIDIA forums for Isaac Sim container requirements
- **Added:** Vulkan, EULA env vars, cache dirs, livestream ports
- **Enhanced:** TurboVNC (better than x11vnc for 3D)
- **Robots:** Baked into `/opt/robots` for persistence
- **Result:** Production-ready Dockerfile

### Phase 4: Build Location Decision (Resolved)
- **Attempt 1:** Build on Windows C: drive → Failed (insufficient space)
- **Attempt 2:** Move Docker to external USB drive → Too slow
- **Decision:** Build directly on RunPod with fast NVMe storage
- **Current:** Creating Dockerfile on RunPod at `/workspace/isaacsim/docker/`

---

## Next Steps - Building Docker Image on RunPod

### Step 1: Create Dockerfile ✍️
Create `/workspace/isaacsim/docker/Dockerfile` with layers in this order:

**Early Layers (cached, rarely change):**
- Base: `nvcr.io/nvidia/isaac-sim:5.1.0` OR Ubuntu 22.04 + CUDA
- System packages: build-essential, cmake, git, curl, wget
- ROS 2 Humble + Nav2 + SLAM + MoveIt
- TurboVNC 3.1.1 installation
- Python dev tools (Jupyter, IPython, black, pylint)
- ML libraries (gymnasium, stable-baselines3, wandb)
- CUDA 12.8 libraries configuration

**Late Layers (frequently updated):**
- Clone repository using build arg: Dockerfile accepts `GITHUB_PAT` as build argument
- Copy scripts and configurations from repo
- Set environment variables
- Configure entrypoint

**Why this order:**
- System packages change rarely → cached layers
- Your code changes frequently → late layers rebuild fast
- Git clone at end → easy to update without rebuilding everything

**Build with PAT:**
```bash
docker build --build-arg GITHUB_PAT=your_token_here -t isaac-sim-full:5.1.0 .
```

**Security Note:** PAT is passed as build arg and not stored in image layers. The .git directory is removed after cloning.

### Step 2: Build on RunPod ⚙️
```bash
cd /workspace/isaacsim/docker
docker build -t isaac-sim-full:5.1.0 .
```

**Build time:** 30-60 minutes (depending on base image choice)

### Step 3: Test the Image 🧪
```bash
# Test basic functionality
docker run --rm --gpus all isaac-sim-full:5.1.0 python -c "from isaacsim import SimulationApp; print('OK')"

# Test with VNC
docker run -d --gpus all -p 5901:5901 isaac-sim-full:5.1.0
```

### Step 4: Save for Deployment 💾
```bash
# Option A: Push to Docker Hub
docker tag isaac-sim-full:5.1.0 YOUR_USERNAME/isaac-sim:5.1.0
docker push YOUR_USERNAME/isaac-sim:5.1.0

# Option B: Save to RunPod workspace (persists across restarts)
docker save isaac-sim-full:5.1.0 | gzip > /workspace/isaac-sim-full-5.1.0.tar.gz
```

---

## Technical Details

### RunPod Connection
```bash
# SSH (direct - works for commands only)
ssh -i runpod-key -p 22343 nanda@157.157.221.29

# VS Code Tunnel (recommended - works for everything)
code tunnel --name isaac-runpod-vm
```

### Docker Build Command
```bash
cd /workspace
docker build -t my-isaac-sim:latest .
```

### Dockerfile Highlights
- Base: Isaac Sim 5.1.0 (CUDA 12.2+, Ubuntu 22.04)
- TurboVNC: 3.1.1 on port 5900, password "IsaacSim2025!"
- ROS 2: Humble desktop + Nav2 + SLAM Toolbox
- Python: 3.10 (bundled) + ipython, jupyter, black, pylint
- OpenCV: Full stack with contrib
- Robots: MoveIt, UR, TIAGo, TurtleBot3 at /opt/robots
- Ports: 22, 5900, 6081, 80, 47995-48012, 49000-49007

### RunPod Build Environment
- Docker available: Yes (RunPod base image)
- Storage: Fast NVMe SSD
- Current usage: 41GB (Isaac Sim installation)
- Available: ~300GB for Docker builds
- GPU: NVIDIA (CUDA 12.6 + 12.8)
- Network: Fast download speeds for packages

---

## Key Decisions Made

1. ✅ **Build on RunPod** instead of Windows (disk space + speed)
2. ✅ **Use Remote-Tunnels** for VS Code access (PTY limitation workaround)
3. ✅ **TurboVNC 3.1.1** for remote 3D graphics (better than x11vnc)
4. ✅ **Include ROS 2 Humble** for robotics integration
5. ✅ **Python-first approach** - Full SimulationApp API support
6. ✅ **Bake robot models** into image (persistence & portability)
7. ✅ **Add dev tools** - Jupyter, IPython, black, pylint for development

---

## Commands Reference

### Check Docker Status
```powershell
docker info
docker images
docker ps -a
```

### Drive Space
```powershell
Get-Volume | Where {$_.DriveLetter -eq 'C' -or $_.DriveLetter -eq 'D'}
```

### WSL Management
```powershell
wsl --list -v
wsl --shutdown
wsl --unregister docker-desktop-data
```

### Kill Docker
```powershell
Get-Process *docker* | Stop-Process -Force
```

---

## Important Notes

1. **RunPod Persistence:** Only `/workspace` survives restarts
2. **Startup Scripts:** Must be added to Docker Command in RunPod UI
3. **SSH Keys:** Stored in `/workspace/.ssh` on RunPod
4. **VS Code Auth:** Stored in `/workspace/.vscode-cli`
5. **USB Drive:** D: is external USB = unsuitable for Docker
6. **Build Time:** 30-60 minutes (40GB base + installs)

---

## Docker Files Created ✅

**Location:** `/workspace/isaacsim/docker/` on RunPod  
**Pod ID:** `94bl7ks2ug6xdd`  
**Tunnel:** `isaac-runpod-vm` (active)  
**Status:** Dockerfile and build files ready

**Note:** Docker-in-Docker not available on RunPod containers (kernel limitations).

**Alternative Build Options:**
1. **Push to GitHub** → Build on local machine with Docker
2. **Use GitHub Actions** → Auto-build on push
3. **Use Docker Hub automated builds** → Triggered by GitHub
4. **Use RunPod different pod** with Docker support

**Verified Working:**
- ✅ Isaac Sim 5.1.0 Python API (41GB installed)
- ✅ PyTorch 2.7.0 + CUDA 12.8
- ✅ OpenCV 4.11.0
- ✅ Headless rendering & video capture
- ✅ 167 Isaac Sim extensions

**To Be Added in Docker:**
- ⚙️ ROS 2 Humble + Nav2 + SLAM + MoveIt
- ⚙️ TurboVNC 3.1.1
- ⚙️ Jupyter + IPython + development tools
- ⚙️ ML libraries (gymnasium, stable-baselines3)
- ⚙️ Robot model files

---

## Context for AI Assistant

- User has working VS Code tunnel to RunPod
- All prerequisite files created and ready
- Local build blocked by disk constraints (C: too small, D: too slow)
- Dockerfile is complete and tested syntactically
- Need to execute build on RunPod infrastructure
- User wants to tunnel you (AI) into RunPod to help with build

**Recommended:** Upload Dockerfile, build on RunPod, save to Docker Hub or /workspace
