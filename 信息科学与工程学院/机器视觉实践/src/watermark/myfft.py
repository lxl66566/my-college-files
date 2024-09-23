import logging as log
from pathlib import Path

import cv2
import matplotlib.pyplot as plt
import numpy as np
from PIL import Image, ImageDraw, ImageFont


def add_watermark(input_path: Path, output_path: Path, content: str):
    # 读取图像并转换为浮点型
    image = cv2.imread(str(input_path))

    b, g, r = cv2.split(image)
    b = b.astype(np.float32)

    # 将图像转换到频域
    dft = cv2.dft(b, flags=cv2.DFT_COMPLEX_OUTPUT)
    dft_shift = np.fft.fftshift(dft)

    # 创建水印
    watermark = Image.new("L", (b.shape[1], b.shape[0]), color=0)
    draw = ImageDraw.Draw(watermark)
    font = ImageFont.truetype(Path(__file__).parent / "Arial.ttf", 50)
    # 计算文本的大小
    bbox = draw.textbbox((0, 0), content, font=font)
    text_width, text_height = bbox[2] - bbox[0], bbox[3] - bbox[1]
    text_x = max(0, (watermark.width - text_width) // 2)
    text_y = max(0, (watermark.height - text_height - 100) // 2)
    draw.text((text_x, text_y), content, fill=255, font=font)

    # 将PIL图像转换为NumPy数组
    watermark_np = np.array(watermark, dtype=np.float32)
    watermark_np = watermark_np.astype(np.float32) / 255.0

    # 显示水印
    plt.figure()
    plt.imshow(watermark_np, cmap="gray")
    plt.title("Magnitude Spectrum with Watermark")
    plt.show()

    # 挖掉文字区域
    for i in range(watermark_np.shape[0]):
        for j in range(watermark_np.shape[1]):
            if watermark_np[i][j] > 0.4:
                dft_shift[i][j][0] = 0
                dft_shift[i][j][1] = 0

    # 显示添加了水印的频域图像
    magnitude_spectrum = 20 * np.log(
        cv2.magnitude(dft_shift[:, :, 0], dft_shift[:, :, 1])
    )
    plt.figure()
    plt.imshow(magnitude_spectrum, cmap="gray")
    plt.title("Magnitude Spectrum with Watermark")
    plt.show()

    # 反变换回图像域
    idft_shift = np.fft.ifftshift(dft_shift)
    img_back = cv2.idft(idft_shift)
    img_back = cv2.magnitude(img_back[:, :, 0], img_back[:, :, 1])

    # 归一化并转换为8位图像
    img_back = cv2.normalize(img_back, None, 0, 255, cv2.NORM_MINMAX).astype(np.uint8)

    processed_image = cv2.merge((img_back, g, r))

    # 保存结果
    cv2.imwrite(str(output_path), processed_image)


def get_watermark(input_path: Path, output_path: Path):
    log.info(f"get watermark from {input_path}")

    # 读取图像并转换为浮点型
    image = cv2.imread(str(input_path))

    # 转换为灰度图
    # b = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY).astype(np.float32)
    b, g, r = cv2.split(image)
    b = b.astype(np.float32)

    # 将图像转换到频域
    dft = cv2.dft(b, flags=cv2.DFT_COMPLEX_OUTPUT)
    dft_shift = np.fft.fftshift(dft)

    # 提取水印
    magnitude = cv2.magnitude(dft_shift[:, :, 0], dft_shift[:, :, 1])
    magnitude = np.log1p(magnitude)  # 对数变换增强水印
    magnitude = cv2.normalize(magnitude, None, 0, 255, cv2.NORM_MINMAX).astype(np.uint8)

    # 保存转换后的图像
    cv2.imwrite(str(output_path), magnitude)
