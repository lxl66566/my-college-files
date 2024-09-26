import logging as log
from enum import Enum
from pathlib import Path

import cv2


class CropOption(Enum):
    HORIZONTAL = 0
    VERTICAL = 1


def crop_image(
    input_path: Path,
    output_path: Path,
    ratio_l: float,
    ratio_r: float,
    crop_option: CropOption = CropOption.VERTICAL,
):
    """
    切割图像。
    :param input_path: 输入图像的路径
    :param output_path: 输出图像的路径
    :param ratio_l: 左侧（上侧）要切割的宽度（比例）
    :param ratio_r: 右侧（下侧）要切割的宽度（比例）
    :param crop_option: 切割选项，默认为垂直切割，也就是在左侧和右侧切割图像的部分
    """
    assert (
        ratio_l >= 0 and ratio_r >= 0 and ratio_l + ratio_r <= 1
    ), "输入需要切割的比例不符合要求"
    image = cv2.imread(str(input_path))

    if image is None:
        print(f"Error: Unable to load image from {input_path}")
        return

    ratio_l *= image.shape[crop_option.value]
    ratio_r *= image.shape[crop_option.value]

    # 计算切割的起始和结束位置
    start = int(ratio_l)
    end = image.shape[crop_option.value] - int(ratio_r)
    assert start < end, f"Invalid crop dimensions: {start=}, {end=}"

    # 进行切割
    if crop_option == CropOption.VERTICAL:
        cropped_image = image[:, start:end]
    else:
        cropped_image = image[start:end, :]

    if output_path.exists():
        output_path.unlink()

    # 保存结果图像
    cv2.imwrite(str(output_path), cropped_image)
    log.debug(f"Image successfully cropped and saved to {output_path}")
