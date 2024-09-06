#!/bin/bash

# Define an array of repositories
repos=(
    "https://github.com/kijai/ComfyUI-LivePortraitKJ"
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/cubiq/ComfyUI_essentials"
    "https://github.com/shadowcz007/comfyui-liveportrait"
    "https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait"
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

# appearance_feature_extractor.pth is created from appearance_feature_extractor.safetensors during DownloadAndLoadLivePortraitModels
huggingface-cli download Kijai/LivePortrait_safetensors appearance_feature_extractor.safetensors --local-dir ComfyUI/models/liveportrait
huggingface-cli download Kijai/LivePortrait_safetensors landmark_model.pth --local-dir ComfyUI/models/liveportrait
huggingface-cli download Kijai/LivePortrait_safetensors motion_extractor.safetensors --local-dir ComfyUI/models/liveportrait
huggingface-cli download Kijai/LivePortrait_safetensors spade_generator.safetensors --local-dir ComfyUI/models/liveportrait
huggingface-cli download Kijai/LivePortrait_safetensors stitching_retargeting_module.safetensors --local-dir ComfyUI/models/liveportrait
huggingface-cli download Kijai/LivePortrait_safetensors warping_module.safetensors --local-dir ComfyUI/models/liveportrait
huggingface-cli download Kijai/LivePortrait_safetensors landmark.onnx --local-dir ComfyUI/models/liveportrait

huggingface-cli download KwaiVGI/LivePortrait liveportrait/base_models/appearance_feature_extractor.pth --local-dir ComfyUI/models/
huggingface-cli download KwaiVGI/LivePortrait liveportrait/base_models/motion_extractor.pth --local-dir ComfyUI/models/
huggingface-cli download KwaiVGI/LivePortrait liveportrait/base_models/spade_generator.pth --local-dir ComfyUI/models/
huggingface-cli download KwaiVGI/LivePortrait liveportrait/base_models/warping_module.pth --local-dir ComfyUI/models/

huggingface-cli download Bingsu/adetailer face_yolov8n.pt  --local-dir ComfyUI/models/ultralytics/





