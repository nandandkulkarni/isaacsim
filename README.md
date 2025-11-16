# Isaac Sim Development Environment

Complete setup for NVIDIA Isaac Sim on RunPod with automated startup scripts, video capture tools, and documentation.

---

## 📁 Repository Structure

```
/workspace/isaacsim/
├── README.md                    # This file
├── docs/                        # Documentation
│   ├── SETUP.md                # Complete technical setup guide
│   ├── QUICKREF.md             # Quick reference commands
│   ├── HEADLESS_VIDEO_CAPTURE.md  # Video capture workflow
│   ├── DOWNLOAD_CACHE_SETUP.md    # Cache management guide
│   └── SOFTWARE_AUDIT_REPORT.md   # Installed packages audit
├── launcher/                    # Launch scripts
│   ├── launch-isaac-sim.sh     # Start Isaac Sim GUI
│   └── run-test.sh             # Run test scripts
├── scripts/                     # Python scripts
│   ├── examples/               # Example simulations
│   │   ├── test_rotating_bouncing_cube.py  # Video capture demo
│   │   └── test_headless_capture.py        # Headless capture
│   ├── tests/                  # Test scripts
│   │   ├── test_headless.py           # Headless verification
│   │   └── test_headless_simple.py    # Simple headless test
│   └── utilities/              # Utility scripts
│       └── convert-frames-to-video.sh  # PNG to MP4 converter
└── ubuntu22.04/                # Startup automation (Ubuntu 22.04)
    ├── startup.sh              # Main startup orchestrator
    ├── startup-part0-cache.sh  # Cache setup (runs first)
    ├── startup-part1-install.sh    # System packages
    ├── startup-part10-isaac-venv.sh # Isaac Sim setup
    ├── startup-part11-cuda-auto.sh  # CUDA auto-install
    └── setup-isaac-cuda.sh     # CUDA 12.8 installer
```

---

## 🚀 Quick Start

### First Time Setup

1. **Start RunPod** with Ubuntu 22.04 GPU instance

2. **Clone repository:**
   ```bash
   cd /workspace
   git clone https://github.com/nandandkulkarni/isaacsim.git
   ```

3. **Run automated startup:**
   ```bash
   bash /workspace/isaacsim/ubuntu22.04/startup.sh
   ```
   Wait 3-5 minutes for all services to start.

4. **Install CUDA 12.8** (if not auto-installed):
   ```bash
   bash /workspace/isaacsim/ubuntu22.04/setup-isaac-cuda.sh
   ```

### Every Restart

Startup scripts run automatically. If needed, manually run:
```bash
bash /workspace/isaacsim/ubuntu22.04/startup.sh
```

---

## 🎮 Running Isaac Sim

### GUI Mode (with VNC)

```bash
cd /workspace
source isaac-venv-py311/bin/activate
/workspace/isaacsim/launcher/launch-isaac-sim.sh
```

### Headless Mode with Video Capture

```bash
cd /workspace
source isaac-venv-py311/bin/activate
python /workspace/isaacsim/scripts/examples/test_rotating_bouncing_cube.py

# Convert frames to video
/workspace/isaacsim/scripts/utilities/convert-frames-to-video.sh my_video.mp4
```

### Run Test Scripts

```bash
/workspace/isaacsim/launcher/run-test.sh /workspace/isaacsim/scripts/tests/test_headless.py
```

---

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| [SETUP.md](docs/SETUP.md) | Complete technical setup guide with troubleshooting |
| [QUICKREF.md](docs/QUICKREF.md) | Quick command reference card |
| [HEADLESS_VIDEO_CAPTURE.md](docs/HEADLESS_VIDEO_CAPTURE.md) | Video capture workflow and examples |
| [DOWNLOAD_CACHE_SETUP.md](docs/DOWNLOAD_CACHE_SETUP.md) | Download caching system (17GB saved per restart) |
| [SOFTWARE_AUDIT_REPORT.md](docs/SOFTWARE_AUDIT_REPORT.md) | Complete software inventory |

---

## 🔧 Key Features

### Automated Startup
- ✅ All services auto-start on pod restart
- ✅ Download cache persists (19GB: pip, Isaac Sim, CUDA)
- ✅ CUDA 12.8 auto-installs from cache (~2 min)
- ✅ No manual intervention needed

### Development Environment
- **Python:** 3.11 in virtual environment
- **Isaac Sim:** 5.1.0 (pip installation)
- **CUDA:** 12.8 with proper library linking
- **GPU:** NVIDIA drivers with RTX support
- **Desktop:** XFCE4 + VNC access

### Remote Access
- **SSH:** Port configured in startup scripts
- **VNC:** x11vnc on port 5901
- **Web VNC:** noVNC for browser access
- **VS Code:** Tunnel for remote development

### Video Capture
- **Headless rendering:** Ray-traced lighting
- **Frame capture:** PNG sequence via omni.replicator
- **Video conversion:** Automated ffmpeg encoding
- **Resolution:** 1920x1080 @ 60fps

---

## 💾 Persistent Storage

Everything in `/workspace/` persists across RunPod restarts:

- `isaac-venv-py311/` - Python virtual environment (2.6GB)
- `downloads/` - Download cache (19GB total)
  - `pip/` - Python packages (2.6GB)
  - `ov/` - Isaac Sim extensions (14GB)
  - `ov-cache/` - Omniverse runtime (645MB)
  - `apt-archives/` - CUDA packages (1.9GB)
- `isaac_captures/` - Captured simulation frames/videos
- `isaacsim/` - This repository

**Ephemeral:** Root filesystem (/) is recreated on restart, hence the need for startup scripts.

---

## 🎬 Example: Create & Capture Video

```bash
# 1. Activate environment
cd /workspace
source isaac-venv-py311/bin/activate

# 2. Run simulation with capture
python /workspace/isaacsim/scripts/examples/test_rotating_bouncing_cube.py

# 3. Convert to video
/workspace/isaacsim/scripts/utilities/convert-frames-to-video.sh my_animation.mp4 60

# 4. Download video
# Option A: VS Code - Right-click /workspace/isaac_captures/my_animation.mp4 → Download
# Option B: SCP - scp -P <port> root@<host>:/workspace/isaac_captures/my_animation.mp4 .
```

**Result:** 10-second video of rotating & bouncing cube with ray-traced lighting, ~4MB MP4 file.

---

## 🛠️ Troubleshooting

### CUDA Library Errors
```bash
# Reinstall CUDA 12.8 and fix library links
bash /workspace/isaacsim/ubuntu22.04/setup-isaac-cuda.sh
```

### Isaac Sim Won't Start
```bash
# Check environment
source /workspace/isaac-venv-py311/bin/activate
python -c "import isaacsim; print('OK')"

# Reinstall if needed
pip install --force-reinstall isaacsim-app isaacsim-core isaacsim-gui
```

### Missing Services After Restart
```bash
# Re-run startup scripts
bash /workspace/isaacsim/ubuntu22.04/startup.sh
```

### Video Conversion Fails
```bash
# Check frames exist
ls /workspace/isaac_captures/rgb_*.png | wc -l

# Manual conversion
cd /workspace/isaac_captures
ffmpeg -framerate 60 -i rgb_%04d.png -c:v libx264 -pix_fmt yuv420p output.mp4
```

---

## 📊 System Requirements

- **GPU:** NVIDIA RTX series (tested on RTX 4000 Ada)
- **CUDA:** 12.8 (auto-installed)
- **RAM:** 16GB+ recommended
- **Storage:** 50GB+ for Isaac Sim and cache
- **OS:** Ubuntu 22.04

---

## 🔄 Updating

```bash
cd /workspace/isaacsim
git pull
```

Restart services if startup scripts were updated:
```bash
bash /workspace/isaacsim/ubuntu22.04/startup.sh
```

---

## 📝 Notes

- **First startup:** Takes ~5 minutes (downloads Isaac Sim extensions)
- **Subsequent startups:** ~2 minutes (uses cached data)
- **CUDA auto-install:** Requires Isaac Sim extensions to be downloaded first
- **Cache saves:** 17GB of downloads per restart
- **All automation:** 85% of setup is automated (see SOFTWARE_AUDIT_REPORT.md)

---

## 🤝 Contributing

This is a personal development environment. Feel free to fork and adapt for your needs.

---

## 📜 License

Scripts and documentation are provided as-is for educational and development purposes.

**NVIDIA Isaac Sim** is subject to its own license terms.

---

**Last Updated:** November 16, 2025
