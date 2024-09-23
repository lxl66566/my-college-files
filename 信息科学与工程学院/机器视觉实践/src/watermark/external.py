from pathlib import Path

import cv2

# https://github.com/ShieldMnt/invisible-watermark
from imwatermark import WatermarkDecoder, WatermarkEncoder


def add_watermark(input_path: Path, output_path: Path, content: str):
    bgr = cv2.imread(str(input_path))

    encoder = WatermarkEncoder()
    encoder.set_watermark("bytes", content.encode("unicode_escape"))  # type: ignore
    bgr_encoded = encoder.encode(bgr, "dwtDctSvd")

    cv2.imwrite(str(output_path), bgr_encoded)


def get_watermark(input_path: Path) -> str:
    bgr = cv2.imread(str(input_path))

    decoder = WatermarkDecoder("bytes", 32)
    watermark = decoder.decode(bgr, "dwtDctSvd")
    if isinstance(watermark, bytes):
        watermark = watermark.decode("unicode_escape")
    assert watermark and isinstance(watermark, str)
    return watermark
