#!/usr/bin/env python3

import logging
import tempfile
from pathlib import Path
from typing import Callable

from PIL import Image


def use_image(process: Callable[[Path, Path], None], origin_image="fruits.jpg"):
    """
    Call process with a temporary image and show the result image.

    The temporary image is a copy of fruits.jpg in the assets directory.
    The output image is placed in the same directory with the same extension.
    Finally, the two images are shown using PIL's Image.show.

    :param process: A function that takes two arguments, the input image and
        the output image.
    """

    with tempfile.TemporaryDirectory(delete=False) as tmpdir:
        tmpdir = Path(tmpdir)
        thisfile = Path(__file__)

        origin_image = thisfile.parent.parent.parent / "assets" / origin_image
        output_image = (tmpdir / "result").with_suffix(origin_image.suffix)

        logging.info(f"Origin image: {origin_image.absolute()}")
        logging.info(f"Output image: {output_image.absolute()}")

        process(origin_image, output_image)

        Image.open(origin_image).show()
        Image.open(output_image).show()
