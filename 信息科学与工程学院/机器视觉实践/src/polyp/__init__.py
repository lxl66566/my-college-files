import logging as log
from pathlib import Path

import albumentations as album
import cv2
import matplotlib.pyplot as plt
import numpy as np
import segmentation_models_pytorch as smp
import torch

from ..utils import assets, to_normal_path

DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")


def to_tensor(x, **kwargs):
    return x.transpose(2, 0, 1).astype("float32")


def visualize(images, masks, size=128):
    num_images = len(images)
    fig, axs = plt.subplots(
        2,
        num_images,
        figsize=(8 * num_images, 16),
    )

    if num_images == 1:
        axs = [axs]

    for i in range(num_images):
        resized_image = cv2.resize(images[i], (size, size))
        resized_mask = cv2.resize(masks[i], (size, size))

        # Display original image
        axs[0][i].imshow(resized_image)
        axs[0][i].axis("off")

        # Display mask
        axs[1][i].imshow(resized_mask, cmap="gray")
        axs[1][i].axis("off")

    plt.tight_layout()
    plt.show()


def model_init():
    # 定义模型路径
    model_path = assets() / "best_model.pth"
    if not model_path.exists():
        raise FileNotFoundError(
            f"未找到模型，请下载 https://www.kaggle.com/code/balraj98/automatic-polyp-detection-in-colonoscopic-frames/output 模型放入 {model_path}"
        )

    # 加载模型
    model = torch.load(model_path, map_location=DEVICE)
    model.eval()  # 设置为评估模式
    log.info("Loaded UNet model from this run.")

    return model


def preprocessing_init():
    def get_preprocessing(preprocessing_fn=None):
        """Construct preprocessing transform
        Args:
            preprocessing_fn (callable): data normalization function
                (can be specific for each pretrained neural network)
        Return:
            transform: albumentations.Compose
        """
        _transform = []
        _transform.append(album.Resize(height=256, width=256))  # 根据模型需要的尺寸调整
        if preprocessing_fn:
            _transform.append(album.Lambda(image=preprocessing_fn))
        _transform.append(album.Lambda(image=to_tensor, mask=to_tensor))

        return album.Compose(_transform)

    # 加载预训练模型的预处理函数
    ENCODER = "resnet50"
    ENCODER_WEIGHTS = "imagenet"
    preprocessing_fn = smp.encoders.get_preprocessing_fn(ENCODER, ENCODER_WEIGHTS)
    preprocessing = get_preprocessing(preprocessing_fn)
    return preprocessing


def process(image_path: Path, model, preprocessing):
    # 读取图像
    image = cv2.imread(str(to_normal_path(image_path)))
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

    # 应用预处理
    transformed = preprocessing(image=image)
    transformed_image = transformed["image"]

    # 转换为模型输入
    x_tensor = torch.from_numpy(transformed_image).to(DEVICE).unsqueeze(0)

    # 预测
    with torch.no_grad():
        pred_mask = model(x_tensor)

    # 后处理预测结果
    pred_mask = pred_mask.squeeze().cpu().numpy()
    pred_mask = np.transpose(pred_mask, (1, 2, 0))
    transformed_image = np.transpose(transformed_image, (1, 2, 0))

    # 将预测结果转换为二值图像
    pred_mask = (pred_mask[:, :, 1] > 0.5).astype(np.uint8)

    return image, pred_mask


def polyp_show():
    model = model_init()
    preprocessing = preprocessing_init()
    images = (assets() / "polyp").glob("*.png")
    res = []
    for image_path in images:
        res.append(process(image_path, model, preprocessing))

    visualize(*zip(*res))
