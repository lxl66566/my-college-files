# 机器视觉实践

信工大四上课程，持续两周。我真的不知道为什么实践课要在秋招 + 实习最忙的时间展开。

## 运行代码

正常情况下，`uv run python -m src` 即可，uv 会自动安装依赖。代码会进入一个 TUI 导航面板，可以自由选择运行的程序。顺带一提 [uv](https://github.com/astral-sh/uv) 是一个还不错的 python 包管理器。

但是像我这种用 NixOS 的倒霉鬼无法 `import _tk`，于是只能自己写 `shell.nix` 了。

```sh
nix-shell
steam-run .venv/bin/python -m src
```

## 杂

- 人脸可以去 [thispersondoesnotexist](https://thispersondoesnotexist.com/) 拿

## 1

首日任务，划痕处理。

有几种做法，一个是直接全局高斯模糊加过去，另一个是调库 inpaint，需要有一层 mask 代表需要 inpaint 的地方，而 mask 的生成比较困难，一般需要用大模型。

- [PyInpaint](https://github.com/aGIToz/PyInpaint)：inpaint，需要图 + 蒙版。实际测试挺效果很差。
- [ComfyUI](https://github.com/cdb-boop/ComfyUI-Bringing-Old-Photos-Back-to-Life)：直接用大模型来修复，杀死了比赛。

我这里用了三个方法随便玩玩，第一个是自动检测白色划痕并移除，第二个是高斯模糊再解模糊，第三个是蒙版 inpaint。前两个效果都很差。

## 2

马赛克，这也太简单了吧，脑子里已经能想象出原理了。而且也有上次使用 tkinter 的经验。

反正我做了一个笔刷马赛克和一个矩形区域马赛克。取中心点颜色作为当前矩形的颜色。不能用左上角的颜色，否则会带来拖影问题。

## 3

人脸去痣。第一个肯定还是 inpaint，这玩意很好用，直接用以前代码就行。第二个是色块移动，tkinter 的代码可能得多写一会儿。
