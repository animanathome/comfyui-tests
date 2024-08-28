import os
from urllib.parse import urlparse
import aiohttp
import aiofiles
import asyncio
from functools import partial
from file_utils import check_file_type, change_filename_extension
from media_utils import extract_frame_from_video
import shutil

TIMESTAMP = '00:00:00'


def move_file_based_on_filetype(filepath, filetype):
    dirname = os.path.dirname(filepath)
    os.makedirs(os.path.join(dirname, filetype), exist_ok=True)

    filename = os.path.basename(filepath)
    destination = os.path.join(dirname, filetype, filename)

    try:
        shutil.move(filepath, destination)
    except FileNotFoundError:
        print(f"Error: The file {filepath} does not exist.")
    except PermissionError:
        print(f"Error: Permission denied when trying to move {filepath}")
    except shutil.Error as e:
        print(f"Error moving file: {e}")

    return destination


def get_filename(url):
    return os.path.basename(urlparse(url).path) or 'unnamed_file'


async def download_file(session, url, destination):
    filename = os.path.join(destination, get_filename(url))
    try:
        async with session.get(url) as response:
            if response.status == 200:
                async with aiofiles.open(filename, mode='wb') as f:
                    await f.write(await response.read())
                print(f"Downloaded {filename} successfully.")
                return filename
            else:
                print(f"Failed to download {url}. Status code: {response.status}")
    except Exception as e:
        print(f"Error downloading {url}: {str(e)}")


async def download_and_process_file(session, url, destination):
    try:
        filename = await download_file(session, url, destination)
        filetype = await asyncio.to_thread(check_file_type, filename)

        if filetype == 'video':
            image_filename = await asyncio.to_thread(change_filename_extension, filename, '.jpg')

            extract_frame = partial(extract_frame_from_video, filename, TIMESTAMP, image_filename)
            extracted_frame = await asyncio.to_thread(extract_frame)

            move_image = partial(move_file_based_on_filetype, image_filename, 'image')
            moved_image = await asyncio.to_thread(move_image)

            move_video = partial(move_file_based_on_filetype, filename, 'video')
            moved_video = await asyncio.to_thread(move_video)

            return moved_image
        elif filetype == 'image':
            move_file = partial(move_file_based_on_filetype, filename, filetype)
            moved_file = await asyncio.to_thread(move_file)

            return moved_file
        else:
            raise ValueError(f"Unsupported file type: {filetype}")

    except Exception as e:
        print(f"Error processing {url}: {str(e)}")
        return None


async def retrieve_media_list(media_list, destination):
    os.makedirs(destination, exist_ok=True)
    async with aiohttp.ClientSession() as session:
        tasks = [download_and_process_file(session, url, destination) for url in media_list]
        result = await asyncio.gather(*tasks)

    return result


if __name__ == '__main__':
    media_list = [
        "https://storage.googleapis.com/lumen5-prod-video/preview-Yh9L-contentvideoMPaEbz-videoblocks-medium-slow-motion-footage-of-multi-ethnic-office-workers-working-late-in-dark-loft-offic.mp4",
        "https://storage.googleapis.com/lumen5-prod-video/videocontentBLOmnPQpWj8vjeh8vvideoblocks-handsome-african-american-man-working-on-laptop-look-at-camera-smile-work-with-document-bdsjW.mp4",
        "https://storage.googleapis.com/lumen5-prod-video/preview-GDd0-videocontentBjS0UYb2isx7oz13videoblocks-handsome-artist-thinking-about-his-drawing-and-sketching-on-the-large-easel-insi.mp4",
    ]
    destination = "downloads"

    asyncio.run(retrieve_media_list(media_list, destination))