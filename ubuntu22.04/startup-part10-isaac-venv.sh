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
    echo "✓ Isaac Sim base package installed (version $(pip show isaacsim | grep Version | cut -d' ' -f2))"
    
    # Check if all required packages are installed
    MISSING_PACKAGES=()
    for pkg in isaacsim-app isaacsim-core isaacsim-gui isaacsim-robot isaacsim-sensor; do
        if ! pip show $pkg > /dev/null 2>&1; then
            MISSING_PACKAGES+=("$pkg")
        fi
    done
    
    if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
        echo "Installing missing packages: ${MISSING_PACKAGES[*]}"
        pip install --quiet --upgrade \
            isaacsim-app \
            isaacsim-core \
            isaacsim-gui \
            isaacsim-robot \
            isaacsim-sensor \
            --extra-index-url https://pypi.nvidia.com
        
        if [ $? -eq 0 ]; then
            echo "✓ Additional packages installed successfully"
        else
            echo "⚠ Warning: Some packages failed to install"
        fi
    else
        echo "✓ All required Isaac Sim packages present:"
        echo "  - isaacsim (base)"
        echo "  - isaacsim-app"
        echo "  - isaacsim-core"
        echo "  - isaacsim-gui"
        echo "  - isaacsim-robot"
        echo "  - isaacsim-sensor"
    fi
else
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚠ Isaac Sim NOT installed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "To install Isaac Sim (first time only):"
    echo ""
    echo "  source /workspace/isaac-venv-py311/bin/activate"
    echo "  pip install isaacsim[all,extscache]==5.1.0 --extra-index-url https://pypi.nvidia.com"
    echo ""
    echo "Then install additional packages:"
    echo ""
    echo "  pip install isaacsim-app isaacsim-core isaacsim-gui isaacsim-robot isaacsim-sensor --extra-index-url https://pypi.nvidia.com"
    echo ""
    echo "Note: This is a ~10GB download and takes 20-30 minutes."
    echo "      It only needs to be done once - packages persist in /workspace/isaac-venv-py311/"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

echo "Part 10 complete: Isaac Sim venv ready"
