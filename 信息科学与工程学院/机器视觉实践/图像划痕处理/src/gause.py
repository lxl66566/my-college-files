from pathlib import Path

import cv2
import numpy as np
from skimage.restoration import denoise_tv_chambolle


def remove_scratch_gause(input: Path, output: Path):
    # 读取图片
    image = cv2.imread(str(input))
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # 使用高斯模糊处理图片
    blurred = cv2.GaussianBlur(gray, (15, 15), 2)

    # 使用 Total Variation 去噪算法进行解模糊
    denoised = denoise_tv_chambolle(blurred, weight=0.2)

    # 将去噪后的结果转换为适合显示的格式
    denoised_image = (denoised * 255).astype(np.uint8)
    cv2.imwrite(str(output), denoised_image)
