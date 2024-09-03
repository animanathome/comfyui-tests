#!/bin/bash

# Define an array of repositories
repos=(
    "https://github.com/kijai/ComfyUI-LivePortraitKJ"
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/cubiq/ComfyUI_essentials"
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