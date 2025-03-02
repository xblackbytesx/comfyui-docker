## Before starting create some folders and fetch the base model
```
mkdir -p models/{checkpoints,vae,loras,controlnet} input output workflows
```

```
curl -L -# -o models/checkpoints/v1-5-pruned-emaonly-fp16.safetensors https://huggingface.co/Comfy-Org/stable-diffusion-v1-5-archive/resolve/main/v1-5-pruned-emaonly-fp16.safetensors
```

## Download Flux1 Schnell
```
curl -L -# -o models/checkpoints/flux1-schnell-fp8.safetensors https://huggingface.co/Comfy-Org/flux1-schnell/resolve/main/flux1-schnell-fp8.safetensors
```
