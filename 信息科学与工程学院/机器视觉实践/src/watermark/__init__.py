from pathlib import Path

import cv2
import numpy as np

from ..utils import OpenOption, use_image


def add_watermark(input_path: Path, output_path: Path, content: str):
    # 读取图像并转换为浮点型
    image = cv2.imread(str(input_path))
    if image is None:
        raise FileNotFoundError(f"Image not found at {input_path}")

    # 转换为灰度图
    img = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY).astype(np.float32)

    # 将图像转换到频域
    dft = cv2.dft(img, flags=cv2.DFT_COMPLEX_OUTPUT)
    dft_shift = np.fft.fftshift(dft)

    # 创建水印
    watermark = np.zeros(img.shape, np.uint8)
    font = cv2.FONT_HERSHEY_SIMPLEX
    fontScale = 30
    thickness = 5
    text_size = cv2.getTextSize(content, font, fontScale, thickness)[0]
    text_x = (watermark.shape[1] + text_size[0]) // 2
    text_y = (watermark.shape[0] + text_size[1]) // 2
    cv2.putText(
        img=watermark,
        text=content,
        org=(text_x, text_y),
        fontFace=font,
        fontScale=fontScale,
        color=(255, 255, 255),
        thickness=thickness,
    )

    # 将水印添加到频域
    watermark = watermark.astype(np.float32) / 255.0  # 归一化水印
    strength = 50  # 水印强度
    dft_shift[:, :, 0] += watermark * strength
    dft_shift[:, :, 1] += watermark * strength

    # 反变换回图像域
    idft_shift = np.fft.ifftshift(dft_shift)
    img_back = cv2.idft(idft_shift)
    img_back = cv2.magnitude(img_back[:, :, 0], img_back[:, :, 1])

    # 归一化并转换为8位图像
    img_back = cv2.normalize(img_back, None, 0, 255, cv2.NORM_MINMAX).astype(np.uint8)

    # 保存结果
    cv2.imwrite(str(output_path), img_back)


# def get_watermark(input_path: Path, output_path: Path):
#     # 读取图像并转换为浮点型
#     image = cv2.imread(str(input_path))
#     if image is None:
#         raise FileNotFoundError(f"Image not found at {input_path}")

#     # 转换为灰度图
#     img = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY).astype(np.float32)

#     # 将图像转换到频域
#     dft = cv2.dft(img, flags=cv2.DFT_COMPLEX_OUTPUT)
#     dft_shift = np.fft.fftshift(dft)

#     # 提取水印
#     magnitude = cv2.magnitude(dft_shift[:, :, 0], dft_shift[:, :, 1])
#     magnitude = np.log1p(magnitude)  # 对数变换增强水印
#     magnitude = cv2.normalize(magnitude, None, 0, 255, cv2.NORM_MINMAX).astype(np.uint8)

#     # 保存水印图像
#     cv2.imwrite(str(output_path), magnitude)


def get_watermark(input_path: Path, output_path: Path):
    # 读取图像并转换为浮点型
    image = cv2.imread(str(input_path))
    if image is None:
        raise FileNotFoundError(f"Image not found at {input_path}")

    # 转换为灰度图
    img = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY).astype(np.float32)

    # 将图像转换到频域
    dft = cv2.dft(img, flags=cv2.DFT_COMPLEX_OUTPUT)
    dft_shift = np.fft.fftshift(dft)

    # 提取水印
    magnitude = cv2.magnitude(dft_shift[:, :, 0], dft_shift[:, :, 1])
    magnitude = np.log1p(magnitude)  # 对数变换增强水印
    magnitude = cv2.normalize(magnitude, None, 0, 255, cv2.NORM_MINMAX).astype(np.uint8)

    # 将频域水印转换回图像域
    watermark_dft = np.zeros_like(dft_shift)
    watermark_dft[:, :, 0] = magnitude * np.cos(
        np.angle(dft_shift[:, :, 0] + 1j * dft_shift[:, :, 1])
    )
    watermark_dft[:, :, 1] = magnitude * np.sin(
        np.angle(dft_shift[:, :, 0] + 1j * dft_shift[:, :, 1])
    )

    watermark_dft_shift = np.fft.ifftshift(watermark_dft)
    watermark_img = cv2.idft(watermark_dft_shift)
    watermark_img = cv2.magnitude(watermark_img[:, :, 0], watermark_img[:, :, 1])
    watermark_img = cv2.normalize(watermark_img, None, 0, 255, cv2.NORM_MINMAX).astype(
        np.uint8
    )

    # 保存转换后的图像
    cv2.imwrite(str(output_path), watermark_img)


def watermark_main(input_path: Path, output_path: Path):
    s = input("请输入水印内容：")
    temp_dir = output_path.parent
    middle_path = (temp_dir / "middle").with_suffix(input_path.suffix)
    add_watermark(input_path, middle_path, s)
    use_image(
        get_watermark,
        input_image=middle_path,
        output_image=output_path,
        tmpdir=temp_dir,
        open_option=OpenOption.INPUT,
    )
