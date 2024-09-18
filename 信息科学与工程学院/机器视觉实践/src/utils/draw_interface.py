from pathlib import Path
from tkinter import Tk
from typing import Any


def draw_on_image(app: Any, input_path: Path, output_path: Path):
    """
    Start a Tkinter event loop for the given application.

    `app` should be a callable that takes a Tk root window, an input Path, and an output Path.
    The application should draw something on the output image based on the input image.

    The function will create a Tkinter root window and set the title to "Paint on Image".
    If `input_path` and `output_path` are both truthy, the application will be called with the
    root window, the input path, and the output path. The application should then draw something
    on the output image based on the input image.

    The function will also set the WM_DELETE_WINDOW protocol to a callback that will first call
    the application's `save_image` method and then destroy the root window.

    Finally, the function will start the Tkinter event loop with `mainloop`.
    """
    root = Tk()
    root.title("Paint on Image")
    if input_path and output_path:
        app = app(root, input_path, output_path)
        root.protocol("WM_DELETE_WINDOW", lambda: [app.save_image(), root.destroy()])
        root.mainloop()
