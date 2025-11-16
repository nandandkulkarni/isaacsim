#!/bin/bash
echo "=== Part 10: Isaac Sim Virtual Environment ==="

# Create venv if it doesn't exist
if [ ! -d /workspace/isaac-venv ]; then
    echo "Creating Python 3.11 virtual environment..."
    # Use python3.11 from /usr/local/bin or PATH
    if command -v python3.11 &> /dev/null; then
        python3.11 -m venv /workspace/isaac-venv
    elif [ -f /usr/local/bin/python3.11 ]; then
        /usr/local/bin/python3.11 -m venv /workspace/isaac-venv
    else
        echo "✗ Python 3.11 not found. Please run Part 9 first."
        exit 1
    fi
    echo "✓ Virtual environment created"
else
    echo "✓ Virtual environment already exists"
fi

# Activate venv
source /workspace/isaac-venv/bin/activate

# Verify activation
if [ -n "$VIRTUAL_ENV" ]; then
    echo "✓ Virtual environment activated: $VIRTUAL_ENV"
    python --version
else
    echo "✗ Failed to activate virtual environment"
    exit 1
fi

echo "Part 10 complete: Isaac Sim venv ready"
