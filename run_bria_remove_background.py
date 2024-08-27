import json
import time
import requests
import os
import shutil

max_retries = 100
server_address = "http://127.0.0.1:8080"
temp_directory = 'ComfyUI/temp/'
output_directory = 'output'


def prepare_workflow(workflow_file, input_file):
    with open(workflow_file, 'r') as file:
        workflow = json.load(file)
        image_node = workflow['1']
        image_node['inputs']['image'] = input_file

    return workflow


if not os.path.exists(output_directory):
    os.makedirs(output_directory)
    print(f"Directory '{output_directory}' created successfully")


def queue_prompt(prompt, output_file):
    prompt_endpoint = f"{server_address}/prompt"

    try:
        response = requests.post(prompt_endpoint, json={"prompt": prompt})
        response.raise_for_status()
        prompt_id = response.json()['prompt_id']
        print(f"Workflow queued successfully. Prompt ID: {prompt_id}")

        wait_for_image(prompt_id, output_file)
    except requests.RequestException as e:
        print(f"Error queuing workflow: {e}")


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
                            print(f"Image saved: {target_path}")
                            return

            print(f"Waiting for image... (Attempt {attempt + 1}/{max_retries})")
            time.sleep(1)
        except requests.RequestException as e:
            print(f"Error checking history: {e}")
            time.sleep(1)

    print("Max retries reached. Image generation may have failed.")


def get_output_filename(filename, suffix):
    name, extension = os.path.splitext(filename)
    return f'{name}{suffix}{extension}'


# we can convert a workflow into the API format using the /api/convert_workflow endpoint
workflow_file = 'api_workflows/bria-remove-background.json'
directory = 'ComfyUI/input'
input_files = [f for f in os.listdir(directory) if os.path.isfile(os.path.join(directory, f))]

for input_file in input_files:
    output_file = get_output_filename(input_file, '_mask')
    print('output_file', output_file)
    workflow = prepare_workflow(workflow_file, input_file)
    queue_prompt(workflow, output_file)