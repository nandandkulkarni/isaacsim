#!/bin/bash
bash /workspace/isaacsim/ubuntu22.04/startup-part0-cache.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part1-install.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part2-install-vscode.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part3-code-tunnel.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part4-ssh.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part5-xvfb.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part6-vnc.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part6a-desktop.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part7-web.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part8-vscode.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part9-python.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part10-isaac-venv.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part11-cuda-auto.sh

# Isaac Sim CUDA 12.8 setup (must run after Isaac Sim first launch)
echo ""
echo "================================================"
echo "Isaac Sim CUDA Setup"
echo "================================================"
echo "Note: Run 'bash /workspace/isaacsim/ubuntu22.04/setup-isaac-cuda.sh'"
echo "      after first Isaac Sim launch to fix CUDA libraries."
echo "================================================"
