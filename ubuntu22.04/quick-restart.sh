#!/bin/bash
# Quick restart script - Use this after pod restarts
echo "=== Isaac Sim Quick Restart ==="

# Just restart services (credentials already saved)
bash /workspace/isaacsim/ubuntu22.04/startup-part4-ssh.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part5-xvfb.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part6-vnc.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part7-web.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part3-code-tunnel.sh
bash /workspace/isaacsim/ubuntu22.04/startup-part10-isaac-venv.sh

echo ""
echo "=== Services Started ==="
echo "SSH: ssh root@\${RUNPOD_PUBLIC_IP} -p \${RUNPOD_TCP_PORT_22}"
echo "VS Code Tunnel: isaac-runpod-vm"
echo "VNC: Port 5900"
echo "Isaac Sim venv: source /workspace/isaac-venv/bin/activate"
