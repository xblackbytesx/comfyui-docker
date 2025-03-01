FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV ROCM_VERSION=5.7

# Add ROCm repository
RUN apt-get update && apt-get install -y wget gnupg2 && \
    wget -q -O - https://repo.radeon.com/rocm/rocm.gpg.key | apt-key add - && \
    echo "deb [arch=amd64] https://repo.radeon.com/rocm/apt/${ROCM_VERSION} ubuntu main" > /etc/apt/sources.list.d/rocm.list && \
    echo 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' > /etc/apt/preferences.d/rocm-pin-600

# Install system dependencies including minimal ROCm
RUN apt-get update && apt-get install -y \
    git \
    python3.10 \
    python3.10-venv \
    python3-pip \
    build-essential \
    pkg-config \
    libgl1-mesa-dev \
    libglib2.0-0 \
    rocm-libs \
    rocm-hip-runtime \
    rocm-hip-sdk \
    rocminfo \
    && rm -rf /var/lib/apt/lists/*

# Add ROCm to PATH
ENV PATH="/opt/rocm/bin:${PATH}"
ENV LD_LIBRARY_PATH="/opt/rocm/lib:${LD_LIBRARY_PATH}"

# Create and set working directory
WORKDIR /comfy

# Clone ComfyUI repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# Create and activate virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python dependencies
COPY install_torch.sh /install_torch.sh
RUN chmod +x /install_torch.sh && \
/install_torch.sh && \
pip install --no-cache-dir -r requirements.txt && \
pip install --no-cache-dir \
    opencv-python-headless \
    pillow \
    transformers>=4.25.1 \
    safetensors>=0.3.1 \
    accelerate \
    diffusers \
    k-diffusion \
    scipy \
    pytorch_lightning \
    einops \
    torchsde \
    kornia \
    xformers

# Create necessary directories
RUN mkdir -p /comfy/models/checkpoints && \
    mkdir -p /comfy/models/vae && \
    mkdir -p /comfy/models/loras && \
    mkdir -p /comfy/models/controlnet && \
    mkdir -p /comfy/input && \
    mkdir -p /comfy/output

# Set up entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port
EXPOSE 8188

# Add user management
ARG PUID=1000
ARG PGID=1000

# Create group and user
RUN groupadd -g $PGID comfy && \
    useradd -u $PUID -g $PGID -m -s /bin/bash comfy && \
    chown -R comfy:comfy /comfy

# Switch to non-root user
USER comfy

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
