#!/bin/bash
echo "=== Part 7: Web Services ==="

# Start nginx if installed
if command -v nginx &> /dev/null; then
    if ! pgrep -x "nginx" > /dev/null; then
        systemctl start nginx 2>/dev/null || service nginx start 2>/dev/null || nginx
        echo "Nginx started"
    else
        echo "Nginx already running"
    fi
else
    echo "✗ Nginx not installed, skipping"
fi

# Start supervisord if installed
if command -v supervisord &> /dev/null; then
    if ! pgrep -x "supervisord" > /dev/null; then
        supervisord -c /etc/supervisor/supervisord.conf 2>/dev/null
        echo "Supervisord started"
    else
        echo "Supervisord already running"
    fi
else
    echo "✗ Supervisord not installed, skipping"
fi

echo "Part 7 complete"
