#!/usr/bin/env python3
"""
Simple headless test - Verifies Isaac Sim works without GUI
"""

from isaacsim import SimulationApp

# Launch in headless mode
print("Starting Isaac Sim in headless mode...")
simulation_app = SimulationApp({"headless": True})

print("✓ Isaac Sim started successfully")
print("✓ Running for 5 seconds...")

# Run for a few frames
for i in range(300):  # 5 seconds at 60 fps
    simulation_app.update()

print("✓ Simulation completed")
print("✓ All systems operational in headless mode!")

# Cleanup
simulation_app.close()
print("✓ Test finished successfully")
