import logging as log
import platform
import tkinter as tk
from pathlib import Path
from tkinter import Canvas, Event

from PIL import Image, ImageDraw, ImageTk

from ..utils import use_image
from ..utils.draw_interface import draw_on_image


class MosaicApp:
    def __init__(self, root, input_path: Path, output_path: Path):
        self.root = root
        self.root.title("Mosaic Drawer")
        self.input_path = input_path
        self.output_path = output_path
        self.img = Image.open(input_path).convert("RGB")
        self.tk_img = ImageTk.PhotoImage(self.img)
        self.draw = ImageDraw.Draw(self.img)

        self.canvas = Canvas(root, width=self.img.width, height=self.img.height)
        self.canvas.create_image(0, 0, anchor=tk.NW, image=self.tk_img)
        self.canvas.pack()
        self.canvas.bind_all("<Button-1>", self.mouse_down)
        self.canvas.bind_all("<B1-Motion>", self.draw_mosaic)
        self.canvas.bind_all("<ButtonRelease-1>", self.mouse_up)

        # https://stackoverflow.com/questions/17355902/tkinter-binding-mousewheel-to-scrollbar
        if platform.system() == "Windows":
            self.canvas.bind_all("<MouseWheel>", self.change_mosaic_size_windows)
        elif platform.system() == "Linux":
            # X11
            self.canvas.bind_all("<Button-4>", lambda _: self.change_mosaic_size(True))
            self.canvas.bind_all("<Button-5>", lambda _: self.change_mosaic_size(False))

        self.mosaic_size = 10  # 马赛克块大小

    def save_image(self):
        self.img and self.img.save(self.output_path)  # type: ignore

    def draw_mosaic(self, event: Event):
        x, y = (
            event.x // self.mosaic_size * self.mosaic_size,
            event.y // self.mosaic_size * self.mosaic_size,
        )
        # 中心色块采样
        color = self.img.getpixel(
            (x + self.mosaic_size // 2, y + self.mosaic_size // 2)
        )
        self.draw.rectangle(
            [x, y, x + self.mosaic_size, y + self.mosaic_size], fill=color
        )
        self.update_canvas()

    def update_canvas(self):
        # 更新显示的图像
        self.tk_img = ImageTk.PhotoImage(self.img)
        self.canvas.create_image(0, 0, anchor=tk.NW, image=self.tk_img)

    def change_mosaic_size_windows(self, event: Event):
        # 根据滚轮方向更改马赛克块大小
        self.change_mosaic_size(event.delta > 0)

    def change_mosaic_size(self, up_or_down: bool):
        if up_or_down:
            self.mosaic_size = min(self.mosaic_size + 1, 100)  # 最大马赛克块大小限制
        else:
            self.mosaic_size = max(self.mosaic_size - 1, 4)  # 最小马赛克块大小限制
        log.info(f"Mosaic size: {self.mosaic_size}")

    def mouse_up(self, event: Event):
        log.info(f"Mouse up: {event.x}, {event.y}")

    def mouse_down(self, event: Event):
        log.info(f"Mouse down: {event.x}, {event.y}")


class MosaicAppRect(MosaicApp):
    def __init__(self, root, input_path: Path, output_path: Path):
        super().__init__(root, input_path, output_path)
        self.start_x = None
        self.start_y = None

    def draw_mosaic(self, event):
        pass

    # 在鼠标松开时才计算
    def mouse_up(self, event: Event):
        if self.start_x is None or self.start_y is None:
            log.error("Mouse up without previous mouse down")
            return
        super().mouse_up(event)

        # 计算矩形区域的起始和结束坐标
        end_x = event.x // self.mosaic_size * self.mosaic_size
        end_y = event.y // self.mosaic_size * self.mosaic_size

        self.start_x, end_x = sorted((self.start_x, end_x))
        self.start_y, end_y = sorted((self.start_y, end_y))

        # 绘制马赛克矩形区域内的所有小块
        for x in range(
            self.start_x,
            end_x,
            self.mosaic_size,
        ):
            for y in range(
                self.start_y,
                end_y,
                self.mosaic_size,
            ):
                if (
                    x + self.mosaic_size < self.img.width
                    and y + self.mosaic_size < self.img.height
                ):
                    color = self.img.getpixel(
                        (x + self.mosaic_size // 2, y + self.mosaic_size // 2)
                    )
                    self.draw.rectangle(
                        [x, y, x + self.mosaic_size, y + self.mosaic_size], fill=color
                    )

        self.update_canvas()

        self.start_x = None
        self.start_y = None

    def mouse_down(self, event: Event):
        super().mouse_down(event)
        self.start_x, self.start_y = event.x, event.y


def draw_mosaic(mode: int):
    """
    Draw a mosaic image with the given mode.

    Mode 0: draws a mosaic with pen brush.
    Mode 1: draws a mosaic with rectangles.

    The drawing is done by calling the `draw_on_image` function with the current
    image and the given mode.

    :param mode: The mode of drawing mosaic. 0 for squares, 1 for rectangles.
    :type mode: int
    """
    match mode:
        case 0:
            use_image(lambda x, y: draw_on_image(MosaicApp, x, y))
        case 1:
            use_image(lambda x, y: draw_on_image(MosaicAppRect, x, y))
        case _:
            raise ValueError(f"Invalid mode: {mode}")
