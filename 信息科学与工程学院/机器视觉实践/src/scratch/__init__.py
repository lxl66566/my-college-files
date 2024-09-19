import sys
import tempfile
from pathlib import Path

from PIL import Image

from ..utils.draw_interface import draw_on_image
from .add_scratch import add_scratches
from .drawmaskw import PaintApp
from .gause import remove_scratch_gause
from .myinpaint import ipt
from .sc_detect import remove_scratches


def scratch(method: int = 0):
    """
    Scratch and restore a given image.

    :param method: 0 for SC Detect, 1 for Gause
    """
    with tempfile.TemporaryDirectory(delete=False) as tmpdir:
        tmpdir = Path(tmpdir)
        thisfile = Path(__file__)
        origin_image = thisfile.parent.parent.parent / "assets" / "fruits.jpg"
        tmpfile1 = (tmpdir / "scratch_result").with_suffix(origin_image.suffix)
        tmpfile2 = (tmpdir / "restore_result").with_suffix(origin_image.suffix)
        mask = (tmpdir / "mask").with_suffix(origin_image.suffix)
        add_scratches(origin_image, tmpfile1, 3)
        match method:
            case 0:
                remove_scratches(tmpfile1, tmpfile2)
            case 1:
                remove_scratch_gause(tmpfile1, tmpfile2)
            case 2:
                draw_on_image(PaintApp, tmpfile1, mask)
                Image.open(mask).show()
                ipt(tmpfile1, mask, tmpfile2)
        Image.open(tmpfile1).show()
        Image.open(tmpfile2).show()
