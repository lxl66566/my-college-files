# 在图像上绘制，但是输出白色痕迹和黑色底片。

from tkinter import Canvas

from PIL import Image, ImageDraw, ImageTk


class PaintApp:
    def __init__(self, root, input_path, output_path):
        self.root = root
        self.input_path = input_path
        self.output_path = output_path

        # 打开图像并创建蒙版图像
        self.img = Image.open(input_path).convert("RGB")
        self.tk_img = ImageTk.PhotoImage(self.img)
        self.mask = Image.new("L", (self.img.width, self.img.height), 0)  # 黑色蒙版
        self.draw_mask = ImageDraw.Draw(self.mask)

        # 创建画布并显示图像
        self.canvas = Canvas(root, width=self.img.width, height=self.img.height)
        self.canvas.pack()
        self.canvas.create_image(0, 0, anchor="nw", image=self.tk_img)
        self.canvas.bind("<B1-Motion>", self.paint)
        self.last_x, self.last_y = None, None

    def paint(self, event):
        x, y = event.x, event.y
        if (
            self.last_x is not None
            and self.last_y is not None
            and distance(x, y, self.last_x, self.last_y) < 10
        ):
            # 在画布上显示涂抹
            self.canvas.create_rectangle(
                (self.last_x, self.last_y, x, y), fill="black", width=8
            )
            self.draw_on_mask(x, y)
        self.last_x, self.last_y = x, y

    def draw_on_mask(self, x, y):
        # 修改蒙版，涂抹部分为白色
        # self.draw_mask.line([(self.last_x, self.last_y), (x, y)], fill=255, width=5)
        self.draw_mask.circle([x, y], radius=8, fill=255)

    def save_image(self):
        # 保存蒙版
        self.mask.save(self.output_path)


def distance(x1, y1, x2, y2):
    return ((x1 - x2) ** 2 + (y1 - y2) ** 2) ** 0.5
