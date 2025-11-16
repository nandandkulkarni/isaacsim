# Isaac Sim - Reusable RunPod Setup

## 🚀 Recommended Workflow

### Step 1: First-Time Setup (Do Once)

1. **Create new RunPod** with `nvidia/cuda:12.1.0-devel-ubuntu22.04`

2. **Run initial setup:**
   ```bash
   cd /workspace
   git clone https://github.com/nandandkulkarni/isaacsim.git
   bash /workspace/isaacsim/ubuntu22.04/initial-setup.sh
   ```

3. **Authenticate VS Code** when prompted (one-time only)

4. **Save as RunPod Template:**
   - Stop the pod
   - Go to RunPod dashboard
   - Click "Save as Template"
   - Name it: "Isaac Sim Ubuntu 22.04"

### Step 2: Future Use (Automatic)

1. **Launch from your template** - Everything pre-configured!

2. **Quick restart after pod restarts:**
   ```bash
   bash /workspace/isaacsim/ubuntu22.04/quick-restart.sh
   ```
   
   No authentication, no waiting - just works!

## 📋 What's Included

- ✅ SSH server
- ✅ Xvfb (headless display)
- ✅ VNC + noVNC (web-based desktop)
- ✅ VS Code tunnel (pre-authenticated)
- ✅ Python 3.11 + Isaac Sim venv
- ✅ All services auto-start

## 🎯 Benefits

- **No repeated setup** - Template has everything
- **No authentication prompts** - Credentials saved in `/workspace`
- **Fast restarts** - Services start in seconds
- **Reproducible** - Same environment every time
- **Version controlled** - Scripts in git

## 💡 Pro Tips

1. Keep `/workspace` - it persists your setup
2. Use `quick-restart.sh` for service restarts
3. Update scripts: `cd /workspace/isaacsim && git pull`
4. Create multiple templates for different GPU configs
