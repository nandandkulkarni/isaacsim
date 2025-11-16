#!/bin/bash
#
# convert-frames-to-video.sh - Convert Isaac Sim captured PNG frames to MP4 video
#
# Usage:
#   ./convert-frames-to-video.sh [output_name] [framerate]
#
# Arguments:
#   output_name - Name for output video file (default: output.mp4)
#   framerate   - Frame rate for video (default: 60)
#
# Example:
#   ./convert-frames-to-video.sh my_simulation.mp4 60
#   ./convert-frames-to-video.sh  (uses defaults)
#

set -e  # Exit on error

# Configuration
CAPTURE_DIR="/workspace/isaac_captures"
OUTPUT_NAME="${1:-output.mp4}"
FRAMERATE="${2:-60}"
CRF="${3:-23}"  # Quality: 0-51, lower=better, 23 is default

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if capture directory exists
if [ ! -d "$CAPTURE_DIR" ]; then
    echo -e "${RED}Error: Capture directory not found: $CAPTURE_DIR${NC}"
    exit 1
fi

cd "$CAPTURE_DIR"

# Count PNG frames
FRAME_COUNT=$(ls -1 rgb_*.png 2>/dev/null | wc -l)

if [ "$FRAME_COUNT" -eq 0 ]; then
    echo -e "${RED}Error: No PNG frames found in $CAPTURE_DIR${NC}"
    echo "Expected files matching pattern: rgb_*.png"
    exit 1
fi

echo -e "${GREEN}===========================================${NC}"
echo -e "${GREEN}Isaac Sim Frame to Video Converter${NC}"
echo -e "${GREEN}===========================================${NC}"
echo ""
echo "Capture directory: $CAPTURE_DIR"
echo "Found $FRAME_COUNT PNG frames"
echo "Output file: $OUTPUT_NAME"
echo "Frame rate: $FRAMERATE fps"
echo "Quality (CRF): $CRF (lower=better, 0-51)"
echo ""

# Check if output file already exists
if [ -f "$OUTPUT_NAME" ]; then
    echo -e "${YELLOW}Warning: $OUTPUT_NAME already exists and will be overwritten${NC}"
fi

# Run ffmpeg
echo "Converting frames to video..."
echo ""

ffmpeg -y \
    -framerate "$FRAMERATE" \
    -i rgb_%04d.png \
    -c:v libx264 \
    -pix_fmt yuv420p \
    -crf "$CRF" \
    "$OUTPUT_NAME" 2>&1 | tail -20

echo ""
echo -e "${GREEN}===========================================${NC}"
echo -e "${GREEN}Conversion Complete!${NC}"
echo -e "${GREEN}===========================================${NC}"
echo ""

# Get video info
if [ -f "$OUTPUT_NAME" ]; then
    VIDEO_SIZE=$(ls -lh "$OUTPUT_NAME" | awk '{print $5}')
    echo "Output video: $CAPTURE_DIR/$OUTPUT_NAME"
    echo "File size: $VIDEO_SIZE"
    
    # Get detailed video info if ffprobe is available
    if command -v ffprobe &> /dev/null; then
        echo ""
        echo "Video properties:"
        ffprobe -v error -show_entries format=duration,size,bit_rate \
                -show_entries stream=width,height,r_frame_rate,codec_name \
                "$OUTPUT_NAME" 2>&1 | grep -E "(width|height|duration|codec_name|r_frame_rate)" | sed 's/^/  /'
    fi
    
    echo ""
    echo -e "${GREEN}✓ Video ready for download!${NC}"
    echo ""
    echo "Download options:"
    echo "  1. VS Code: Right-click file → Download"
    echo "  2. SCP: scp -P <port> root@<host>:$CAPTURE_DIR/$OUTPUT_NAME ."
else
    echo -e "${RED}Error: Video file was not created${NC}"
    exit 1
fi

echo -e "${GREEN}===========================================${NC}"
