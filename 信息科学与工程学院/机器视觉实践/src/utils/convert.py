from PIL import Image


def convert_jpg_to_png(input_path, output_path):
    # Open the JPEG image
    with Image.open(input_path) as img:
        # Convert and save as PNG
        img.save(output_path, "PNG")
