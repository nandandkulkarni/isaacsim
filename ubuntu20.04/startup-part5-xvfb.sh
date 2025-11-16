#!/bin/bash
echo "=== Part 5: Xvfb ==="
if ! pgrep -x "Xvfb" > /dev/null; then
    /usr/bin/Xvfb :1 -screen 0 1920x1080x24 &
    sleep 2
    echo "Xvfb started on :1"
else
    echo "Xvfb already running"
fi
echo "Part 5 complete"
