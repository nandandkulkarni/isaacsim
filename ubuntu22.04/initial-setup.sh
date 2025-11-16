#!/bin/bash
# One-time setup script - Run this ONCE on a fresh pod, then save as template
echo "=== Isaac Sim Complete Setup - Run Once ==="

cd /workspace
git clone https://github.com/nandandkulkarni/isaacsim.git 2>/dev/null || cd isaacsim && git pull

echo "Running full installation..."
bash /workspace/isaacsim/ubuntu22.04/startup.sh

echo ""
echo "=== IMPORTANT: Authentication Required ==="
echo "The VS Code tunnel needs authentication."
echo "Follow the prompts above to authenticate."
echo ""
echo "After authentication completes:"
echo "1. Stop the pod"
echo "2. Save as RunPod template"
echo "3. Future pods will start automatically without prompts"
echo ""
