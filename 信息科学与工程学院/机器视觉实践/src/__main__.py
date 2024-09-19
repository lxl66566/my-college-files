from PyConsoleMenu2 import BaseMenu

from .mosaic import draw_mosaic
from .scratch import scratch

options = ["图像划痕处理", "绘制马赛克"]


def main():
    menu_entry_index = BaseMenu("选择实验").add_options(options).run()
    match menu_entry_index:
        case 0:
            menu_entry_index = (
                BaseMenu("选择方法")
                .add_options(["自动检测", "高斯模糊", "蒙版绘制"])
                .run()
            )
            scratch(menu_entry_index)
        case 1:
            menu_entry_index = (
                BaseMenu("选择方法").add_options(["任意绘制", "矩形区域"]).run()
            )
            draw_mosaic(menu_entry_index)


if __name__ == "__main__":
    main()
