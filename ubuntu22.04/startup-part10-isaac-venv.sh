#!/bin/bash
echo "=== Part 10: Isaac Sim Virtual Environment ==="

# Create venv if it doesn't exist
if [ ! -d /workspace/isaac-venv-py311 ]; then
    echo "Creating Python 3.11 virtual environment..."
    if command -v python3.11 &> /dev/null; then
        python3.11 -m venv /workspace/isaac-venv-py311
    else
        echo "✗ Python 3.11 not found. Please run Part 9 first."
        exit 1
    fi
    echo "✓ Virtual environment created"
else
    echo "✓ Virtual environment already exists"
fi

# Activate venv
source /workspace/isaac-venv-py311/bin/activate

# Verify activation
if [ -n "$VIRTUAL_ENV" ]; then
    echo "✓ Virtual environment activated: $VIRTUAL_ENV"
    python --version
else
    echo "✗ Failed to activate virtual environment"
    exit 1
fi

# Check if Isaac Sim is installed
if pip show isaacsim > /dev/null 2>&1; then
    echo "✓ Isaac Sim already installed"
    
    # Check if all required packages are installed
    MISSING_PACKAGES=0
    for pkg in isaacsim-app isaacsim-core isaacsim-gui isaacsim-robot isaacsim-sensor; do
        if ! pip show $pkg > /dev/null 2>&1; then
            echo "  Missing package: $pkg"
            MISSING_PACKAGES=1
        fi
    done
    
    if [ $MISSING_PACKAGES -eq 1 ]; then
        echo "Installing additional Isaac Sim packages..."
        pip install --quiet --upgrade \
            isaacsim-app \
            isaacsim-core \
            isaacsim-gui \
            isaacsim-robot \
            isaacsim-sensor \
            --extra-index-url https://pypi.nvidia.com
        echo "✓ Additional packages installed"
    else
        echo "✓ All Isaac Sim packages present"
    fi
else
    echo "Isaac Sim not installed. Run installation manually:"
    echo "  source /workspace/isaac-venv-py311/bin/activate"
    echo "  pip install isaacsim[all,extscache]==5.1.0 --extra-index-url https://pypi.nvidia.com"
    echo "  pip install isaacsim-app isaacsim-core isaacsim-gui isaacsim-robot isaacsim-sensor --extra-index-url https://pypi.nvidia.com"
fi

echo "Part 10 complete: Isaac Sim venv ready"
