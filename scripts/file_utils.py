import os
def get_output_filename(filename, suffix):
    name, extension = os.path.splitext(filename)
    return f'{name}{suffix}{extension}'