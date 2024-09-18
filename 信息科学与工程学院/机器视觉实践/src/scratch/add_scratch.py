import logging as log
import random

from PIL import Image, ImageDraw


def add_scratches(image_path, output_path, num_scratches=10):
    # 打开图像
    img = Image.open(image_path)
    draw = ImageDraw.Draw(img)

    width, height = img.size

    for _ in range(num_scratches):
        # 随机生成划痕的起点和终点
        x1, y1 = random.randint(0, width), random.randint(0, height)
        x2, y2 = random.randint(0, width), random.randint(0, height)
        log.debug(f"generated line : {[(x1, y1), (x2, y2)]}")

        # 随机生成划痕的颜色和宽度
        # color = (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
        color = (255, 255, 255)  # white
        sc_width = random.randint(1, 5)

        # 绘制划痕
        draw.line([(x1, y1), (x2, y2)], fill=color, width=sc_width)

    # 保存结果
    img.save(output_path)


# 使用示例
if __name__ == "__main__":
    add_scratches("assets/fruits.jpg", "output_image.jpg")
