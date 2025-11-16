#!/bin/bash
echo "=== Part 8: VS Code Server ==="
if [ -d ~/.vscode-server ]; then
    echo "VS Code Server installed"
elif [ -d /workspace/.vscode-server ]; then
    ln -sf /workspace/.vscode-server ~/.vscode-server
    echo "Symlink created"
else
    mkdir -p /workspace/.vscode-server
    echo "VS Code Server directory created"
fi
sleep 2
echo ""
echo "=== All Services Status ==="
echo "SSHD:   $(pgrep -f "/usr/sbin/sshd" > /dev/null && echo '✓' || echo '✗')"
echo "Xvfb:   $(pgrep -x Xvfb > /dev/null && echo '✓' || echo '✗')"
echo "VNC:    $(pgrep -x x11vnc > /dev/null && echo '✓' || echo '✗')"
echo "noVNC:  $(pgrep -f websockify > /dev/null && echo '✓' || echo '✗')"
echo "Nginx:  $(pgrep -x nginx > /dev/null && echo '✓' || echo '✗')"
echo ""
echo "SSH: ssh root@${RUNPOD_PUBLIC_IP} -p ${RUNPOD_TCP_PORT_22}"
echo "=== Startup Complete ==="
