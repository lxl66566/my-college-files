# 直接在图像上绘制黑色痕迹并输出。

from pathlib import Path
from tkinter import Canvas, Tk, filedialog

from PIL import Image, ImageDraw, ImageTk


class PaintApp:
    def __init__(self, root, input_path, output_path):
        self.root = root
        self.input_path = input_path
        self.output_path = output_path
        self.img = Image.open(input_path).convert("RGB")
        self.tk_img = ImageTk.PhotoImage(self.img)
        self.canvas = Canvas(root, width=self.img.width, height=self.img.height)
        self.canvas.pack()
        self.canvas.create_image(0, 0, anchor="nw", image=self.tk_img)
        self.canvas.bind("<B1-Motion>", self.paint)
        self.last_x, self.last_y = None, None

    def paint(self, event):
        x, y = event.x, event.y
        if self.last_x is not None and self.last_y is not None:
            self.canvas.create_line(
                (self.last_x, self.last_y, x, y), fill="black", width=5
            )
            self.draw_on_image(x, y)
        self.last_x, self.last_y = x, y

    def draw_on_image(self, x, y):
        draw = ImageDraw.Draw(self.img)
        draw.circle([x, y], radius=5, fill="black")
        self.tk_img.paste(self.img)

    def save_image(self):
        self.img.save(self.output_path)


def draw_on_image(input_path: Path, output_path: Path):
    root = Tk()
    root.title("Paint on Image")
    if input_path and output_path:
        app = PaintApp(root, input_path, output_path)
        root.protocol("WM_DELETE_WINDOW", lambda: [app.save_image(), root.destroy()])
        root.mainloop()


def main():
    input_path = filedialog.askopenfilename(
        title="Select input image", filetypes=[("Image files", "*.jpg;*.png")]
    )
    output_path = filedialog.asksaveasfilename(
        title="Save as",
        defaultextension=".jpg",
        filetypes=[("Image files", "*.jpg;*.png")],
    )
    draw_on_image(Path(input_path), Path(output_path))


if __name__ == "__main__":
    main()
