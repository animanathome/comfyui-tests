import requests
import json


def test_payload():
    url = 'http://localhost:7501'  # Adjust this to your actual server address and port

    with open('./test/sample_payload.json', 'r') as file:
        data = json.load(file)

    json_data = json.dumps(data)

    headers = {'Content-Type': 'application/json'}

    # Send the POST request
    response = requests.post(url, data=json_data, headers=headers)

    # Check the response
    if response.status_code == 202:
        print("Request successful!")
    else:
        print("Request failed with status code:", response.status_code)


if __name__ == '__main__':
    test_payload()