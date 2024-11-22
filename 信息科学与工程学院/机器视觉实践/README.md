# 机器视觉实践

信工大四上课程，持续两周。我真的不知道为什么实践课要在秋招 + 实习最忙的时间展开。

发现自己大部分时间都花在写前端和用户交互上了。。真正涉及图像处理的事情反而不算多。

## 运行代码

正常情况下，`uv run python -m src` 即可，uv 会自动安装依赖。代码会进入一个 TUI 导航面板，可以选择要运行的程序。

顺带一提 [uv](https://github.com/astral-sh/uv) 是一个还不错的 python 包管理器。本次实验依赖安装体积有 1.5G，主要是有个要用 pytorch 的实验占了很大体积，如果没代理嫌慢可以设一下 [UV_PYPY_INSTALL_MIRROR](https://docs.astral.sh/uv/configuration/environment/)。

但是像我这种用 NixOS 的倒霉鬼无法 `import _tk`，于是只能自己写 `shell.nix` 了。

```sh
nix-shell
steam-run uv run python -m src
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

## 4

图像补光与界面设计。我一开始做的是全局加亮度，直接调 PIL 库就行了。后来发现不太对，要求看起来还挺复杂的。至于那个 image compare 的玩意，我最后还是选择直接用前端。折腾 vue 折腾了一会儿不会用，只会写 SFC，碰到项目管理直接抓瞎。

然后刚好刷到一个 [img-comparison-slider](https://github.com/sneas/img-comparison-slider)，支持 html `<script>` 标签引入，完美解决我的需求。

## 5

图像水印添加与提取

我一开始还真做成水印，字面意义上的那种。。后面一细看，这玩意叫隐写！！

然后琢磨了一点方法，频域法做出来但是感觉不太行，不过交上去老师也认可了。然后回到寝室，LSB 自己设计了一个，就是纯粹心血来潮玩一玩。没想到一做就是一晚上，踩了不少坑，python 的 bytes/bytearray，jpg 和 png……

因为自己写的东西比较多，所以当成[大报告](./报告/5/大报告.typ)交了。

## 6

人脸亮牙。学校真没活了整抽象的了。

感觉不用大模型有点难做。分离牙齿和嘴唇好难。我那代码非常局限，换一张图估计就完全行不通了。

选择用前端做，刚好可以用之前补光的 image comparison 组件，结果踩了好多 opencv.js 的坑。

## 7

息肉检测。

- [Polyp-Localization](https://github.com/shivangi-aneja/Polyp-Localization)：需要自行训练；已经 archive。
- [kaggle - Automatic Polyp Detection in Colonoscopic Frames](https://www.kaggle.com/code/balraj98/automatic-polyp-detection-in-colonoscopic-frames/notebook)：有训练源码但是没有使用教程，要会用 torch

我用 kaggle 的模型，GPT 多问问，也就跑起来了。
