import logging as log
import shutil
from pathlib import Path

from PyConsoleMenu2 import BaseMenu

from ..utils import OpenOption, use_image
from ..utils.convert import convert_jpg_to_png, convert_png_to_jpg
from ..utils.noise import (
    add_color_block,
    add_gaussian_blur,
    add_salt_and_pepper_noise,
    apply_high_pass_filter,
)


def add_noise(input_path: Path, output_path: Path, noise: int = 0):
    temp_dir = input_path.parent
    match noise:
        case 0:
            # 不干
            shutil.copy2(input_path, output_path)
        case 1:
            # 椒盐噪声
            use_image(
                lambda x, y: add_salt_and_pepper_noise(x, y),
                tmpdir=temp_dir,
                input_image=input_path,
                output_image=output_path,
                open_option=OpenOption.NONE,
            )
        case 2:
            # 高斯噪声
            use_image(
                lambda x, y: add_gaussian_blur(x, y, 4),
                tmpdir=temp_dir,
                input_image=input_path,
                output_image=output_path,
                open_option=OpenOption.NONE,
            )
        case 3:
            # 高通滤波
            use_image(
                lambda x, y: apply_high_pass_filter(x, y, 3),
                tmpdir=temp_dir,
                input_image=input_path,
                output_image=output_path,
                open_option=OpenOption.NONE,
            )
        case 4:
            # 色块切割
            use_image(
                lambda x, y: add_color_block(x, y, (100, 100), (0, 0, 0)),
                tmpdir=temp_dir,
                input_image=input_path,
                output_image=output_path,
                open_option=OpenOption.NONE,
            )


def watermark_select(
    input_path: Path, output_path: Path, mode: int = 0, noise: int = 0
):
    s = input("请输入水印内容：")
    temp_dir = output_path.parent
    png_path = (temp_dir / "png").with_suffix(".png")
    noise_path = (temp_dir / "noise").with_suffix(png_path.suffix)
    middle_path = (temp_dir / "middle").with_suffix(png_path.suffix)

    convert_jpg_to_png(input_path, png_path)

    match mode:
        case 0:
            from .myfft import add_watermark, get_watermark

            add_watermark(png_path, middle_path, s)
            add_noise(middle_path, noise_path, noise)
            use_image(
                get_watermark,
                input_image=noise_path,
                output_image=output_path,
                tmpdir=temp_dir,
                open_option=OpenOption.INPUT,
            )

        case 1:
            from .external import add_watermark, get_watermark

            add_watermark(png_path, middle_path, s)
            add_noise(middle_path, output_path, noise)
            print("获取水印：", get_watermark(output_path))

        case 2:
            from .LSB import add_watermark, get_watermark

            output_path_png = output_path.with_suffix(".png")
            add_watermark(png_path, middle_path, s)
            add_noise(middle_path, output_path_png, noise)
            log.info(f"add noise to {output_path_png}")
            print("获取水印：", get_watermark(output_path_png))
            convert_png_to_jpg(output_path_png, output_path)

        case _:
            raise Exception("unimplemented")


def watermark_main(input_path: Path, output_path: Path):
    mode = (
        BaseMenu("选择方法")
        .add_options(
            [
                "频域直接添加",
                "调库 DWT + DCT（需要在 pyproject.toml 里取消注释依赖）",
                "LSB 最低有效位",
            ]
        )
        .run()
    )
    noise = (
        BaseMenu("选择噪声")
        .add_options(["无", "椒盐噪声", "高斯噪声", "高通滤波", "色块切割"])
        .run()
    )
    watermark_select(input_path, output_path, mode, noise)
