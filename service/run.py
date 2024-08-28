import asyncio
import logging

from flask import Flask, request, jsonify
from werkzeug.exceptions import BadRequest

from download_utils import retrieve_media_list

app = Flask(__name__)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route('/', methods=['GET'])
def home():
    return "Welcome to the server!"

@app.route('/', methods=['POST'])
def handle_post():
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