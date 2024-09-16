import asyncio
import logging
import aiohttp

from flask import Flask, request, jsonify, send_from_directory
from werkzeug.exceptions import BadRequest

from utils.download_utils import retrieve_media_list
from utils.workflow_utils import get_all_workflows
from tasks import run_workflow, get_workflow_output

from settings import SERVICE_OUTPUT_PATH

app = Flask(__name__)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@app.route('/', methods=['GET'])
def home():
    return "Welcome to the server!"


@app.route('/workflows', methods=['GET'])
def workflows():
    """
    Returns all available Comfyui workflows
    """
    workflows = get_all_workflows()
    return jsonify({"workflows": workflows})


@app.route('/workflow', methods=['POST'])
def run_workflow_task():
    """
    Run a workflow
    """
    try:
        if not request.is_json:
            raise BadRequest("Request must be JSON")

        data = request.get_json()

        if 'media' not in data or 'workflow' not in data:
            raise Exception("Invalid request. Expect both workflow and media defined")         

        prompt_id = asyncio.run(run_workflow(data['workflow'], data['media']))

        return jsonify({"prompt_id": prompt_id})
    
    except Exception as e:
        logger.exception("An error occurred while processing the request")
        return jsonify({"error": "Internal server error"}), 500


@app.route('/workflow', methods=['GET'])
def get_worflow():
    """
    Get the result of a given workflow
    """
    try:
        if not request.is_json:
            raise BadRequest("Request must be JSON")

        data = request.get_json()

        if 'prompt_id' not in data:
            raise Exception("Invalid request. Expect prompt_id defined")         

        output = get_workflow_output(data['prompt_id'])

        return jsonify({"output": output})
    
    except Exception as e:
        logger.exception("An error occurred while processing the request")
        return jsonify({"error": "Internal server error"}), 500


@app.route('/media/<path:filename>')
def serve_media(filename):
    return send_from_directory(SERVICE_OUTPUT_PATH, filename)


@app.route('/', methods=['POST'])
def download_media():
    """
    Downloads all of the media specified in the request.
    """
    try:
        if not request.is_json:
            raise BadRequest("Request must be JSON")

        data = request.get_json()

        if 'media' in data and len(data['media']) > 0:
            asyncio.run(retrieve_media_list(data['media'], './downloads'))

        return jsonify({"message": "Media processing initiated", "data": data}), 202
    except BadRequest as e:
        logger.error(f"Bad request: {str(e)}")
        return jsonify({"error": str(e)}), 400
    except Exception as e:
        logger.exception("An error occurred while processing the request")
        return jsonify({"error": "Internal server error"}), 500


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=7501, debug=True)