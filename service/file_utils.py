import os
import filetype


def change_filename_extension(filename, new_extension):
    filename_without_ext, _ = os.path.splitext(filename)
    return f"{filename_without_ext}{new_extension}"


def check_file_type(file_path):
    kind = filetype.guess(file_path)
    if kind is None:
        print(f"Cannot determine file type for {file_path}")
        return None

    if kind.mime.startswith('image'):
        return 'image'
    elif kind.mime.startswith('video'):
        return 'video'
    else:
        return 'other'


if __name__ == '__main__':
    # Example usage
    file_path = 'downloads/preview-GDd0-videocontentBjS0UYb2isx7oz13videoblocks-handsome-artist-thinking-about-his-drawing-and-sketching-on-the-large-easel-insi.mp4'
    file_type = check_file_type(file_path)
    print(file_path, file_type)