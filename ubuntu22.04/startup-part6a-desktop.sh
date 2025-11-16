#!/bin/bash
echo "=== Part 6a: Desktop Environment ==="

# Check if XFCE is installed
if ! command -v xfce4-session &> /dev/null; then
    echo "✗ XFCE not installed, skipping"
    echo "Part 6a complete"
    exit 0
fi

# Start XFCE if not running
if ! pgrep -x "xfce4-session" > /dev/null; then
    export DISPLAY=:1
    startxfce4 > /dev/null 2>&1 &
    sleep 2
    echo "XFCE desktop started on display :1"
else
    echo "XFCE desktop already running"
fi

echo "Part 6a complete"
