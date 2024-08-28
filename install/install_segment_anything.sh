# Segment anything
# https://github.com/storyicon/comfyui_segment_anything
if [ -d "ComfyUI/custom_nodes/comfyui_segment_anything" ]; then
    echo "comfyui_segment_anything already exists"
else
    echo "installing comfyui_segment_anything"
    cd $HOME
    cd ComfyUI/custom_nodes/
    git clone https://github.com/storyicon/comfyui_segment_anything
    cd comfyui_segment_anything
    pip install -r requirements.txt
    cd $HOME
fi

# models
huggingface-cli download google-bert/bert-base-uncased model.safetensors --local-dir ComfyUI/models/bert-base-uncased
huggingface-cli download google-bert/bert-base-uncased config.json --local-dir ComfyUI/models/bert-base-uncased
huggingface-cli download google-bert/bert-base-uncased tokenizer_config.json --local-dir ComfyUI/models/bert-base-uncased
huggingface-cli download google-bert/bert-base-uncased tokenizer.json --local-dir ComfyUI/models/bert-base-uncased
huggingface-cli download google-bert/bert-base-uncased vocab.txt --local-dir ComfyUI/models/bert-base-uncased

huggingface-cli download ShilongLiu/GroundingDINO GroundingDINO_SwinT_OGC.cfg.py --local-dir ComfyUI/models/grounding-dino
huggingface-cli download ShilongLiu/GroundingDINO groundingdino_swint_ogc.pth --local-dir ComfyUI/models/grounding-dino
huggingface-cli download ShilongLiu/GroundingDINO GroundingDINO_SwinB.cfg.py --local-dir ComfyUI/models/grounding-dino
huggingface-cli download ShilongLiu/GroundingDINO groundingdino_swinb_cogcoor.pth --local-dir ComfyUI/models/grounding-dino

#sams
wget -c https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth -P ComfyUI/models/sams
wget -c https://dl.fbaipublicfiles.com/segment_anything/sam_vit_l_0b3195.pth -P ComfyUI/models/sams
wget -c https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth -P ComfyUI/models/sams
wget -c https://github.com/ChaoningZhang/MobileSAM/blob/master/weights/mobile_sam.pt -P ComfyUI/models/sams

huggingface-cli download lkeab/hq-sam sam_hq_vit_h.pth --local-dir ComfyUI/models/sams
huggingface-cli download lkeab/hq-sam sam_hq_vit_l.pth --local-dir ComfyUI/models/sams
huggingface-cli download lkeab/hq-sam sam_hq_vit_b.pth --local-dir ComfyUI/models/sams
