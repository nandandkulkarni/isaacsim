#!/bin/bash
echo "=== Part 4: SSH Keys Setup ==="
mkdir -p ~/.ssh
if [ ! -f /workspace/.ssh/authorized_keys ]; then
    mkdir -p /workspace/.ssh
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhG8gMoyn9XvyaPpEKkhz2IY5DkPo3jW66nDRoXfYPw nanda@DESKTOP-LEEOPBS" > /workspace/.ssh/authorized_keys
    chmod 700 /workspace/.ssh
    chmod 600 /workspace/.ssh/authorized_keys
    echo "SSH keys initialized"
fi
cp /workspace/.ssh/authorized_keys ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
echo "SSH keys restored"
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
