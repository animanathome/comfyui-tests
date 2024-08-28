import json
import os
import logging

from workflow_utils import get_node_index, set_image_input
from queue_utils import queue_prompt
from file_utils import get_output_filename

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def prepare_workflow(
        workflow_file,
        input_image_file,
        seed=324242532548,
        steps=25,
        description="handsome woman in balenciaga style, fashion, vogue image"
):
    with open(workflow_file, 'r') as file:
        workflow = json.load(file)

    workflow = set_image_input(workflow, input_image_file)

    index = get_node_index(workflow, "XlabsSampler")
    workflow[index]['inputs']['noise_seed'] = seed
    workflow[index]['inputs']['steps'] = steps

    index = get_node_index(workflow, "CLIPTextEncodeFlux")
    workflow[index]['inputs']['clip_l'] = description
    workflow[index]['inputs']['t5xxl'] = description

    return workflow

if __name__ == '__main__':
    workflow_file = 'api_workflows/flux-controlnet-depth-v3-workflow.json'
    directory = 'ComfyUI/input'
    input_files = [f for f in os.listdir(directory) if os.path.isfile(os.path.join(directory, f))]

    for input_file in input_files:
        output_file = get_output_filename(input_file, '_depth')
        logger.info('output_file', output_file)

        workflow = prepare_workflow(workflow_file, input_file)
        queue_prompt(workflow, output_file)