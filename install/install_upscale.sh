#!/bin/bash

# Define an array of repositories
repos=(
    "https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet"
    "https://github.com/city96/ComfyUI-GGUF"
    "https://github.com/shiimizu/ComfyUI-TiledDiffusion"
    "https://github.com/stavsap/comfyui-ollama"
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/Derfuu/Derfuu_ComfyUI_ModdedNodes"
    "https://github.com/BlenderNeko/ComfyUI_Noise"
    "https://github.com/giriss/comfy-image-saver"
    "https://github.com/WASasquatch/was-node-suite-comfyui"
)

cd comfyui-tests/ComfyUI/custom_nodes || exit
for repo in "${repos[@]}"; do
    repo_name=$(basename "$repo")

    if [ -d "$repo_name" ]; then
        echo "Directory $repo_name already exists. Skipping clone."
    else
        git clone "$repo"
    fi

    cd "$repo_name" || continue

    if [ -f "requirements.txt" ]; then
        echo "Installing requirements for $repo_name"
        pip install -r requirements.txt
    else
        echo "No requirements.txt found for $repo_name"
    fi

    cd ..
done

curl https://ollama.ai/install.sh | sh
ollama pull llava
ollama run llava

#https://github.com/city96/ComfyUI-GGUF?tab=readme-ov-file
#https://huggingface.co/city96/FLUX.1-dev-gguf
huggingface-cli download city96/FLUX.1-dev-gguf flux1-dev-Q8_0.gguf --local-dir ComfyUI/models/unet
huggingface-cli download black-forest-labs/FLUX.1-dev ae.safetensors --local-dir ComfyUI/models/vae
#rename ae.safetensors to fluxvae.safetensors