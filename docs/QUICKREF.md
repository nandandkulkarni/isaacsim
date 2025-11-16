# Isaac Sim RunPod - Quick Reference

## On Every RunPod Restart

### 1. Wait for Startup Scripts to Complete
The startup sequence runs automatically. Wait for completion.

### 2. Run CUDA Setup (After First Isaac Sim Launch)
```bash
bash /workspace/isaacsim/ubuntu22.04/setup-isaac-cuda.sh
```
**Note**: This only works after Isaac Sim has been launched once and downloaded its extensions.

## Common Commands

### Launch Isaac Sim GUI
```bash
/workspace/isaacsim/launcher/launch-isaac-sim.sh
```

### Run Python Test Script
```bash
/workspace/isaacsim/launcher/run-test.sh /workspace/isaacsim/scripts/tests/test_simple_scene.py
```

### Check Logs
```bash
ls -t /workspace/isaac-sim-*.log | head -1 | xargs tail -100
```

### Activate Virtual Environment
```bash
source /workspace/isaac-venv-py311/bin/activate
```

## VNC Connection
- **Check External Port**: RunPod dashboard → Connect → TCP Port Mappings
- **Internal Port**: 5901 maps to external port (e.g., 24657)
- **Connect**: `<runpod-ip>:<external-port>` in VNC viewer

## Troubleshooting

### "undefined symbol: __nvJitLinkCreate_12_8"
Run CUDA setup: `bash /workspace/isaacsim/ubuntu22.04/setup-isaac-cuda.sh`

### Black Screen in VNC
```bash
bash /workspace/isaacsim/ubuntu22.04/startup-part6a-desktop.sh
```

### Git Not Configured
```bash
cd /workspace/isaacsim
git config user.name "nandandkulkarni"
git config user.email "nandandkulkarni@gmail.com"
```

## File Locations

| Path | Description |
|------|-------------|
| `/workspace/isaacsim/README.md` | Main overview and quick start |
| `/workspace/isaacsim/docs/SETUP.md` | Complete setup documentation |
| `/workspace/isaacsim/launcher/launch-isaac-sim.sh` | Main Isaac Sim launcher |
| `/workspace/isaacsim/launcher/run-test.sh` | Test script runner |
| `/workspace/isaacsim/scripts/utilities/convert-frames-to-video.sh` | Video conversion utility |
| `/workspace/isaacsim/scripts/examples/` | Example simulation scripts |
| `/workspace/isaacsim/scripts/tests/` | Test scripts |
| `/workspace/isaacsim/ubuntu22.04/setup-isaac-cuda.sh` | CUDA library fix |
| `/workspace/isaac-venv-py311/` | Python virtual environment |
| `/workspace/isaac-sim-*.log` | Application logs |

## Environment Variables (Auto-set by launcher)
```bash
DISPLAY=:1
OMNI_KIT_ALLOW_ROOT=1
LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64:...
LD_PRELOAD=/usr/local/cuda-12.8/targets/x86_64-linux/lib/libnvJitLink.so.12:...
```

## Status Check
```bash
# Check CUDA
ls -la /usr/local/cuda

# Check VNC
ps aux | grep x11vnc

# Check Desktop
ps aux | grep xfce

# Check Isaac Sim venv
ls -la /workspace/isaac-venv-py311/
```
