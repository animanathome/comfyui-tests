import os
import ffmpeg

def extract_frame_from_video(input_file, timestamp, output_file):
    if not os.path.exists(input_file):
        raise FileNotFoundError(f"Input file not found: {input_file}")

    try:
        (
            ffmpeg
            .input(input_file, ss=timestamp)
            .filter('select', 'gte(n,0)')
            .output(output_file, vframes=1)
            .overwrite_output()
            .run(capture_stdout=True, capture_stderr=True)
        )
        print(f"Created {output_file}")
    except ffmpeg.Error as e:
        print(f"FFmpeg error: {e.stderr.decode()}")
        raise
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        raise

    if not os.path.exists(output_file):
        raise RuntimeError(f"Failed to create output file: {output_file}")


if __name__ == '__main__':
    input_file = './downloads/preview-GDd0-videocontentBjS0UYb2isx7oz13videoblocks-handsome-artist-thinking-about-his-drawing-and-sketching-on-the-large-easel-insi.mp4'
    output_file = './output_frame.jpg'
    timestamp = '00:00:00'

    extract_frame_from_video(input_file, timestamp, output_file)