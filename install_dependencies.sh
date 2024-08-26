#!/bin/sh
set -u

HOME=$(pwd)
INSTALLPATH=$(cd .. && pwd)

# Check if HUGGINGFACE_TOKEN is set
: "${HUGGINGFACE_TOKEN:?Variable HUGGINGFACE_TOKEN is not set}"

# Function to display usage information
usage() {
    echo "Usage: $0 [-v|--verbose] [-f|--file <filename>] [-h|--help]"
    echo "Options:"
    echo "  -if,  --install_flux                 Install Flux"
    echo "  -isa, --install_segment_anything     Install Segment anything"
    echo "  -r,   --run                          Run Comfy on completion"
    echo "  -h,   --help                         Display this help message"
}

install_flux=false
install_segment_anything=false
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
cd $INSTALLPATH || exit
if [ -d "ComfyUI" ]; then
    echo "ComfyUI exists"
else
    echo "ComfyUI does not exist"
    git clone https://github.com/comfyanonymous/ComfyUI
    cd ComfyUI || exit
    pip install -r requirements.txt
fi

# copy over settings
cd $INSTALLPATH || exit
if [ -d "ComfyUI/user/default/" ]; then
    echo "ComfyUI has been installed. Copying over settings..."
    cp comfy.settings.json ComfyUI/user/default/comfy.settings.json
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
    cd $INSTALLPATH || exit
fi

# log into hugging face so we can download flux
huggingface-cli login --token $HUGGINGFACE_TOKEN

# install flux
if ($install_flux); then
  cd $HOME || exit
  source install_flux.sh
fi

# install segment anything
if ($install_segment_anything); then
  cd $HOME || exit
  source install_segment_anything.sh
fi

# launch using new UI
if ($run_comfy); then
    python ComfyUI/main.py --front-end-version Comfy-Org/ComfyUI_frontend@latest
fi