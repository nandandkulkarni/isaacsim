#!/bin/bash
echo "=== Part 0: Configure Download Cache ==="

# Create workspace downloads structure
mkdir -p /workspace/downloads/{pip,ov,debs,archives,cuda}

# Setup pip cache symlink (pip cache persists across reboots)
if [ -d /root/.cache/pip ] && [ ! -L /root/.cache/pip ]; then
    echo "Moving pip cache to /workspace/downloads/pip..."
    cp -a /root/.cache/pip/* /workspace/downloads/pip/ 2>/dev/null
    rm -rf /root/.cache/pip
    ln -s /workspace/downloads/pip /root/.cache/pip
    echo "✓ Pip cache configured"
elif [ ! -e /root/.cache/pip ]; then
    mkdir -p /root/.cache
    ln -s /workspace/downloads/pip /root/.cache/pip
    echo "✓ Pip cache symlink created"
else
    echo "✓ Pip cache already configured"
fi

# Setup Omniverse/Isaac Sim data symlink (stores extensions, kit data)
if [ -d /root/.local/share/ov ] && [ ! -L /root/.local/share/ov ]; then
    echo "Moving Isaac Sim data to /workspace/downloads/ov (may take 1-2 minutes)..."
    cp -a /root/.local/share/ov /workspace/downloads/ 2>/dev/null
    rm -rf /root/.local/share/ov
    ln -s /workspace/downloads/ov /root/.local/share/ov
    echo "✓ Isaac Sim data configured"
elif [ ! -e /root/.local/share/ov ]; then
    mkdir -p /root/.local/share
    ln -s /workspace/downloads/ov /root/.local/share/ov
    echo "✓ Isaac Sim data symlink created"
else
    echo "✓ Isaac Sim data already configured"
fi

# Setup Omniverse cache symlink
if [ -d /root/.cache/ov ] && [ ! -L /root/.cache/ov ]; then
    echo "Moving Omniverse cache to /workspace/downloads/ov-cache..."
    mkdir -p /workspace/downloads/ov-cache
    cp -a /root/.cache/ov/* /workspace/downloads/ov-cache/ 2>/dev/null
    rm -rf /root/.cache/ov
    ln -s /workspace/downloads/ov-cache /root/.cache/ov
    echo "✓ Omniverse cache configured"
elif [ ! -e /root/.cache/ov ]; then
    mkdir -p /root/.cache
    mkdir -p /workspace/downloads/ov-cache
    ln -s /workspace/downloads/ov-cache /root/.cache/ov
    echo "✓ Omniverse cache symlink created"
else
    echo "✓ Omniverse cache already configured"
fi

# Setup APT cache for .deb files (optional, helps with CUDA reinstalls)
mkdir -p /workspace/downloads/apt-archives
if [ ! -L /var/cache/apt/archives ] && [ -d /var/cache/apt/archives ]; then
    # Don't move existing files, just set up for future downloads
    echo "✓ APT cache directory ready at /workspace/downloads/apt-archives"
fi

echo "Part 0 complete: Download caching configured"
echo "  Pip cache: /workspace/downloads/pip ($(du -sh /workspace/downloads/pip 2>/dev/null | cut -f1))"
echo "  Isaac Sim: /workspace/downloads/ov ($(du -sh /workspace/downloads/ov 2>/dev/null | cut -f1))"
echo "  Downloads persist across RunPod restarts"
