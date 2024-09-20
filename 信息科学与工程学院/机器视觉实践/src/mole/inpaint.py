from pathlib import Path

from ..scratch.drawmaskw import PaintApp
from ..scratch.myinpaint import ipt
from ..utils import OpenOption, use_image
from ..utils.draw_interface import draw_on_image


def remove_mole_inpaint(input_path: Path, output_path: Path):
    tmpdir = output_path.parent
    mask_path = (tmpdir / "mask").with_suffix(input_path.suffix)
    use_image(
        lambda x, _: draw_on_image(PaintApp, x, mask_path),
        input_image=input_path,
        output_image=mask_path,
        tmpdir=tmpdir,
        open_option=OpenOption.OUTPUT,
    )
    ipt(input_path, mask_path, output_path)
