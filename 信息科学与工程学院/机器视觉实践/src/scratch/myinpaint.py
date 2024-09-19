from pathlib import Path

import cv2


def ipt(img: Path, mask: Path, output: Path):
    original_image = cv2.imread(str(img))
    mask_image = cv2.imread(str(mask), 0)  # 掩码是灰度图

    # 使用inpaint方法修复划痕
    restored_image = cv2.inpaint(
        src=original_image,
        inpaintMask=mask_image,
        inpaintRadius=3,
        # flags=cv2.INPAINT_NS,
        flags=cv2.INPAINT_TELEA,
    )

    # 保存修复后的图像
    cv2.imwrite(str(output), restored_image)
