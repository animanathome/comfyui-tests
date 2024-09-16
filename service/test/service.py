import requests
import json

SAMPLE_GET_WORKFLOW_PAYLOAD = {
    "prompt_id": "123"
}

SAMPLE_RUN_WORKFLOW_PAYLOAD = {
    "workflow": "bria_remove_background",
    "media": "https://storage.googleapis.com/lumen5-prod-video/preview-Yh9L-contentvideoMPaEbz-videoblocks-medium-slow-motion-footage-of-multi-ethnic-office-workers-working-late-in-dark-loft-offic.mp4"   
}

SAMPLE_MEDIA_DOWNLOAD_PAYLOAD = {
    "media": [
        "https://storage.googleapis.com/lumen5-prod-video/preview-Yh9L-contentvideoMPaEbz-videoblocks-medium-slow-motion-footage-of-multi-ethnic-office-workers-working-late-in-dark-loft-offic.mp4",
        "https://storage.googleapis.com/lumen5-prod-video/videocontentBLOmnPQpWj8vjeh8vvideoblocks-handsome-african-american-man-working-on-laptop-look-at-camera-smile-work-with-document-bdsjW.mp4",
    ]
}

def test_get_workflows():
    url = 'http://localhost:7501/workflows'
    response = requests.get(url)
    print(response.json())


def test_run_workflow():
    url = 'http://localhost:7501/workflow'
    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, data=json.dumps(SAMPLE_RUN_WORKFLOW_PAYLOAD), headers=headers)

    if response.status_code == 200:
        print(f"Run workflow request successful! {response.json()}")
    else:
        print("Run workflow request failed with status code:", response.status_code)


def test_media_download():
    url = 'http://localhost:7501'
    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, data=json.dumps(SAMPLE_MEDIA_DOWNLOAD_PAYLOAD), headers=headers)

    if response.status_code == 202:
        print("Media download request successful!")
    else:
        print("Media download request failed with status code:", response.status_code)


if __name__ == '__main__':
    test_media_download()
    test_get_workflows()
    test_run_workflow()