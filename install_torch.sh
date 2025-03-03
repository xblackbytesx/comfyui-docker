#!/bin/bash

# Set up logging
exec 1> >(tee -a "/comfy/pytorch_install.log") 2>&1
echo "Starting PyTorch installation script at $(date)"

# Install PyTorch with ROCm support (includes CPU fallback)
echo "Installing PyTorch with ROCm support"
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.7

# Verify installation
echo "Verifying PyTorch installation..."
python3 -c "import torch; print(f'PyTorch {torch.__version__} installed successfully. ROCm available: {torch.cuda.is_available()}')"

echo "Installation script completed at $(date)"