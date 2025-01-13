import time
from pathlib import Path

import pyautogui


def type_in_vnc(text):
    # 等待一段时间，确保你切换到 VNC 窗口
    time.sleep(3)

    # 模拟键盘输入
    pyautogui.write(text)


if __name__ == "__main__":
    # 指定要输入的字符串
    text_to_type = (Path(__file__).parent / "text_to_send").read_text(encoding="utf-8")

    # 调用函数输入字符串
    type_in_vnc(text_to_type)
