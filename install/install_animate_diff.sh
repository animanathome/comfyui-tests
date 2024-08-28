#https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved?tab=readme-ov-file

cd $HOME || exit
cd ComfyUI/custom_nodes/
git clone https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git

# install ComfyUI-Advanced-ControlNet
cd ComfyUI/custom_nodes/
git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
cd $HOME || exit

# install ComfyUI-VideoHelperSuite
cd ComfyUI/custom_nodes/
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
cd ComfyUI-VideoHelperSuite || exit
pip install -r requirements.txt
cd $HOME || exit

# install comfyui_controlnet_aux
cd ComfyUI/custom_nodes/
git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git
cd comfyui_controlnet_aux || exit
pip install -r requirements.txt
cd $HOME || exit

# install ComfyUI_IPAdapter_plus
cd ComfyUI/custom_nodes/
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
cd $HOME || exit

# install ComfyUI-KJNodes
cd ComfyUI/custom_nodes/
git clone https://github.com/kijai/ComfyUI-KJNodes.git
cd ComfyUI-KJNodes || exit
pip install -r requirements.txt
cd $HOME || exit

# install ComfyUI_FizzNodes
cd ComfyUI/custom_nodes/
git clone https://github.com/FizzleDorf/ComfyUI_FizzNodes.git
cd ComfyUI_FizzNodes || exit
pip install -r requirements.txt
cd $HOME || exit

huggingface-cli download guoyww/animatediff mm_sd_v14.ckpt --local-dir ComfyUI/custom_nodes/ComfyUI-AnimateDiff-Evolved/models
huggingface-cli download guoyww/animatediff mm_sd_v15.ckpt --local-dir ComfyUI/custom_nodes/ComfyUI-AnimateDiff-Evolved/models
huggingface-cli download guoyww/animatediff mm_sd_v15_v2.ckpt --local-dir ComfyUI/custom_nodes/ComfyUI-AnimateDiff-Evolved/models
huggingface-cli download guoyww/animatediff v3_sd15_mm.ckpt --local-dir ComfyUI/custom_nodes/ComfyUI-AnimateDiff-Evolved/models

huggingface-cli download manshoety/AD_Stabilized_Motion mm-Stabilized_high.pth --local-dir ComfyUI/custom_nodes/ComfyUI-AnimateDiff-Evolved/models
huggingface-cli download manshoety/AD_Stabilized_Motion mm-Stabilized_mid.pth --local-dir ComfyUI/custom_nodes/ComfyUI-AnimateDiff-Evolved/models

huggingface-cli download CiaraRowles/TemporalDiff temporaldiff-v1-animatediff.ckpt --local-dir ComfyUI/custom_nodes/ComfyUI-AnimateDiff-Evolved/models

# copy over sample png workflows
