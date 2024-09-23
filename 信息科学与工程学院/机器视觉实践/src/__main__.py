from PyConsoleMenu2 import BaseMenu

from .brightness import serve
from .mole import remove_mole
from .mosaic import draw_mosaic
from .scratch import scratch
from .utils import use_image
from .watermark import watermark_main

options = ["图像划痕处理", "绘制马赛克", "人脸去痣", "亮度调整", "水印添加与提取"]


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
        case 2:
            menu_entry_index = (
                BaseMenu("选择方法").add_options(["inpaint", "色块移动"]).run()
            )
            remove_mole(menu_entry_index)
        case 3:
            serve()
        case 4:
            use_image(watermark_main)


if __name__ == "__main__":
    main()
