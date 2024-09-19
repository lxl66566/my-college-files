from pathlib import Path
from tempfile import TemporaryDirectory

import cv2
from PIL import Image

from ..scratch.drawmaskw import PaintApp
from ..utils.draw_interface import draw_on_image


def remove_mole_inpaint_inner(image_path: Path, mole_mask: Path, output_path: Path):
    # 读取图像
    img = cv2.imread(str(image_path))
    mask = cv2.imread(str(mole_mask), cv2.IMREAD_GRAYSCALE)

    # 创建一个修复后的图像
    result = img.copy()

    # 使用 inpaint 方法去除痣
    result = cv2.inpaint(result, mask, inpaintRadius=3, flags=cv2.INPAINT_TELEA)
    cv2.imwrite(str(output_path), result)


def remove_mole_inpaint(image_path: Path, output_path: Path):
    with TemporaryDirectory() as tmpdir:
        tmpdir = Path(tmpdir)
        mask_path = (tmpdir / "mask").with_suffix(image_path.suffix)
        draw_on_image(PaintApp, image_path, mask_path)
        remove_mole_inpaint_inner(image_path, mask_path, output_path)

        Image.open(mask_path).show()
