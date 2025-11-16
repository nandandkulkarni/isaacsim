#!/usr/bin/env python3
"""
Simple Isaac Sim test - Create a cube and sphere with physics
Based on: https://docs.isaacsim.omniverse.nvidia.com/latest/introduction/quickstart_isaacsim.html
"""

from isaacsim import SimulationApp

# Launch Isaac Sim (headless=False to show window)
print("Launching Isaac Sim...")
simulation_app = SimulationApp({"headless": False})
print("✓ Isaac Sim launched")

import omni.usd
from pxr import UsdGeom, Gf, UsdPhysics
import carb

# Get the stage
stage = omni.usd.get_context().get_stage()

# Create a ground plane
UsdGeom.Xform.Define(stage, "/World")
ground_plane_path = "/World/GroundPlane"
ground_plane = UsdGeom.Mesh.Define(stage, ground_plane_path)
ground_plane.CreatePointsAttr([Gf.Vec3f(-10, -10, 0), Gf.Vec3f(-10, 10, 0), 
                                Gf.Vec3f(10, 10, 0), Gf.Vec3f(10, -10, 0)])
ground_plane.CreateFaceVertexCountsAttr([4])
ground_plane.CreateFaceVertexIndicesAttr([0, 1, 2, 3])
ground_plane.CreateNormalsAttr([Gf.Vec3f(0, 0, 1)])

# Add collision to ground plane
UsdPhysics.CollisionAPI.Apply(stage.GetPrimAtPath(ground_plane_path))

# Create a distant light
light_path = "/World/DistantLight"
light = UsdGeom.DistantLight.Define(stage, light_path)
light.CreateIntensityAttr(500)

# Create a cube with physics
cube_path = "/World/Cube"
cube_geom = UsdGeom.Cube.Define(stage, cube_path)
cube_geom.CreateSizeAttr(1.0)
cube_geom.AddTranslateOp().Set(Gf.Vec3d(0, 0, 5))

# Add physics to cube
cube_prim = stage.GetPrimAtPath(cube_path)
rigid_body_api = UsdPhysics.RigidBodyAPI.Apply(cube_prim)
rigid_body_api.CreateRigidBodyEnabledAttr(True)
UsdPhysics.CollisionAPI.Apply(cube_prim)
UsdPhysics.MassAPI.Apply(cube_prim)

# Create a sphere with physics
sphere_path = "/World/Sphere"
sphere_geom = UsdGeom.Sphere.Define(stage, sphere_path)
sphere_geom.CreateRadiusAttr(0.5)
sphere_geom.AddTranslateOp().Set(Gf.Vec3d(2, 0, 7))

# Add physics to sphere
sphere_prim = stage.GetPrimAtPath(sphere_path)
rigid_body_api = UsdPhysics.RigidBodyAPI.Apply(sphere_prim)
rigid_body_api.CreateRigidBodyEnabledAttr(True)
UsdPhysics.CollisionAPI.Apply(sphere_prim)
UsdPhysics.MassAPI.Apply(sphere_prim)

print("✓ Scene created with ground plane, cube, and sphere")
print("✓ Press Play in the viewport to see physics simulation")
print("✓ Close the window to exit")

# Keep the simulation running
while simulation_app.is_running():
    simulation_app.update()

# Cleanup
simulation_app.close()
