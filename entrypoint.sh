#!/bin/bash

# Function to check if PyTorch can access GPU
check_gpu_access() {
    python3 -c "import torch; print('ROCm available:', torch.cuda.is_available()); print('Device count:', torch.cuda.device_count()); assert torch.cuda.is_available() and torch.cuda.device_count() > 0, 'GPU not available'"
    return $?
}

# Initialize variables
GPU_MODE="CPU"
EXTRA_ARGS=""

# Check for GPU access
if check_gpu_access 2>/dev/null; then
    echo "GPU access confirmed - running in GPU mode"
    GPU_MODE="GPU"
    # For ROCm, we explicitly set the device
    export HIP_VISIBLE_DEVICES=0
else
    echo "Running in CPU mode - GPU access not available"
    EXTRA_ARGS="--cpu"
fi

# Print startup information
echo "Starting ComfyUI in $GPU_MODE mode"
echo "Python version: $(python3 --version)"
python3 -c "import torch; print(f'PyTorch version: {torch.__version__}'); print(f'ROCm available: {torch.cuda.is_available()}'); print(f'Device count: {torch.cuda.device_count()}'); print(f'Current device: {torch.cuda.current_device() if torch.cuda.is_available() else "none"}')"
echo "Extra arguments: $EXTRA_ARGS"

# Start ComfyUI
exec python main.py --listen 0.0.0.0 --port 8188 $EXTRA_ARGS "$@"