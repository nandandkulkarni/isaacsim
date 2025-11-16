#!/usr/bin/env python3
"""Quick test to verify Isaac Sim installation"""

print("Testing Isaac Sim installation...")
print("-" * 50)

try:
    import isaacsim
    print("✓ Isaac Sim module imported successfully")
    print(f"  Version: {isaacsim.__version__ if hasattr(isaacsim, '__version__') else 'Unknown'}")
except ImportError as e:
    print(f"✗ Failed to import Isaac Sim: {e}")
    exit(1)

try:
    from isaacsim import SimulationApp
    print("✓ SimulationApp imported successfully")
except ImportError as e:
    print(f"✗ Failed to import SimulationApp: {e}")
    exit(1)

print("-" * 50)
print("Isaac Sim installation test PASSED!")
print("\nTo run a full Isaac Sim application, use:")
print("  python3 your_isaac_sim_script.py")
