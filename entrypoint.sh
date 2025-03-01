#!/bin/bash

# Function to check if PyTorch can access GPU
check_gpu_access() {
    python3 -c "import torch; assert torch.cuda.is_available(), 'GPU not available'"
    return $?
}

# Initialize variables
GPU_MODE="CPU"
EXTRA_ARGS=""

# Check for GPU access
if check_gpu_access 2>/dev/null; then
    echo "GPU access confirmed - running in GPU mode"
    GPU_MODE="GPU"
else
    echo "Running in CPU mode - GPU access not available"
    EXTRA_ARGS="--cpu"
fi

# Print startup information
echo "Starting ComfyUI in $GPU_MODE mode"
echo "Python version: $(python3 --version)"
python3 -c "import torch; print(f'PyTorch version: {torch.__version__}')"
echo "Extra arguments: $EXTRA_ARGS"

# Start ComfyUI
exec python main.py --listen 0.0.0.0 --port 8188 $EXTRA_ARGS "$@"
