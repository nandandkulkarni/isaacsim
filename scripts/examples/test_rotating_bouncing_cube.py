#!/usr/bin/env python3
"""
Headless Isaac Sim with rotating and bouncing cube - Video capture
"""

import numpy as np
import math

# Initialize Isaac Sim in headless mode with rendering
from isaacsim import SimulationApp
simulation_app = SimulationApp({
    "headless": True,
    "width": 1920,
    "height": 1080,
    "anti_aliasing": 3,
    "renderer": "RayTracedLighting"
})

print("✓ Simulation App created in headless mode")

# Now import other modules
import omni.replicator.core as rep
from pxr import Gf, UsdGeom, Usd
from omni.isaac.core import World
from omni.isaac.core.objects import VisualCuboid
from omni.isaac.core.prims import XFormPrim

print("✓ Modules imported")

# Create world
world = World(stage_units_in_meters=1.0)
print("✓ World created")

# Add ground plane
world.scene.add_default_ground_plane()
print("✓ Ground plane added")

# Add a visual cube (no physics, we'll animate it manually)
cube = world.scene.add(
    VisualCuboid(
        prim_path="/World/RotatingCube",
        name="rotating_cube",
        position=np.array([0, 0, 2.0]),
        size=1.0,
        color=np.array([0.2, 0.6, 0.9])
    )
)
print("✓ Cube added")

# Setup camera
camera = rep.create.camera(
    position=(5, 5, 4),
    look_at=(0, 0, 2)
)
render_product = rep.create.render_product(camera, (1920, 1080))
print("✓ Camera configured")

# Setup video writer
from pathlib import Path
output_dir = Path("/workspace/isaac_captures")
output_dir.mkdir(exist_ok=True)

writer = rep.WriterRegistry.get("BasicWriter")
writer.initialize(
    output_dir=str(output_dir),
    rgb=True,
)
writer.attach([render_product])
print(f"✓ Video writer configured")

# Reset world
world.reset()
print("✓ World reset, starting animation")

# Animation parameters
num_frames = 600  # 10 seconds at 60fps
rotation_speed = 2.0  # rotations per second
bounce_speed = 0.5    # bounces per second
bounce_height = 1.0   # meters

print(f"Recording {num_frames} frames (10 seconds)...")
print("Animation: Rotating + bouncing cube")

for frame in range(num_frames):
    # Calculate time
    time = frame / 60.0
    
    # Calculate rotation (around Z axis)
    angle = time * rotation_speed * 2 * math.pi
    
    # Calculate bounce (sine wave for smooth up/down motion)
    base_height = 2.0
    bounce_offset = math.sin(time * bounce_speed * 2 * math.pi) * bounce_height
    height = base_height + bounce_offset
    
    # Update cube position and rotation
    cube.set_world_pose(
        position=np.array([0, 0, height]),
        orientation=np.array([
            math.cos(angle/2), 0, 0, math.sin(angle/2)  # Quaternion for Z-axis rotation
        ])
    )
    
    # Step simulation with rendering
    world.step(render=True)
    
    # Progress indicator
    if (frame + 1) % 60 == 0:
        seconds = (frame + 1) // 60
        print(f"  {seconds}s / 10s - Height: {height:.2f}m, Rotation: {math.degrees(angle) % 360:.1f}°")

print("✓ Animation complete")

# Cleanup
simulation_app.close()

print("\n" + "="*50)
print("✓ Video capture complete!")
print("="*50)
print(f"\nFrames saved to: {output_dir}")
print("\nTo create video, run:")
print(f"  cd {output_dir}")
print(f"  ffmpeg -framerate 60 -i rgb_%04d.png -c:v libx264 -pix_fmt yuv420p -crf 23 rotating_cube.mp4")
print("="*50)
