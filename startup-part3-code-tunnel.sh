#!/bin/bash
echo "=== Part 3: Code Tunnel ==="

# Restore authentication from workspace
if [ -d /workspace/.vscode-cli ]; then
    mkdir -p ~/.vscode/cli
    cp -r /workspace/.vscode-cli/* ~/.vscode/cli/
    echo "✓ Restored VS Code authentication"
else
    echo "⚠ No saved authentication found - will need to authenticate"
    mkdir -p /workspace/.vscode-cli
fi

# Kill any existing tunnel
pkill -f "code tunnel"
sleep 1

# Start tunnel in background
nohup code tunnel --accept-server-license-terms --name isaac-runpod-vm > /workspace/code-tunnel.log 2>&1 &
sleep 3

# Backup authentication to workspace for next restart
if [ -d ~/.vscode/cli ]; then
    cp -r ~/.vscode/cli /workspace/.vscode-cli
    echo "✓ Saved authentication to /workspace/.vscode-cli"
fi

# Check if running
if pgrep -f "code tunnel" > /dev/null; then
    echo "✓ Code tunnel started successfully"
    echo "Tunnel: isaac-runpod-vm"
else
    echo "✗ Failed to start tunnel"
    tail -20 /workspace/code-tunnel.log
fi
echo "Part 3 complete: Code tunnel setup"
