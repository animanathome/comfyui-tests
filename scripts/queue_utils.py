import os
import requests
import shutil
import time
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

max_retries = 100
server_address = "http://127.0.0.1:8080"

# this is where comfyUI stores its temporary files or images
temp_directory = 'ComfyUI/temp/'
output_directory = 'output'

def queue_prompt(prompt, output_file):
    prompt_endpoint = f"{server_address}/prompt"

    try:
        response = requests.post(prompt_endpoint, json={"prompt": prompt})
        response.raise_for_status()
        prompt_id = response.json()['prompt_id']
        logger.info(f"Workflow queued successfully. Prompt ID: {prompt_id}")

        wait_for_image(prompt_id, output_file)
    except requests.RequestException as e:
        logger.info(f"Error queuing workflow: {e}")

def wait_for_image(prompt_id, output_file):
    for attempt in range(max_retries):
        try:
            history_response = requests.get(f"{server_address}/history/{prompt_id}")
            history_response.raise_for_status()
            history = history_response.json()

            if prompt_id in history:
                task_history = history[prompt_id]

                if 'outputs' in task_history and len(task_history['outputs']) > 0:
                    output = task_history['outputs']

                    for node in output.keys():
                        if 'images' in output[node]:
                            image_file = output[node]['images'][0]['filename']
                            source_path = os.path.join(temp_directory, image_file)
                            target_path = os.path.join(output_directory, output_file)
                            shutil.copy(source_path, target_path)
                            logger.info(f"Image saved: {target_path}")
                            return

            logger.info(f"Waiting for image... (Attempt {attempt + 1}/{max_retries})")
            time.sleep(1)
        except requests.RequestException as e:
            logger.info(f"Error checking history: {e}")
            time.sleep(1)

    logger.error("Max retries reached. Image generation may have failed.")
