import shutil
from pathlib import Path
from tempfile import TemporaryDirectory

from PIL import Image

from ..scratch.drawmaskw import PaintApp
from ..scratch.myinpaint import ipt
from ..utils.draw_interface import draw_on_image


def remove_mole_inpaint(input_path: Path, output_path: Path):
    with TemporaryDirectory() as tmpdir:
        tmpdir = Path(tmpdir)
        origin_path = (tmpdir / "origin").with_suffix(input_path.suffix)
        mask_path = (tmpdir / "mask").with_suffix(input_path.suffix)
        shutil.copy2(input_path, origin_path)
        draw_on_image(PaintApp, origin_path, mask_path)
        ipt(origin_path, mask_path, output_path)

        Image.open(mask_path).show()
