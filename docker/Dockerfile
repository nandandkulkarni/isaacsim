# Isaac Sim 5.1.0 Docker Image with ROS 2, TurboVNC, and Python Development Tools
# Built on RunPod for GPU-accelerated robotics simulation

# ==============================================================================
# Stage 1: Base Isaac Sim Image
# ==============================================================================
FROM nvcr.io/nvidia/isaac-sim:5.1.0

# Metadata
LABEL maintainer="nandandkulkarni"
LABEL description="Isaac Sim 5.1.0 with ROS 2 Humble, TurboVNC, Python dev tools"
LABEL version="5.1.0"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    OMNI_KIT_ALLOW_ROOT=1 \
    ACCEPT_EULA=Y

# ==============================================================================
# Stage 2: System Dependencies and Tools
# ==============================================================================

# Update and install essential packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Build tools
    build-essential \
    cmake \
    git \
    curl \
    wget \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    # System utilities
    vim \
    nano \
    htop \
    tmux \
    unzip \
    tar \
    # Python development
    python3-pip \
    python3-dev \
    # Graphics and X11
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    # VNC dependencies
    xorg \
    xserver-xorg-video-dummy \
    x11-xserver-utils \
    xauth \
    xfonts-base \
    xkb-data \
    # Networking
    net-tools \
    iputils-ping \
    openssh-server \
    # Process management
    supervisor \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# ==============================================================================
# Stage 3: TurboVNC Installation
# ==============================================================================

# Install TurboVNC 3.1.1
RUN wget https://sourceforge.net/projects/turbovnc/files/3.1.1/turbovnc_3.1.1_amd64.deb/download -O /tmp/turbovnc.deb && \
    dpkg -i /tmp/turbovnc.deb || apt-get install -f -y && \
    rm /tmp/turbovnc.deb

# Configure VNC
RUN mkdir -p /root/.vnc && \
    echo "IsaacSim2025!" | /opt/TurboVNC/bin/vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Create VNC startup script
RUN echo '#!/bin/bash\n\
xrdb $HOME/.Xresources\n\
xsetroot -solid grey\n\
x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &\n\
x-window-manager &' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# ==============================================================================
# Stage 4: ROS 2 Humble Installation
# ==============================================================================

# Add ROS 2 apt repository
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS 2 Humble and common packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-desktop \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-slam-toolbox \
    ros-humble-moveit \
    ros-humble-moveit-ros-planning \
    ros-humble-moveit-ros-move-group \
    ros-humble-moveit-planners \
    ros-humble-moveit-simple-controller-manager \
    ros-humble-robot-state-publisher \
    ros-humble-joint-state-publisher \
    ros-humble-xacro \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-gazebo-ros-pkgs \
    python3-colcon-common-extensions \
    python3-rosdep \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init || true && \
    rosdep update

# Source ROS 2 in bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# ==============================================================================
# Stage 5: CUDA 12.8 Configuration
# ==============================================================================

# Install CUDA 12.8 toolkit (matches Isaac Sim requirements)
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-toolkit-12-8 \
    && rm -rf /var/lib/apt/lists/*

# Set CUDA environment variables
ENV CUDA_HOME=/usr/local/cuda-12.8 \
    PATH=/usr/local/cuda-12.8/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64:/usr/local/cuda-12.8/targets/x86_64-linux/lib:${LD_LIBRARY_PATH}

# ==============================================================================
# Stage 6: Python Development Tools and ML Libraries
# ==============================================================================

# Upgrade pip
RUN python3 -m pip install --upgrade pip setuptools wheel

# Install Python development tools
RUN pip3 install --no-cache-dir \
    # Jupyter and interactive development
    jupyter \
    jupyterlab \
    ipython \
    ipykernel \
    # Code quality and formatting
    black \
    pylint \
    flake8 \
    autopep8 \
    # Testing
    pytest \
    pytest-cov \
    # Scientific computing (already in Isaac Sim but ensuring versions)
    numpy \
    scipy \
    matplotlib \
    pandas \
    scikit-learn \
    # Computer vision
    opencv-python \
    opencv-contrib-python \
    # ML/RL libraries
    gymnasium \
    stable-baselines3 \
    # Experiment tracking
    wandb \
    tensorboard \
    # Robotics utilities
    transforms3d \
    spatialmath-python \
    roboticstoolbox-python \
    # ROS Python bridge
    roslibpy \
    # Utilities
    tqdm \
    pyyaml \
    requests

# ==============================================================================
# Stage 7: Isaac Sim Python Packages
# ==============================================================================

# Install Isaac Sim Python packages if not already in base image
RUN pip3 install --no-cache-dir \
    isaacsim==5.1.0 \
    isaacsim-app \
    isaacsim-core \
    isaacsim-gui \
    isaacsim-robot \
    isaacsim-sensor \
    isaacsim-storage \
    isaacsim-utils \
    --extra-index-url https://pypi.nvidia.com || true

# ==============================================================================
# Stage 8: Robot Models and Assets
# ==============================================================================

# Create directories for robot models
RUN mkdir -p /opt/robots/urdf \
    /opt/robots/usd \
    /opt/robots/meshes

# Download common robot models (these will be added in future iterations)
# For now, create placeholder structure
RUN echo "Robot models directory ready for URDF/USD files" > /opt/robots/README.md

# ==============================================================================
# Stage 9: Clone isaacsim Repository (Late Layer for Easy Updates)
# ==============================================================================

# Accept GitHub PAT as build argument (pass with --build-arg GITHUB_PAT=your_token)
ARG GITHUB_PAT
# Clone the isaacsim repository with scripts and configurations
RUN git clone https://${GITHUB_PAT}@github.com/nandandkulkarni/isaacsim.git /opt/isaacsim && \
    chmod -R 755 /opt/isaacsim && \
    # Remove .git directory to prevent PAT from being in final image
    rm -rf /opt/isaacsim/.git

# ==============================================================================
# Stage 10: Configuration and Entrypoint
# ==============================================================================

# Create workspace directory
RUN mkdir -p /workspace/isaac_captures

# Copy startup scripts from cloned repo
RUN cp -r /opt/isaacsim/ubuntu22.04 /opt/startup_scripts && \
    chmod +x /opt/startup_scripts/*.sh

# Create entrypoint script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Start VNC server\n\
echo "Starting TurboVNC server on display :1..."\n\
/opt/TurboVNC/bin/vncserver :1 -geometry 1920x1080 -depth 24\n\
\n\
# Source ROS 2\n\
source /opt/ros/humble/setup.bash\n\
\n\
# Set Isaac Sim environment\n\
export DISPLAY=:1\n\
export OMNI_KIT_ALLOW_ROOT=1\n\
export LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64:/usr/local/cuda-12.8/targets/x86_64-linux/lib:$LD_LIBRARY_PATH\n\
export LD_PRELOAD=/usr/local/cuda-12.8/targets/x86_64-linux/lib/libnvJitLink.so.12:/usr/local/cuda-12.8/targets/x86_64-linux/lib/libcusparse.so.12:/usr/local/cuda-12.8/targets/x86_64-linux/lib/libcublas.so.12:$LD_PRELOAD\n\
\n\
echo "Isaac Sim Docker Container Ready!"\n\
echo "VNC server: localhost:5901 (password: IsaacSim2025!)"\n\
echo ""\n\
echo "To run Isaac Sim:"\n\
echo "  python3 -m isaacsim"\n\
echo ""\n\
echo "To run Python scripts:"\n\
echo "  python3 your_script.py"\n\
echo ""\n\
\n\
# Execute command or start bash\n\
exec "$@"' > /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Expose ports
EXPOSE 5901 6080 8888 47995-48012 49000-49007

# Set working directory
WORKDIR /workspace

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["/bin/bash"]
