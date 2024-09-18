from simple_term_menu import TerminalMenu

from .mosaic import draw_mosaic
from .scratch import scratch

options = ["图像划痕处理", "绘制马赛克"]


def main():
    terminal_menu = TerminalMenu(options)
    menu_entry_index = terminal_menu.show()
    match menu_entry_index:
        case 0:
            terminal_menu = TerminalMenu(["自动检测", "高斯模糊", "蒙版绘制"])
            menu_entry_index = terminal_menu.show()
            assert isinstance(menu_entry_index, int)
            scratch(menu_entry_index)
        case 1:
            terminal_menu = TerminalMenu(["任意绘制", "矩形区域"])
            menu_entry_index = terminal_menu.show()
            assert isinstance(menu_entry_index, int)
            draw_mosaic(menu_entry_index)


if __name__ == "__main__":
    main()
