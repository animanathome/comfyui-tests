
# Run get media service
Simple service which downloads the media list send to it. If an media item is a video, it will download the video and extract an image. 
```bash
./install_dependencies.sh
python service/run.py
```

# Run ComfyUI
```bash
export HUGGINGFACE_TOKEN=<huggingface_token>
./install_comfyui_dependencies.sh -if -r
```

# Run ComfyUI script