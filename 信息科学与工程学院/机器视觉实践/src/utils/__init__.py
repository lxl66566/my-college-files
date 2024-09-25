#!/usr/bin/env python3

import itertools
import logging
import os
import shutil
import tempfile
import unittest
from contextlib import suppress
from enum import Enum
from pathlib import Path
from typing import Callable

from PIL import Image
from pretty_assert import assert_eq


def to_normal_path(path: Path) -> Path:
    """
    为了防止 origin_image 的路径含有中文，在 windows 上可能会炸掉 cv2 的读取
    """
    fd, p = tempfile.mkstemp(suffix=path.suffix)
    os.close(fd)
    p = Path(p)
    with suppress(shutil.SameFileError):
        shutil.copy2(path, p)
    return p


class OpenOption(Enum):
    """
    Options for opening images.
    """

    NONE = 0
    INPUT = 1
    OUTPUT = 2
    BOTH = 3


def use_image(
    process: Callable[[Path, Path], None],
    input_image: str | Path = "fruits.jpg",
    output_image: Path | None = None,
    tmpdir: Path | None = None,
    open_option=OpenOption.BOTH,
):
    """
    Call process with a temporary image and show the result image.

    The temporary image is a copy of fruits.jpg in the assets directory.
    The output image is placed in the same directory with the same extension.
    Finally, the two images are shown using PIL's Image.show.

    :param process: A function that takes two arguments, the input image and
        the output image.
    :param origin_image: The name of the image file in the assets directory.
    :param open_option: The option for opening the input and output images.
    """

    if tmpdir is None:
        with tempfile.TemporaryDirectory(delete=False) as _tmpdir:
            tmpdir = Path(_tmpdir)
            return use_image(
                process=process,
                input_image=input_image,
                output_image=output_image,
                tmpdir=tmpdir,
                open_option=open_option,
            )

    assert tmpdir and tmpdir.is_dir()

    if isinstance(input_image, str):
        input_image = assets() / input_image
    tmp_image = to_normal_path(input_image)
    output_image = output_image or (tmpdir / "result").with_suffix(input_image.suffix)

    logging.info(f"Origin image: {input_image.absolute()}")
    logging.info(f"Output image: {output_image.absolute()}")

    process(tmp_image, output_image)

    if open_option.value & OpenOption.INPUT.value:
        Image.open(tmp_image).show()

    if open_option.value & OpenOption.OUTPUT.value:
        Image.open(output_image).show()


def grouper(iterable, n, fillvalue=None):
    "Collect data into fixed-length chunks or blocks"
    args = [iter(iterable)] * n
    return itertools.zip_longest(*args, fillvalue=fillvalue)


def assets():
    return Path(__file__).parent.parent.parent / "assets"


class Test(unittest.TestCase):
    def test_open_option(self):
        assert OpenOption.BOTH.value & OpenOption.OUTPUT.value
        assert OpenOption.BOTH.value & OpenOption.INPUT.value
        assert not OpenOption.OUTPUT.value & OpenOption.INPUT.value

    def test_grouper(self):
        assert_eq(list(grouper(range(9), 3)), [(0, 1, 2), (3, 4, 5), (6, 7, 8)])
        assert_eq(
            list(grouper("ABCDEFG", 3, "x")),
            [
                ("A", "B", "C"),
                ("D", "E", "F"),
                ("G", "x", "x"),
            ],
        )
