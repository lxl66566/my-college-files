# 电子设计实践

本次实践我全程使用 linux，因此这是一份不太一样的折腾记录；并且用的不是常见发行版（NixOS），可以说可复现度非常低。不过代码是通用的，而且我敢保证代码绝对高质量，比那个 CSDN 上的要高太多了。

在 linux 上要考虑编译和烧录两部分。

烧录使用 [stcgal](https://github.com/grigorig/stcgal) 即可，它是 python3 的库，用 python 包管理器就能安装。我还尝试过一个要自己编的 C 库，在 nixos 上不好搞放弃了；另一个是 python2 的老库，也放弃了。linux 上烧录真的很香，不需要考虑驱动安装问题，有个同学 windows 服务禁用里 Device Manager，结果驱动一整天装不上。

编译就要麻烦许多了。我原本使用 sdcc + xmake，然而 keil 自己的头文件有自己的魔改，sdcc 想要编译需要大量修改，我也不是专业的，因此还是随大流使用 keil。当然，是在 wine 上。下面我将记录如何复现我的实验步骤。

## 下载资源

- [电子系统设计实践学生资料 2024.rar](https://cs.e.ecust.edu.cn/download/1d6453ca711af86c0b6a265c9d6416f4)
- [keil 安装包](https://cs.e.ecust.edu.cn/download/a92b89ce8b058019c770c905c0dfe2aa)

解压安装包，使用 wine 安装 `c51v954a.exe`（不安装 `MDK535.exe`！）。我用的是 bottles，只要鼠标点点点就行了。安装好后，在 keil 里 _File - License Management_ 复制 CID 放到破解软件里破解。这里就不多说，网上都有教程。

新建一个项目，Device 选 Atmel 下的 AT89C52。如果安装时装的是 `MDK535.exe`，这里可能没有 Atmel 的选项。在 Target 里把 Xtal 改成 11.0592。OUtput 里打开 _Create HEX file_。

建好项目，导入一个 .c 文件，随便写个初始程序：

```c
#include <REG52.H>
#include <intrins.h>
#include <math.h>
#include <stdio.h>
sbit Motor = P1 ^ 2;
void main(void) {
  P2 = 0x00;
  Motor = 0;
}
```

此程序让绿灯亮，马达转。编译后能在 Objects 下看到与项目名相同的 bin 文件和 .hex 文件。编译输出的 bin 是不能直接用的，要让它输出 hex 再自己转成 bin 烧录。

至于烧录，我使用的是 `dl.sh`，将 hex 转为 bin 后使用 stcgal 烧录。如果你使用 nix，可以通过 `nix develop && poetry install` 轻松搭好环境。至于其他环境也不难，`pip install stcgal` 一下，再随便找个 hex2bin 的软件或者让 GPT 写一个就行了。

连好线，执行 `./dl.sh`，将开关由不通电拨向上电状态，等待数秒即可完成烧录。
