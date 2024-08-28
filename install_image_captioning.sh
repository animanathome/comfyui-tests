cd $HOME || exit
if [ -d "ComfyUI/custom_nodes/ComfyUI-Image-Captioner" ]; then
    echo "ComfyUI-Image-Captioner exists"
else
  cd ComfyUI/custom_nodes/
  git clone https://github.com/neverbiasu/ComfyUI-Image-Captioner.git
  cd ComfyUI-Image-Captioner || exit
  pip install -r requirements.txt
  cd $HOME || exit
fi