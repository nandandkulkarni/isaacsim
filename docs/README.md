# Isaac Sim Development Environment

NVIDIA Isaac Sim 5.1.0 running on RunPod with GPU support via VNC.

## 📚 Documentation

- **[SETUP.md](isaacsim/SETUP.md)** - Complete setup guide with technical details
- **[QUICKREF.md](isaacsim/QUICKREF.md)** - Quick reference for common tasks
- **[HEADLESS_VIDEO_CAPTURE.md](isaacsim/HEADLESS_VIDEO_CAPTURE.md)** - Video capture from headless simulations
- **[DOWNLOAD_CACHE_SETUP.md](isaacsim/DOWNLOAD_CACHE_SETUP.md)** - Download cache configuration
- **[SOFTWARE_AUDIT_REPORT.md](isaacsim/SOFTWARE_AUDIT_REPORT.md)** - Complete software inventory

## 🚀 Quick Start

### On Every RunPod Restart

1. **Wait for startup scripts** (automatic)
2. **Run CUDA setup** (after first Isaac Sim launch):
   ```bash
   bash /workspace/isaacsim/ubuntu22.04/setup-isaac-cuda.sh
   ```

### Launch Isaac Sim

```bash
/workspace/isaacsim/launch-isaac-sim.sh
```

Connect via VNC to see the GUI.

### Run Test Script

```bash
/workspace/isaacsim/run-test.sh /workspace/isaacsim/scripts/test_simple_scene.py
```

### Headless Video Capture

```bash
# 1. Run capture script
python /workspace/isaacsim/test_rotating_bouncing_cube.py

# 2. Convert frames to video
/workspace/isaacsim/convert-frames-to-video.sh my_video.mp4 60
```

## 🔧 Key Files

| File | Purpose |
|------|---------|
| `isaacsim/launch-isaac-sim.sh` | Launch Isaac Sim GUI |
| `isaacsim/run-test.sh` | Run Python scripts with proper environment |
| `isaacsim/convert-frames-to-video.sh` | Convert captured frames to MP4 video |
| `isaacsim/test_rotating_bouncing_cube.py` | Example headless video capture |
| `isaacsim/ubuntu22.04/setup-isaac-cuda.sh` | Fix CUDA library conflicts |
| `isaacsim/ubuntu22.04/startup.sh` | Main startup orchestration |
| `isaac-venv-py311/` | Python virtual environment |

## 📝 Important Notes

- **Persistent Storage**: `/workspace` persists across restarts
  - Python packages: `/workspace/isaac-venv-py311/`
  - Downloads cache: `/workspace/downloads/` (pip, Isaac Sim data, CUDA debs)
  - All downloads are cached and reused across restarts
- **Ephemeral Storage**: Root filesystem (`/`) is recreated on each restart
- **CUDA 12.8**: Auto-installs from cache if Isaac Sim is already set up
- **VNC Port**: Internal 5901 → Check RunPod dashboard for external mapping

## 🐛 Common Issues

| Issue | Solution |
|-------|----------|
| CUDA symbol errors | Run `setup-isaac-cuda.sh` |
| Black screen in VNC | Run `startup-part6a-desktop.sh` |
| Extensions not loading | Wait for first launch to download, then run CUDA setup |

## 📦 Stack

- Ubuntu 22.04
- CUDA 12.8
- Python 3.11.14
- Isaac Sim 5.1.0 (pip installation)
- XFCE4 Desktop
- x11vnc

## 🔗 Links

- [Isaac Sim Documentation](https://docs.isaacsim.omniverse.nvidia.com/latest/)
- [GitHub Repository](https://github.com/nandandkulkarni/isaacsim)

---

Last Updated: 2025-11-16
