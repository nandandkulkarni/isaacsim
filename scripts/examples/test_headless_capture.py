#!/usr/bin/env python3
"""
Headless Isaac Sim test with video capture
Creates a simple physics scene and captures frames to video
"""

import numpy as np
import sys
from pathlib import Path

# Initialize Isaac Sim in headless mode with rendering enabled
from isaacsim import SimulationApp
simulation_app = SimulationApp({
    "headless": True,
    "width": 1280,
    "height": 720,
    "anti_aliasing": 2,
    "renderer": "RayTracedLighting"
})

print("✓ Simulation App created in headless mode")

# Now import other modules after SimulationApp
import omni.replicator.core as rep
from pxr import Gf, UsdGeom, UsdPhysics

# Get the USD stage
from omni.isaac.core import World
from omni.isaac.core.objects import DynamicCuboid, DynamicSphere
from omni.isaac.core.utils.stage import add_reference_to_stage

print("✓ Modules imported")

# Create world with physics
world = World(stage_units_in_meters=1.0)
print("✓ World created")

# Add ground plane
world.scene.add_default_ground_plane()
print("✓ Ground plane added")

# Add some dynamic objects
cube = world.scene.add(
    DynamicCuboid(
        prim_path="/World/Cube",
        name="cube",
        position=np.array([0, 0, 5.0]),
        size=1.0,
        color=np.array([0.8, 0.2, 0.2])
    )
)
print("✓ Cube added at height 5m")

sphere = world.scene.add(
    DynamicSphere(
        prim_path="/World/Sphere",
        name="sphere",
        position=np.array([1.5, 0, 7.0]),
        radius=0.5,
        color=np.array([0.2, 0.2, 0.8])
    )
)
print("✓ Sphere added at height 7m")

# Setup camera and render product
camera = rep.create.camera(
    position=(10, 10, 10),
    look_at=(0, 0, 0)
)

render_product = rep.create.render_product(camera, (1280, 720))
print("✓ Camera and render product created")

# Setup video writer
output_dir = Path("/workspace/isaac_captures")
output_dir.mkdir(exist_ok=True)
video_path = output_dir / "physics_sim.mp4"

# Initialize writer with BasicWriter
writer = rep.WriterRegistry.get("BasicWriter")
writer.initialize(
    output_dir=str(output_dir),
    rgb=True,
    distance_to_image_plane=False
)
writer.attach([render_product])
print(f"✓ Video writer configured: {video_path}")

# Reset world
world.reset()
print("✓ World reset, starting simulation")

# Run simulation for 10 seconds (600 frames at 60fps)
num_frames = 600
print(f"Running {num_frames} frames...")

for i in range(num_frames):
    world.step(render=True)
    
    # Progress indicator every 60 frames (1 second)
    if (i + 1) % 60 == 0:
        print(f"  Frame {i+1}/{num_frames} ({(i+1)//60}s)")

print("✓ Simulation complete")

# Cleanup
simulation_app.close()
print(f"✓ Video saved to: {video_path}")
print("SUCCESS: Headless capture completed")
