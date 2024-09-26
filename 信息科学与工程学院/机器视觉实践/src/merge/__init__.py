import logging as log
import tempfile
from pathlib import Path

import cv2
import matplotlib.pyplot as plt
import numpy as np

from ..utils import OpenOption, use_image
from ..utils.processing import crop_image


def merge_main(input_path: Path, output_path: Path):
    # 先切割再拼接
    tempdir = output_path.parent
    mid_l = (tempdir / "mid_l").with_suffix(input_path.suffix)
    mid_r = (tempdir / "mid_r").with_suffix(input_path.suffix)
    use_image(
        lambda x, y: crop_image(x, y, 0, 0.3),
        input_image=input_path,
        output_image=mid_l,
        tmpdir=tempdir,
        open_option=OpenOption.OUTPUT,
    )
    use_image(
        lambda x, y: crop_image(x, y, 0.3, 0),
        input_image=input_path,
        output_image=mid_r,
        tmpdir=tempdir,
        open_option=OpenOption.OUTPUT,
    )
    use_image(
        lambda x, y: merge(mid_l, mid_r, y),
        output_image=output_path,
        tmpdir=tempdir,
        open_option=OpenOption.OUTPUT,
    )


def merge(input_path_1: Path, input_path_2: Path, output_path: Path):
    # 读取待拼接的图像
    img1 = cv2.imread(str(input_path_1))
    img2 = cv2.imread(str(input_path_2))

    # 检查图像是否成功读取
    if img1 is None or img2 is None:
        raise ValueError("无法读取输入图像")

    # 转换为灰度图像
    gray1 = cv2.cvtColor(img1, cv2.COLOR_BGR2GRAY)
    gray2 = cv2.cvtColor(img2, cv2.COLOR_BGR2GRAY)

    # 创建SIFT特征检测器
    sift = cv2.SIFT_create()

    # 检测关键点和计算描述符
    keypoints1, descriptors1 = sift.detectAndCompute(gray1, None)
    keypoints2, descriptors2 = sift.detectAndCompute(gray2, None)

    # 使用BFMatcher进行特征匹配
    bf = cv2.BFMatcher(cv2.NORM_L2, crossCheck=True)
    matches = bf.match(descriptors1, descriptors2)
    matches = sorted(matches, key=lambda x: x.distance)

    # 获取匹配点的坐标
    points1 = np.float32([keypoints1[m.queryIdx].pt for m in matches])
    points2 = np.float32([keypoints2[m.trainIdx].pt for m in matches])

    # 将两张图片横向并排放置
    h1, w1 = img1.shape[:2]
    h2, w2 = img2.shape[:2]
    vis = np.zeros((max(h1, h2), w1 + w2, 3), np.uint8)
    vis[:h1, :w1] = cv2.cvtColor(img1, cv2.COLOR_BGR2RGB)
    vis[:h2, w1 : w1 + w2] = cv2.cvtColor(img2, cv2.COLOR_BGR2RGB)

    # 使用线条连接所有相同的匹配点
    for match in matches:
        img1_idx = match.queryIdx
        img2_idx = match.trainIdx
        (x1, y1) = keypoints1[img1_idx].pt
        (x2, y2) = keypoints2[img2_idx].pt
        if abs(y1 - y2) < 1 and x2 < w2 + w2:
            cv2.line(vis, (int(x1), int(y1)), (int(x2) + w1, int(y2)), (0, 255, 0), 1)

    # 显示结果
    plt.figure(figsize=(15, 10))
    plt.imshow(vis)
    plt.axis("off")
    plt.show()

    # 计算单应性矩阵。单应性矩阵是一个 3x3 的矩阵，用于描述两个平面之间的映射关系。
    H, _ = cv2.findHomography(points1, points2, cv2.RANSAC, 5.0)

    # 计算拼接图像的大小
    height1, width1 = img1.shape[:2]
    height2, width2 = img2.shape[:2]
    corners1 = np.float32(
        [[0, 0], [0, height1], [width1, height1], [width1, 0]]
    ).reshape(-1, 1, 2)
    corners2 = np.float32(
        [[0, 0], [0, height2], [width2, height2], [width2, 0]]
    ).reshape(-1, 1, 2)
    corners2_transformed = cv2.perspectiveTransform(corners2, H)
    corners = np.concatenate((corners1, corners2_transformed), axis=0)

    [x_min, y_min] = np.int32(corners.min(axis=0).ravel() - 0.5)
    [x_max, y_max] = np.int32(corners.max(axis=0).ravel() + 0.5)

    # 计算平移矩阵
    translation_matrix = np.array([[1, 0, -x_min], [0, 1, -y_min], [0, 0, 1]])

    # 应用平移矩阵
    panorama = cv2.warpPerspective(
        img1, translation_matrix.dot(H), (x_max - x_min, y_max - y_min)
    )

    # 将第二张图像放入拼接图像中
    panorama[-y_min : height2 - y_min, -x_min : width2 - x_min] = img2

    # 保存拼接结果
    cv2.imwrite(str(output_path), panorama)
