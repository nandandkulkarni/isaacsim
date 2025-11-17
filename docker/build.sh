#!/bin/bash
# Build script for Isaac Sim Docker image

set -e

echo "========================================"
echo "Isaac Sim Docker Image Builder"
echo "========================================"
echo ""

# Configuration
IMAGE_NAME="isaac-sim-full"
IMAGE_TAG="5.1.0"
DOCKERFILE_PATH="./Dockerfile"

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed or not in PATH"
    exit 1
fi

# Check if GITHUB_PAT is provided
if [ -z "$GITHUB_PAT" ]; then
    echo "ERROR: GITHUB_PAT environment variable is required"
    echo "Usage: GITHUB_PAT=your_token bash build.sh"
    echo "Or: export GITHUB_PAT=your_token && bash build.sh"
    exit 1
fi

echo "Building Docker image..."
echo "  Image: ${IMAGE_NAME}:${IMAGE_TAG}"
echo "  Dockerfile: ${DOCKERFILE_PATH}"
echo ""

# Build the image with PAT as build arg
docker build \
    --build-arg GITHUB_PAT=${GITHUB_PAT} \
    -t ${IMAGE_NAME}:${IMAGE_TAG} \
    -t ${IMAGE_NAME}:latest \
    -f ${DOCKERFILE_PATH} \
    .

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "✓ Build completed successfully!"
    echo "========================================"
    echo ""
    echo "Image built: ${IMAGE_NAME}:${IMAGE_TAG}"
    echo ""
    echo "To run the container:"
    echo "  docker run -d --gpus all -p 5901:5901 ${IMAGE_NAME}:${IMAGE_TAG}"
    echo ""
    echo "To test Python API:"
    echo "  docker run --rm --gpus all ${IMAGE_NAME}:${IMAGE_TAG} python3 -c \"from isaacsim import SimulationApp; print('OK')\""
    echo ""
    echo "To save the image:"
    echo "  docker save ${IMAGE_NAME}:${IMAGE_TAG} | gzip > isaac-sim-full-5.1.0.tar.gz"
    echo ""
else
    echo ""
    echo "========================================"
    echo "✗ Build failed!"
    echo "========================================"
    exit 1
fi
