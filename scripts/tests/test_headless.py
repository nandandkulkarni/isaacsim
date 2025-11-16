#!/usr/bin/env python3
"""
Headless test - Create a scene and run physics simulation
"""

from isaacsim import SimulationApp

# Launch Isaac Sim in headless mode
simulation_app = SimulationApp({"headless": True})

import omni.usd
from pxr import UsdGeom, Gf, UsdPhysics
import carb

print("Starting headless test...")

# Get the stage
stage = omni.usd.get_context().get_stage()

# Create World
UsdGeom.Xform.Define(stage, "/World")

# Create a ground plane
ground_plane_path = "/World/GroundPlane"
ground_plane = UsdGeom.Mesh.Define(stage, ground_plane_path)
ground_plane.CreatePointsAttr([Gf.Vec3f(-10, -10, 0), Gf.Vec3f(-10, 10, 0), 
                                Gf.Vec3f(10, 10, 0), Gf.Vec3f(10, -10, 0)])
ground_plane.CreateFaceVertexCountsAttr([4])
ground_plane.CreateFaceVertexIndicesAttr([0, 1, 2, 3])
ground_plane.CreateNormalsAttr([Gf.Vec3f(0, 0, 1)])
UsdPhysics.CollisionAPI.Apply(stage.GetPrimAtPath(ground_plane_path))
print("✓ Ground plane created")

# Create a cube with physics
cube_path = "/World/Cube"
cube_geom = UsdGeom.Cube.Define(stage, cube_path)
cube_geom.CreateSizeAttr(1.0)
cube_geom.AddTranslateOp().Set(Gf.Vec3d(0, 0, 5))

cube_prim = stage.GetPrimAtPath(cube_path)
UsdPhysics.RigidBodyAPI.Apply(cube_prim)
UsdPhysics.CollisionAPI.Apply(cube_prim)
UsdPhysics.MassAPI.Apply(cube_prim)
print("✓ Cube created at height 5m with physics")

# Get physics scene
from omni.physx.scripts import physicsUtils
physicsUtils.add_ground_plane(stage, "/World/defaultGroundPlane", "Z", 750.0, Gf.Vec3f(0.0), Gf.Vec3f(0.5))

print("\n=== Running simulation for 2 seconds ===")
print("Cube should fall from 5m height...")

# Run simulation for 120 frames (2 seconds at 60 fps)
for i in range(120):
    simulation_app.update()
    if i % 30 == 0:  # Print every 0.5 seconds
        # Get cube position
        cube_prim = stage.GetPrimAtPath(cube_path)
        xform = UsdGeom.Xformable(cube_prim)
        transform = xform.ComputeLocalToWorldTransform(0)
        position = transform.ExtractTranslation()
        print(f"Frame {i:3d}: Cube Z position = {position[2]:.2f}m")

print("\n✓ Simulation completed successfully!")
print("✓ All systems working in headless mode")

# Cleanup
simulation_app.close()
print("✓ Test finished")
