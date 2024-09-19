from copy import deepcopy
from pathlib import Path

from PIL import Image, ImageDraw

from ..utils.draw_interface import draw_on_image
from ..utils.shape import Line, Point
from ..utils.tk_image import ImageTkApp


class ImageRegionFillApp(ImageTkApp):
    def __init__(self, root, input_path: Path, output_path: Path):
        super().__init__(root, input_path, output_path)

        self.line_id = None
        self.line = None
        self.radius = 3
        self.line_drawing = False
        self.line_copy = self.line

    def mouse_down(self, p: Point):
        super().mouse_down(p)
        if self.line is None:
            self.line_id = self.canvas.create_line(*p.tuple, *p.tuple, fill="red")
            self.line = Line(p, p)
            self.line_drawing = True
        self.line_copy = deepcopy(self.line)

    def update_line(self):
        assert self.line and self.line_id
        self.canvas.coords(self.line_id, *self.line.tuple)

    def mouse_drag(self, start_p: Point, now_p: Point):
        super().mouse_drag(start_p, now_p)
        if self.line_drawing:
            assert self.line
            self.line.end = now_p
            self.update_line()
        else:
            assert self.line and self.line_copy
            # 移动 line
            affine = now_p - start_p
            self.line.start = self.line_copy.start + affine
            self.line.end = self.line_copy.end + affine
            self.copy_circle(self.line.end, self.line.start, self.radius)
            self.line_id = self.canvas.create_line(*self.line.tuple, fill="red")

    def mouse_up(self, p: Point):
        super().mouse_up(p)
        self.line_drawing = False
        self.line_copy = deepcopy(self.line)

    def copy_circle(self, src: Point, dst: Point, radius):
        mask_rect = (0, 0, radius * 2, radius * 2)
        mask = Image.new("L", (radius * 2, radius * 2))
        draw = ImageDraw.Draw(mask)
        draw.ellipse(mask_rect, fill=255)

        # 从源位置裁剪圆形区域
        circle = self.img.crop(
            (src.x - radius, src.y - radius, src.x + radius, src.y + radius)
        )
        circle.putalpha(mask)

        # 创建透明背景并粘贴圆形
        cut = Image.new("RGBA", self.img.size, (0, 0, 0, 0))
        cut.paste(circle, (dst.x - radius, dst.y - radius), mask=mask)

        # 合成并更新图像
        self.img = Image.alpha_composite(self.img.convert("RGBA"), cut)
        self.update_canvas()


def remove_mole_move_region(image_path: Path, output_path: Path):
    draw_on_image(ImageRegionFillApp, image_path, output_path)
