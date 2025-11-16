#!/bin/bash
echo "=== Part 5: Xvfb ==="

# Check if Xvfb is installed
if ! command -v Xvfb &> /dev/null; then
    echo "✗ Xvfb not installed, skipping"
    echo "Part 5 complete"
    exit 0
fi

if ! pgrep -x "Xvfb" > /dev/null; then
    Xvfb :1 -screen 0 1920x1080x24 &
    sleep 2
    echo "Xvfb started on :1"
else
    echo "Xvfb already running"
fi
echo "Part 5 complete"
