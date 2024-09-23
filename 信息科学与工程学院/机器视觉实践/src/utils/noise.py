import random
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter


def add_salt_and_pepper_noise(
    input_path: Path, output_path: Path, noise_level: float = 0.05
):
    """
    为指定图片添加椒盐噪声，并将处理后的图片保存到指定路径。

    :param input_path: 输入图片的路径
    :param output_path: 输出图片的路径
    :param noise_level: 噪声水平，范围在0到1之间，表示噪声的密度
    """
    # 打开图像
    image = Image.open(input_path)
    pixels = image.load()
    assert pixels

    # 获取图像的宽度和高度
    width, height = image.size

    # 遍历图像的每个像素
    for x in range(width):
        for y in range(height):
            # 随机生成一个概率值
            if random.random() < noise_level:
                # 随机选择添加椒噪声（黑色）或盐噪声（白色）
                if random.random() < 0.5:
                    pixels[x, y] = (0, 0, 0)  # 椒噪声（黑色）
                else:
                    pixels[x, y] = (255, 255, 255)  # 盐噪声（白色）

    # 保存处理后的图像
    image.save(output_path)


def add_gaussian_blur(input_path: Path, output_path: Path, radius: int = 2):
    """
    为指定图片添加高斯模糊，并将处理后的图片保存到指定路径。

    :param input_path: 输入图片的路径
    :param output_path: 输出图片的路径
    :param radius: 高斯模糊的半径，值越大，模糊效果越明显
    """
    # 打开图像
    image = Image.open(input_path)

    # 应用高斯模糊滤镜
    blurred_image = image.filter(ImageFilter.GaussianBlur(radius=radius))

    # 保存处理后的图像
    blurred_image.save(output_path)


def apply_high_pass_filter(input_path: Path, output_path: Path, radius: int = 2):
    """
    对指定图片应用高通滤波器，并将处理后的图片保存到指定路径。

    :param input_path: 输入图片的路径
    :param output_path: 输出图片的路径
    :param radius: 低通滤波器的半径，值越大，保留的低频成分越多
    """
    # 打开图像并转换为灰度图像
    image = Image.open(input_path).convert("L")
    image_array = np.array(image)

    # 创建一个与图像大小相同的低通滤波器
    low_pass_filter = np.ones((2 * radius + 1, 2 * radius + 1)) * (
        1 / (2 * radius + 1) ** 2
    )

    # 对图像进行填充，以避免边界问题
    padded_image = np.pad(
        image_array, ((radius, radius), (radius, radius)), mode="edge"
    )

    # 应用低通滤波器
    low_pass_image = np.zeros_like(image_array)
    for i in range(image_array.shape[0]):
        for j in range(image_array.shape[1]):
            low_pass_image[i, j] = np.sum(
                padded_image[i : i + 2 * radius + 1, j : j + 2 * radius + 1]
                * low_pass_filter
            )

    # 计算高通滤波器的结果
    high_pass_image = image_array - low_pass_image

    # 将结果转换回图像
    high_pass_image = np.clip(high_pass_image, 0, 255).astype(np.uint8)
    high_pass_image = Image.fromarray(high_pass_image)

    # 保存处理后的图像
    high_pass_image.save(output_path)
