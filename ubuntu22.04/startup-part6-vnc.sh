#!/bin/bash
echo "=== Part 6: VNC Services ==="

# Check if x11vnc is installed
if ! command -v x11vnc &> /dev/null; then
    echo "✗ x11vnc not installed, skipping"
    echo "Part 6 complete"
    exit 0
fi

# Start x11vnc if not running
if ! pgrep -x "x11vnc" > /dev/null; then
    export DISPLAY=:1
    x11vnc -display :1 -xkb -forever -shared -repeat -capslock -rfbport 5901 &
    sleep 1
    echo "x11vnc started on port 5901"
else
    echo "x11vnc already running"
fi

# Start noVNC if available
if ! pgrep -f "websockify.*6081" > /dev/null; then
    if [ -f /usr/local/lib/web/frontend/static/novnc/utils/launch.sh ]; then
        bash /usr/local/lib/web/frontend/static/novnc/utils/launch.sh --listen 6081 &
        sleep 1
        echo "noVNC started on port 6081"
    fi
else
    echo "noVNC already running"
fi

echo "Part 6 complete"
