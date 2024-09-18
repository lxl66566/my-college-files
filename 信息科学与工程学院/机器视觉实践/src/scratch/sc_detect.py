import cv2
import numpy as np


def remove_scratches(image_path, output_path):
    # 读取图像
    img = cv2.imread(image_path)

    # 将图像转为灰度图像
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # 创建一个二值化图像（白色划痕会变成白色，其他变成黑色）
    _, binary = cv2.threshold(gray, 240, 255, cv2.THRESH_BINARY)

    # 使用形态学操作（例如开运算）去除小的噪点
    kernel = np.ones((5, 5), np.uint8)
    cleaned = cv2.morphologyEx(binary, cv2.MORPH_OPEN, kernel)

    # 进行修复
    result = cv2.inpaint(img, cleaned, inpaintRadius=7, flags=cv2.INPAINT_TELEA)

    # 保存结果
    cv2.imwrite(output_path, result)
