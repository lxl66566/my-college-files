import logging as log
import random
import unittest
from collections import Counter
from math import ceil
from pathlib import Path

import cv2
import numpy as np
from pretty_assert import assert_eq


def jump_positions(shape):
    """
    jump store positions

    :param shape: 图像的形状
    :return: 跳跃的位置
    """
    random.seed(213)
    for _ in range(31):
        yield (random.randrange(0, shape[0] - 1), random.randrange(0, shape[1] - 9))


def calculate_jump(content_len: int, image: np.ndarray) -> int:
    """
    计算嵌入内容的跳跃长度，跳跃的目的是为了分散数据，增加抗干扰

    :param content_len: 内容的长度
    :param image_len: 图像的长度
    :return: 跳跃长度
    """
    jump = ceil((content_len * 8) / image.shape[0])
    jump = min(image.shape[1] // jump, image.shape[1], 255)
    jump = max(1, jump)
    log.info(f"jump: {jump}")
    return jump


def write_jump_position(image: np.ndarray, position: tuple, jump: int):
    """
    将跳跃长度写入图像

    :param image: 图像
    :param position: 嵌入位置
    :param jump: 跳跃长度
    """
    for j in range(8):
        image[position[0]][position[1] + j] = jump & 1
        jump >>= 1


def read_jump_position(image: np.ndarray, position: tuple) -> int:
    """
    根据嵌入位置获取 jump 值

    :param image: 图像
    :param position: 嵌入位置
    :return: 跳跃长度
    """
    x: int = 0
    for i in range(7, -1, -1):
        x |= int(image[position[0]][position[1] + i]) & 1
        x <<= 1
    return x >> 1


def bits(byte_data: bytes):
    """
    bytes 每次只取一位

    :param byte_data: 字节数据
    :return: 一位 0 or 1
    """
    # 遍历每一个字节
    for byte in byte_data:
        # 对于每个字节，从最高位到最低位遍历每一位
        for bit_position in range(7, -1, -1):  # 从7到0
            # 使用位移和掩码提取出当前位
            yield (byte >> bit_position) & 1


def add_watermark(input_path: Path, output_path: Path, content: str):
    """
    使用LSB隐写术将内容嵌入到图像中

    :param input_path: 输入图像的路径
    :param output_path: 输出图像的路径
    :param content: 要嵌入的内容
    """

    # 读取图像并转换为浮点型
    image = cv2.imread(str(input_path))

    b, g, r = cv2.split(image)
    b = b.astype(np.uint8)

    log.info(f"got image shape : {b.shape}")

    # 将内容转换为二进制字符串
    binary_content = bytearray(content.encode("unicode_escape"))
    binary_content.extend(bytearray([1] * 64))  # 用长串的 1 作为结尾
    jump = calculate_jump(len(binary_content) * 8, b)

    assert jump > 0 and jump <= b.shape[1], "jump 计算错误"
    # 分散储存 jump
    for i in jump_positions(g.shape):
        write_jump_position(g, i, jump)

    i, j = 0, 0
    bitss = bits(binary_content)
    # 嵌入内容到图像的最低有效位
    try:
        while True:
            bit = next(bitss)
            assert bit is not None
            b[i, j] = (b[i, j] & 254) | bit
            j += jump
            if j >= b.shape[1]:
                i += 1
                j = 0
            if i >= b.shape[0]:
                raise Exception("嵌入内容过长")
    except StopIteration:
        pass

    # 将图像转换回RGB模式
    image = cv2.merge([b, g, r])
    cv2.imwrite(str(output_path), image)


def get_watermark(input_path: Path) -> str:
    """
    从图像中提取使用LSB隐写术嵌入的内容

    :param input_path: 输入图像的路径
    :return: 提取的内容
    """
    log.info(f"get watermark from {input_path}")
    # 打开图像并转换为RGB模式
    image = cv2.imread(str(input_path))

    b, g, r = cv2.split(image)
    b = b.astype(np.uint8)

    log.info(f"got image shape : {b.shape}")

    jumps = list(map(lambda x: read_jump_position(g, x), jump_positions(g.shape)))
    jump_tuple = Counter(jumps).most_common()[0]
    if jump_tuple[1] < 10:
        log.warning(
            f"相同的 jump 不够多，可能有干扰，jump 为 {jump_tuple[0]}， 个数为 {jump_tuple[1]}"
        )
    else:
        log.info(f"most common jump: {jump_tuple}")
    jump = jump_tuple[0]
    assert jump > 0 and jump <= b.shape[1], "jump 计算错误"

    i, j = 0, 0
    # 16 个 1 就结束，不要求 32 个是为了容错
    end = bytearray([1] * 8)
    # 从图像的最低有效位提取内容
    content = bytearray()
    try:
        while True:
            byte = 0
            for _ in range(8):
                byte = (byte << 1) | (b[i, j] & 1)
                j += jump
                if j >= b.shape[1]:
                    i += 1
                    j = 0
                if i >= b.shape[0]:
                    raise StopIteration
            content.append(byte)
            if content.endswith(end):
                break
    except StopIteration:
        pass

    return content.decode("unicode_escape")


class Test(unittest.TestCase):
    def test_bits(self):
        assert_eq(list(bits(b"he")), [0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1])

    def test_write_jump_and_read(self):
        img = np.zeros((1920, 1080), dtype=np.uint8)
        jump = 123
        write_jump_position(img, (311, 833), jump)
        assert_eq(read_jump_position(img, (311, 833)), jump)


if __name__ == "__main__":
    unittest.main()
