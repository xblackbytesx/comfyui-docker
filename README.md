## Before starting create some folders and fetch the base model
```
mkdir -p models/{checkpoints,vae,loras,controlnet,diffusion_models,text_encoders} input output workflows
```

```
curl -L -# -o models/checkpoints/v1-5-pruned-emaonly-fp16.safetensors https://huggingface.co/Comfy-Org/stable-diffusion-v1-5-archive/resolve/main/v1-5-pruned-emaonly-fp16.safetensors
```

## Download Flux1 Schnell & Flux1 Dev
```
curl -L -# -o models/checkpoints/flux1-schnell-fp8.safetensors https://huggingface.co/Comfy-Org/flux1-schnell/resolve/main/flux1-schnell-fp8.safetensors
```
```
curl -L -# -o models/checkpoints/flux1-dev-fp8.safetensors https://huggingface.co/Comfy-Org/flux1-dev/resolve/main/flux1-dev-fp8.safetensors
```

## Download some text encoders
```
curl -L -# -o models/text_encoders/clip_l.safetensors https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors
```
```
curl -L -# -o models/text_encoders/t5xxl_fp16.safetensors https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors
```

