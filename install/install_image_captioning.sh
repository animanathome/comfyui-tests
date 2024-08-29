cd $HOME || exit
if [ -d "ComfyUI/custom_nodes/ComfyUI-Image-Captioner" ]; then
    echo "ComfyUI-Image-Captioner exists"
else
  cd ComfyUI/custom_nodes/
  git clone https://github.com/pythongosssss/ComfyUI-WD14-Tagger.git
  cd ComfyUI-WD14-Tagger
  pip install -r requirements.txt
fi

cd $HOME || exit
huggingface-cli download SmilingWolf/wd-eva02-large-tagger-v3 model.onnx --local-dir ComfyUI/custom_nodes/ComfyUI-WD14-Tagger/models
mv ComfyUI/custom_nodes/ComfyUI-WD14-Tagger/models/model.onnx ComfyUI/custom_nodes/ComfyUI-WD14-Tagger/models/wd-eva02-large-tagger-v3.onnx

huggingface-cli download SmilingWolf/wd-eva02-large-tagger-v3 selected_tags.csv --local-dir ComfyUI/custom_nodes/ComfyUI-WD14-Tagger/models
mv ComfyUI/custom_nodes/ComfyUI-WD14-Tagger/models/selected_tags.csv ComfyUI/custom_nodes/ComfyUI-WD14-Tagger/models/wd-eva02-large-tagger-v3.csv

# can't build CUDA version due to incompatibility issue and CPU version results in a segmentation error
# cd $HOME || exit
# if [ -d "ComfyUI/custom_nodes/ComfyUI-LLaVA-Captioner" ]; then
#     echo "ComfyUI-LLaVA-Captioner exists"
# else
#   cd ComfyUI/custom_nodes/
#   git clone https://github.com/ceruleandeep/ComfyUI-LLaVA-Captioner.git
# fi
# cd $HOME || exit

# # python install.py install llama-cpp-python which ends up failing so we're doing it manually here
# # https://github.com/abetlen/llama-cpp-python
# # pip install llama-cpp-python --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cu121
# CMAKE_ARGS="-DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLA -DGGML_CUDA=off" pip install llama-cpp-python --upgrade --no-cache-dir
# #CMAKE_ARGS="-DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS" pip install llama-cpp-python
# #pip install llama-cpp-python --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cpu --upgrade --force-reinstall --no-cache-dir

# huggingface-cli download jartine/llava-v1.5-7B-GGUF llava-v1.5-7b-Q4_K.gguf --local-dir ComfyUI/custom_nodes/ComfyUI-LLaVA-Captioner/models/
# huggingface-cli download jartine/llava-v1.5-7B-GGUF llava-v1.5-7b-mmproj-Q4_0.gguf --local-dir ComfyUI/custom_nodes/ComfyUI-LLaVA-Captioner/models/