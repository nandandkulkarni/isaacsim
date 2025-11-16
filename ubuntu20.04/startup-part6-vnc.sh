#!/bin/bash
echo "=== Part 6: VNC Services ==="
if ! pgrep -x "x11vnc" > /dev/null; then
    export DISPLAY=:1
    x11vnc -display :1 -xkb -forever -shared -repeat -capslock -rfbport 5900 &
    sleep 1
    echo "x11vnc started on port 5900"
else
    echo "x11vnc already running"
fi
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
