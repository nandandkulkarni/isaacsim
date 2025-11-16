# Isaac Sim Headless Video Capture - Quick Reference

**Created:** November 16, 2025  
**Purpose:** Guide for capturing videos from Isaac Sim headless simulations  
**Location:** `/workspace/HEADLESS_VIDEO_CAPTURE.md`

---

## Overview

This document explains how to capture video from Isaac Sim running in headless mode and convert the frames to MP4 video files.

---

## Quick Start

### 1. Run a Headless Simulation with Capture

```bash
cd /workspace/isaacsim
source /workspace/isaac-venv-py311/bin/activate
python test_rotating_bouncing_cube.py
```

### 2. Convert Frames to Video

```bash
/workspace/isaacsim/convert-frames-to-video.sh my_video.mp4 60
```

**Arguments:**
- Arg 1: Output filename (default: `output.mp4`)
- Arg 2: Frame rate in fps (default: `60`)
- Arg 3: Quality CRF 0-51, lower=better (default: `23`)

**Examples:**
```bash
# Use defaults (output.mp4, 60fps, CRF 23)
/workspace/convert-frames-to-video.sh

# Custom name and framerate
/workspace/convert-frames-to-video.sh simulation.mp4 30

# Custom name, framerate, and quality
/workspace/convert-frames-to-video.sh high_quality.mp4 60 18
```

---

## How It Works

### Frame Capture Process

1. **Isaac Sim Headless Mode**: Initialize with rendering enabled
   ```python
   from isaacsim import SimulationApp
   simulation_app = SimulationApp({
       "headless": True,
       "width": 1920,
       "height": 1080,
       "renderer": "RayTracedLighting"
   })
   ```

2. **Replicator Setup**: Create camera and capture pipeline
   ```python
   import omni.replicator.core as rep
   
   # Create camera
   camera = rep.create.camera(
       position=(5, 5, 4),
       look_at=(0, 0, 2)
   )
   
   # Create render product
   render_product = rep.create.render_product(camera, (1920, 1080))
   
   # Setup writer
   writer = rep.WriterRegistry.get("BasicWriter")
   writer.initialize(
       output_dir="/workspace/isaac_captures",
       rgb=True,
   )
   writer.attach([render_product])
   ```

3. **Simulation Loop**: Step world with rendering
   ```python
   for frame in range(num_frames):
       # Update scene/objects
       cube.set_world_pose(position=new_pos, orientation=new_rot)
       
       # Step with rendering (captures frame automatically)
       world.step(render=True)
   ```

4. **Output**: Frames saved as `/workspace/isaac_captures/rgb_0000.png`, `rgb_0001.png`, etc.

---

## Video Conversion

### Script: `/workspace/convert-frames-to-video.sh`

**What it does:**
1. Checks for PNG frames in `/workspace/isaac_captures/`
2. Counts frames matching pattern `rgb_*.png`
3. Uses ffmpeg to encode frames to H.264 MP4
4. Reports video statistics

**FFmpeg Command Used:**
```bash
ffmpeg -y \
    -framerate 60 \
    -i rgb_%04d.png \
    -c:v libx264 \
    -pix_fmt yuv420p \
    -crf 23 \
    output.mp4
```

**Parameters:**
- `-framerate 60`: Input frame rate
- `-i rgb_%04d.png`: Input pattern (4-digit padding)
- `-c:v libx264`: H.264 video codec
- `-pix_fmt yuv420p`: Pixel format (compatible with most players)
- `-crf 23`: Constant Rate Factor for quality (0=lossless, 51=worst)

---

## Example Simulation Scripts

### Simple Rotating & Bouncing Cube

**File:** `/workspace/isaacsim/test_rotating_bouncing_cube.py`

**Features:**
- Blue cube that rotates continuously
- Bounces up and down with sine wave motion
- 600 frames (10 seconds at 60fps)
- Ray-traced lighting
- 1920x1080 resolution

**Animation Parameters:**
```python
rotation_speed = 2.0    # rotations per second
bounce_speed = 0.5      # bounces per second
bounce_height = 1.0     # meters
base_height = 2.0       # center height
```

**Rotation Math:**
```python
time = frame / 60.0
angle = time * rotation_speed * 2 * math.pi
quaternion = [cos(angle/2), 0, 0, sin(angle/2)]  # Z-axis rotation
```

**Bounce Math:**
```python
bounce_offset = sin(time * bounce_speed * 2 * pi) * bounce_height
height = base_height + bounce_offset
```

### Creating Your Own Capture Script

**Template:**
```python
#!/usr/bin/env python3
from isaacsim import SimulationApp

# 1. Initialize headless with rendering
simulation_app = SimulationApp({
    "headless": True,
    "width": 1920,
    "height": 1080,
    "renderer": "RayTracedLighting"
})

# 2. Import other modules AFTER SimulationApp
import omni.replicator.core as rep
from omni.isaac.core import World
from pathlib import Path

# 3. Create world and scene
world = World(stage_units_in_meters=1.0)
world.scene.add_default_ground_plane()

# Add your objects here
# ...

# 4. Setup camera and capture
camera = rep.create.camera(
    position=(5, 5, 4),
    look_at=(0, 0, 0)
)
render_product = rep.create.render_product(camera, (1920, 1080))

output_dir = Path("/workspace/isaac_captures")
output_dir.mkdir(exist_ok=True)

writer = rep.WriterRegistry.get("BasicWriter")
writer.initialize(output_dir=str(output_dir), rgb=True)
writer.attach([render_product])

# 5. Reset world
world.reset()

# 6. Animation loop
num_frames = 600  # 10 seconds at 60fps

for frame in range(num_frames):
    # Update your scene here
    # ...
    
    # Step world with rendering (auto-captures frame)
    world.step(render=True)

# 7. Cleanup
simulation_app.close()
```

---

## File Locations

### Scripts
- **Conversion script:** `/workspace/isaacsim/convert-frames-to-video.sh`
- **Example capture:** `/workspace/isaacsim/test_rotating_bouncing_cube.py`
- **Simple headless test:** `/workspace/isaacsim/test_headless_simple.py`
- **Physics capture:** `/workspace/isaacsim/test_headless_capture.py`

### Directories
- **Frame output:** `/workspace/isaac_captures/`
- **Video output:** `/workspace/isaac_captures/[name].mp4`

### Environment
- **Virtual env:** `/workspace/isaac-venv-py311/`
- **Activate:** `source /workspace/isaac-venv-py311/bin/activate`

---

## Output Specifications

### Frame Format
- **Pattern:** `rgb_0000.png`, `rgb_0001.png`, etc.
- **Format:** PNG (lossless)
- **Typical size:** ~750KB per frame (1920x1080)
- **600 frames:** ~450MB total

### Video Format
- **Codec:** H.264 (libx264)
- **Container:** MP4
- **Pixel format:** YUV420P
- **Typical compression:** 100:1 ratio (450MB → 4-5MB)

### Quality Settings (CRF)
- **18:** Visually lossless (~8-10MB for 10sec)
- **23:** High quality, default (~4-5MB for 10sec)
- **28:** Good quality (~2-3MB for 10sec)
- **32:** Acceptable quality (~1-2MB for 10sec)

---

## Downloading Videos

### Option 1: VS Code (Recommended)
1. Open Explorer pane
2. Navigate to `/workspace/isaac_captures/`
3. Right-click on `.mp4` file
4. Select "Download"

### Option 2: SCP (Command Line)
```bash
# From your local Windows terminal
scp -P <ssh_port> root@<runpod_ip>:/workspace/isaac_captures/video.mp4 .
```

### Option 3: Code Server Web Interface
1. Navigate to `http://<your_runpod_url>/files`
2. Browse to `/workspace/isaac_captures/`
3. Click on video file to download

---

## Troubleshooting

### No frames captured
**Symptom:** Empty `/workspace/isaac_captures/` directory

**Solutions:**
- Check `world.step(render=True)` - `render=True` is required
- Verify writer is attached: `writer.attach([render_product])`
- Check output directory exists and is writable

### Conversion script fails
**Symptom:** "No PNG frames found"

**Solutions:**
- Verify frames exist: `ls /workspace/isaac_captures/rgb_*.png`
- Check frame naming pattern matches `rgb_0000.png`
- Ensure frames are in correct directory

### Video quality issues
**Symptom:** Blocky or blurry video

**Solutions:**
- Lower CRF value (18 for near-lossless)
- Increase resolution in SimulationApp
- Use different encoder: `-c:v libx265` (HEVC, better compression)

### Out of memory during capture
**Symptom:** Crash during long simulations

**Solutions:**
- Reduce resolution (1280x720 instead of 1920x1080)
- Capture fewer frames
- Clear old frames before new capture: `rm /workspace/isaac_captures/rgb_*.png`

---

## Performance Notes

### Capture Performance
- **Headless rendering:** ~2-5 seconds per frame (GPU-dependent)
- **600 frames:** ~20-40 minutes capture time
- **Disk I/O:** PNG writes are fast, but check available space

### Conversion Performance
- **ffmpeg encoding:** ~1-2 minutes for 600 frames
- **Speed:** ~10x realtime (60fps video encoded in 6 seconds)
- **CPU-bound:** Uses all available cores

---

## Camera Positioning Tips

### Looking at Origin
```python
camera = rep.create.camera(
    position=(10, 10, 10),
    look_at=(0, 0, 0)
)
```

### Orbit Camera (Manual)
```python
radius = 10
angle = frame * 0.01  # Slow rotation
x = radius * cos(angle)
y = radius * sin(angle)
z = 5

camera.set_world_pose(position=(x, y, z))
camera.look_at((0, 0, 0))
```

### Top-Down View
```python
camera = rep.create.camera(
    position=(0, 0, 20),
    look_at=(0, 0, 0)
)
```

### Follow Object
```python
# In animation loop
obj_pos = cube.get_world_pose()[0]
camera_pos = obj_pos + np.array([5, 5, 3])
camera.set_world_pose(position=camera_pos)
camera.look_at(obj_pos)
```

---

## Advanced Options

### Multiple Cameras
```python
camera1 = rep.create.camera(position=(10, 0, 5), look_at=(0, 0, 0))
camera2 = rep.create.camera(position=(0, 10, 5), look_at=(0, 0, 0))

rp1 = rep.create.render_product(camera1, (1920, 1080))
rp2 = rep.create.render_product(camera2, (1920, 1080))

writer1 = rep.WriterRegistry.get("BasicWriter")
writer1.initialize(output_dir="/workspace/captures/cam1", rgb=True)
writer1.attach([rp1])

writer2 = rep.WriterRegistry.get("BasicWriter")
writer2.initialize(output_dir="/workspace/captures/cam2", rgb=True)
writer2.attach([rp2])
```

### Depth or Segmentation
```python
writer = rep.WriterRegistry.get("BasicWriter")
writer.initialize(
    output_dir="/workspace/isaac_captures",
    rgb=True,
    distance_to_camera=True,  # Depth map
    semantic_segmentation=True,  # Segmentation masks
)
```

### Custom Frame Rate
```python
# Capture every Nth frame
if frame % 2 == 0:  # Capture at 30fps instead of 60fps
    world.step(render=True)
else:
    world.step(render=False)
```

---

## Storage Management

### Check Space
```bash
df -h /workspace
du -sh /workspace/isaac_captures/
```

### Clean Old Captures
```bash
# Remove all PNG frames
rm /workspace/isaac_captures/rgb_*.png

# Keep only videos
find /workspace/isaac_captures/ -name "*.png" -delete

# Archive old videos
mkdir -p /workspace/video_archive
mv /workspace/isaac_captures/*.mp4 /workspace/video_archive/
```

### Frame Limits
- **1920x1080:** ~750KB/frame → 1.3GB per 1000 frames
- **1280x720:** ~350KB/frame → 600MB per 1000 frames
- **10 second video (600 frames):** 450MB PNG → 4MB MP4

---

## Summary

✅ **Capture workflow:**
1. Write Python script with headless SimulationApp + replicator
2. Run: `python your_script.py`
3. Convert: `/workspace/convert-frames-to-video.sh output.mp4`
4. Download video via VS Code or SCP

✅ **Key files:**
- Converter: `/workspace/isaacsim/convert-frames-to-video.sh`
- Example: `/workspace/isaacsim/test_rotating_bouncing_cube.py`
- Output: `/workspace/isaac_captures/*.mp4`

✅ **Remember:**
- Must use `world.step(render=True)` to capture frames
- Frames are automatically numbered `rgb_0000.png`, `rgb_0001.png`, etc.
- Video conversion is automatic with the provided script
- All files persist in `/workspace/` across RunPod restarts

---

**Last Updated:** November 16, 2025
