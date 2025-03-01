#!/bin/bash

# Function to check ROCm capability
check_rocm() {
    if rocminfo &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to install PyTorch
install_pytorch() {
    local install_type=$1
    local max_retries=3
    local retry=0
    local success=false

    while [ $retry -lt $max_retries ] && [ "$success" = false ]; do
        if [ "$install_type" = "rocm" ]; then
            echo "Attempting ROCm PyTorch installation (attempt $((retry+1))/$max_retries)"
            if pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.7; then
                success=true
            fi
        else
            echo "Attempting CPU PyTorch installation (attempt $((retry+1))/$max_retries)"
            if pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu; then
                success=true
            fi
        fi
        
        if [ "$success" = false ]; then
            retry=$((retry+1))
            echo "Installation failed, waiting before retry..."
            sleep 5
        fi
    done

    if [ "$success" = false ]; then
        echo "Failed to install PyTorch after $max_retries attempts"
        exit 1
    fi
}

# Main installation logic
echo "Checking ROCm capability..."
if check_rocm; then
    echo "ROCm is available, installing PyTorch with ROCm support"
    install_pytorch "rocm"
else
    echo "ROCm not available, installing CPU-only PyTorch"
    install_pytorch "cpu"
fi

# Verify installation
if python3 -c "import torch; print(f'PyTorch {torch.__version__} installed successfully. CUDA available: {torch.cuda.is_available()}')" ; then
    echo "PyTorch installation verified successfully"
else
    echo "PyTorch installation verification failed"
    exit 1
fi
