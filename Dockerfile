FROM rocm/pytorch:rocm6.3.3_ubuntu24.04_py3.12_pytorch_release_2.4.0

WORKDIR /comfy

# Clone ComfyUI repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# Install the basic required dependencies
RUN pip3 install --upgrade 'optree>=0.14.1'
RUN pip3 uninstall -y torch torchvision
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/rocm6.3
RUN pip3 install --no-cache-dir -r requirements.txt

ARG PUID=1000
ARG PGID=1000

RUN groupadd -g $PGID comfy || true && \
    useradd -u $PUID -g $PGID -m -s /bin/bash comfy || true && \
    chown -R $PUID:$PGID /comfy

EXPOSE 8188

USER $PUID

# Add a verification script
RUN echo '#!/bin/bash\n\
python3 -c "import torch; print(\"ROCm available:\", torch.cuda.is_available()); print(\"Device count:\", torch.cuda.device_count())" && \
python3 main.py --listen 0.0.0.0 --port 8188 --use-split-cross-attention' > /comfy/entrypoint.sh && \
chmod +x /comfy/entrypoint.sh

CMD ["/comfy/entrypoint.sh"]