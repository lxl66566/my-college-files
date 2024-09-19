import platform
import tkinter as tk
from pathlib import Path

from PIL import Image, ImageDraw, ImageTk

from .shape import Point


class ImageTkApp:
    def __init__(self, root, input_path: Path, output_path: Path):
        assert input_path.exists()
        self._root = root
        self.input_path = input_path
        self.output_path = output_path
        self.img = Image.open(input_path).convert("RGB")
        self.tk_img = ImageTk.PhotoImage(self.img)
        self.draw = ImageDraw.Draw(self.img)

        self.canvas = tk.Canvas(root, width=self.img.width, height=self.img.height)
        self.canvas.create_image(0, 0, anchor=tk.NW, image=self.tk_img)
        self.canvas.pack()
        self.canvas.bind_all("<Button-1>", lambda e: self.mouse_down(Point(e.x, e.y)))
        self.canvas.bind_all("<B1-Motion>", lambda e: self.mouse_move(Point(e.x, e.y)))
        self.canvas.bind_all(
            "<ButtonRelease-1>", lambda e: self.mouse_up(Point(e.x, e.y))
        )
        # https://stackoverflow.com/questions/17355902/tkinter-binding-mousewheel-to-scrollbar
        # 然后 windows 右键是 Button-3
        if platform.system() == "Windows":
            self.canvas.bind_all(
                "<MouseWheel>", lambda e: self.wheel_event(e.delta > 0)
            )
            self.canvas.bind_all(
                "<Button-3>", lambda e: self.mouse_right_down(Point(e.x, e.y))
            )
        elif platform.system() == "Linux":
            # X11
            self.canvas.bind_all("<Button-4>", lambda _: self.wheel_event(True))
            self.canvas.bind_all("<Button-5>", lambda _: self.wheel_event(False))
            self.canvas.bind_all(
                "<Button-2>", lambda e: self.mouse_right_down(Point(e.x, e.y))
            )

        self.drag_start = None

    @property
    def is_pressing(self):
        return self.drag_start is not None

    def save_image(self):
        self.img.convert("RGB").save(self.output_path)

    def update_canvas(self):
        # 更新显示的图像
        self.tk_img = ImageTk.PhotoImage(self.img)
        self.canvas.create_image(0, 0, anchor=tk.NW, image=self.tk_img)

    def mouse_down(self, p: Point):
        self.drag_start = p
        pass

    def mouse_up(self, p: Point):
        self.drag_start = None
        pass

    def mouse_drag(self, start_p: Point, now_p: Point):
        pass

    def mouse_move(self, p: Point):
        if self.is_pressing:
            self.mouse_drag(self.drag_start, p)  # type: ignore
        pass

    def mouse_right_down(self, p: Point):
        pass

    def wheel_event(self, up_or_down: bool):
        pass
