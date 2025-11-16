#!/bin/bash
echo "=== Part 4: SSH Daemon Setup ==="

# RunPod handles SSH keys automatically at account level
# Just need to ensure host keys exist and start the daemon

if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    echo "Generating SSH host keys..."
    ssh-keygen -A
fi

echo "Starting SSH daemon..."
pkill -9 sshd 2>/dev/null
sleep 1
/usr/sbin/sshd -D &

echo "SSH daemon started on port 22"
echo "Part 4 complete: SSH is ready"
