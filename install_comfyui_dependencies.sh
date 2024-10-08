#!/bin/bash
set -u

HOME=$(pwd)

# Check if HUGGINGFACE_TOKEN is set
: "${HUGGINGFACE_TOKEN:?Variable HUGGINGFACE_TOKEN is not set}"

# Function to display usage information
usage() {
    echo "Usage: $0 [-v|--verbose] [-f|--file <filename>] [-h|--help]"
    echo "Options:"
    echo "  -if,  --install_flux                 Install Flux"
    echo "  -isa, --install_segment_anything     Install Segment anything"
    echo "  -iad, --install_animate_diff         Install Animated diff"
    echo "  -icg, --install_caption_generation   Install Caption Generation"
    echo "  -r,   --run                          Run Comfy on completion"
    echo "  -h,   --help                         Display this help message"
}

install_flux=false
install_segment_anything=false
install_animate_diff=false
install_caption_generation=false
run_comfy=false

# Check if no arguments were provided
if [ $# -eq 0 ]; then
    usage
    exit 1
fi

# Parse command line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        -if|--install_flux)
            install_flux=true
            ;;
        -isa|--install_segment_anything)
            install_segment_anything=true
            ;;
        -iad|--install_animate_diff)
            install_animate_diff=true
            ;;
        -icg|--install_caption_generation)
            install_caption_generation=true
            ;;
        -r|--run)
            run_comfy=true
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
    shift
done

# install ComfyUI
cd $HOME || exit
if [ -d "ComfyUI" ]; then
    echo "ComfyUI exists"
else
    echo "ComfyUI does not exist"
    git clone https://github.com/comfyanonymous/ComfyUI
    cd ComfyUI || exit
    pip install -r requirements.txt
fi

# copy over settings
cd $HOME || exit
if [ -d "ComfyUI/user/default/" ]; then
    echo "ComfyUI has been installed. Copying over settings..."
    cp comfy.settings.json ComfyUI/user/default/comfy.settings.json
fi

# copy over assets
if [ -d "ComfyUI/input/" ]; then
    echo "ComfyUI has been installed. Copying over assets..."
    cp -r assets/* ComfyUI/input/
fi

pip install -U onnxruntime-gpu

## workflows as stored here
## /teamspace/studios/this_studio/ComfyUI/user/default/workflows

# install hugging face command line interface
if command -v huggingface-cli >/dev/null 2>&1; then
    echo "huggingface-cli exists"
else
    echo "huggingface-cli does not exist"
    pip install -U "huggingface_hub[cli]"
    cd $HOME || exit
fi

# log into hugging face so we can download flux
huggingface-cli login --token $HUGGINGFACE_TOKEN

# install flux
if ($install_flux); then
  cd $HOME || exit
  . install/install_flux.sh
fi

# install segment anything
if ($install_segment_anything); then
  cd $HOME || exit
  . install/install_segment_anything.sh
fi

# install caption generation
cd $HOME || exit
if ($install_caption_generation); then
  cd $HOME || exit
  . install/install_image_captioning.sh
fi

# install animate diff
cd $HOME || exit
if ($install_animate_diff); then
  cd $HOME || exit
  . install/install_animate_diff.sh
fi

# install BRIA
cd $HOME || exit
if [ -d "ComfyUI/custom_nodes/ComfyUI-BRIA_AI-RMBG" ]; then
    echo "ComfyUI-BRIA_AI-RMBG exists"
else
    echo "installing ComfyUI-BRIA_AI-RMBG"
    cd ComfyUI/custom_nodes/
    git clone https://github.com/ZHO-ZHO-ZHO/ComfyUI-BRIA_AI-RMBG.git
    cd $HOME || exit
    huggingface-cli download briaai/RMBG-1.4 model.pth --local-dir ComfyUI/custom_nodes/ComfyUI-BRIA_AI-RMBG/RMBG-1.4
fi

# launch using new UI
if ($run_comfy); then
    python ComfyUI/main.py --port 8080 --front-end-version Comfy-Org/ComfyUI_frontend@latest
fi