if [ -d "ComfyUI/custom_nodes/x-flux-comfyui/" ]; then
    echo "x-flux-comfyui exists"
else
    echo "x-flux-comfyui does not exist"
    cd ComfyUI/custom_nodes
    git clone https://github.com/XLabs-AI/x-flux-comfyui
    cd x-flux-comfyui/
    python setup.py
    cd $HOME
fi

if [ -d "ComfyUI/custom_nodes/comfyui_controlnet_aux" ]; then
    echo "comfyui_controlnet_aux exists"
else
    echo "comfyui_controlnet_aux does not exist"
    cd ComfyUI/custom_nodes/
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux/
    cd comfyui_controlnet_aux
    pip install -r requirements.txt
    cd $HOME
fi

huggingface-cli download black-forest-labs/FLUX.1-dev flux1-dev.safetensors --local-dir ComfyUI/models/unet
huggingface-cli download black-forest-labs/FLUX.1-dev ae.safetensors --local-dir ComfyUI/models/vae

huggingface-cli download comfyanonymous/flux_text_encoders clip_l.safetensors --local-dir ComfyUI/models/clip/
huggingface-cli download comfyanonymous/flux_text_encoders t5xxl_fp8_e4m3fn.safetensors --local-dir ComfyUI/models/clip/
huggingface-cli download comfyanonymous/flux_text_encoders t5xxl_fp16.safetensors --local-dir ComfyUI/models/clip/

huggingface-cli download openai/clip-vit-large-patch14 model.safetensors --local-dir ComfyUI/models/clip_vision/

# XLabs-AI
huggingface-cli download XLabs-AI/flux-ip-adapter flux-ip-adapter.safetensors --local-dir ComfyUI/models/xlabs/ipadapters/

huggingface-cli download XLabs-AI/flux-ip-adapter ip_adapter_workflow.json --local-dir ComfyUI/user/default/workflows

# canny
huggingface-cli download XLabs-AI/flux-controlnet-canny controlnet.safetensors --local-dir ComfyUI/models/xlabs/controlnets/
huggingface-cli download XLabs-AI/flux-controlnet-collections flux-canny-controlnet.safetensors --local-dir ComfyUI/models/xlabs/controlnets/
huggingface-cli download XLabs-AI/flux-controlnet-collections flux-canny-controlnet_v2.safetensors --local-dir ComfyUI/models/xlabs/controlnets/
huggingface-cli download XLabs-AI/flux-controlnet-canny-v3 flux-canny-controlnet-v3.safetensors --local-dir ComfyUI/models/xlabs/controlnets/

huggingface-cli download XLabs-AI/flux-controlnet-canny-v3 flux-controlnet-canny-v3-workflow.json --local-dir ComfyUI/user/default/workflows

# depth
huggingface-cli download XLabs-AI/flux-controlnet-collections flux-depth-controlnet.safetensors --local-dir ComfyUI/models/xlabs/controlnets/
huggingface-cli download XLabs-AI/flux-controlnet-collections flux-depth-controlnet_v2.safetensors --local-dir ComfyUI/models/xlabs/controlnets/
huggingface-cli download XLabs-AI/flux-controlnet-depth-v3 flux-depth-controlnet-v3.safetensors --local-dir ComfyUI/models/xlabs/controlnets/

huggingface-cli download XLabs-AI/flux-controlnet-depth-v3 flux-controlnet-depth-v3-workflow.json --local-dir ComfyUI/user/default/workflows


# hed
huggingface-cli download XLabs-AI/flux-controlnet-collections flux-hed-controlnet.safetensors --local-dir ComfyUI/models/xlabs/controlnets/
huggingface-cli download XLabs-AI/flux-controlnet-hed-v3 flux-hed-controlnet-v3.safetensors --local-dir ComfyUI/models/xlabs/controlnets/

huggingface-cli download XLabs-AI/flux-controlnet-hed-v3 flux-controlnet-hed-v3-workflow.json --local-dir ComfyUI/user/default/workflows

# loras
#huggingface-cli download XLabs-AI/flux-RealismLora lora.safetensors --local-dir ComfyUI/models/xlabs/loras
#huggingface-cli download XLabs-AI/flux-lora-collection disney_lora.safetensors --local-dir ComfyUI/models/xlabs/loras
#huggingface-cli download XLabs-AI/flux-lora-collection furry_lora.safetensors --local-dir ComfyUI/models/xlabs/loras
#huggingface-cli download XLabs-AI/flux-lora-collection realism_lora.safetensors --local-dir ComfyUI/models/xlabs/loras
#huggingface-cli download XLabs-AI/flux-lora-collection scenery_lora.safetensors --local-dir ComfyUI/models/xlabs/loras
#huggingface-cli download XLabs-AI/flux-lora-collection art_lora.safetensors --local-dir ComfyUI/models/xlabs/loras

huggingface-cli download XLabs-AI/flux-lora-collection anime_lora_comfy_converted.safetensors --local-dir ComfyUI/models/xlabs/loras
huggingface-cli download XLabs-AI/flux-lora-collection art_lora_comfy_converted.safetensors --local-dir ComfyUI/models/xlabs/loras
huggingface-cli download XLabs-AI/flux-lora-collection disney_lora_comfy_converted.safetensors --local-dir ComfyUI/models/xlabs/loras
huggingface-cli download XLabs-AI/flux-lora-collection mjv6_lora_comfy_converted.safetensors --local-dir ComfyUI/models/xlabs/loras
huggingface-cli download XLabs-AI/flux-lora-collection realism_lora_comfy_converted.safetensors --local-dir ComfyUI/models/xlabs/loras
huggingface-cli download XLabs-AI/flux-lora-collection scenery_lora_comfy_converted.safetensors --local-dir ComfyUI/models/xlabs/loras

# custom - manu
huggingface-cli download animanatwork/simpletuner-lora pytorch_lora_weights.safetensors --local-dir ComfyUI/models/xlabs/loras

huggingface-cli download animanatwork/kaegan-lora pytorch_lora_weights.safetensors --local-dir ComfyUI/models/xlabs/loras











wget  -c https://github.com/XLabs-AI/x-flux-comfyui/blob/main/workflows/lora_workflow.json -P ComfyUI/user/default/workflows



