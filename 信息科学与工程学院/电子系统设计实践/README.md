# 电子设计实践

本次实践我全程使用 linux，因此这是一份不太一样的折腾记录；并且用的不是常见发行版（NixOS），可以说可复现度非常低。不过我敢保证代码质量绝对不低，提供了易用的用户接口。

在 linux 上要考虑编译和烧录两部分。

## 开发环境设置

### 烧录教程

烧录使用 [stcgal](https://github.com/grigorig/stcgal) 即可，它是 python3 的库，用 python 包管理器就能安装。如果你使用 nix，可以通过 `nix develop && poetry install` 轻松搭好环境。至于其他环境也不难，`pip install stcgal` 一下，再随便找个 hex2bin 的软件或者让 GPT 写一个就行了。

我还尝试过 gSTC-ISP，它需要自己 make，在 nixos 上不好搞放弃了；另一个是 python2 的老库，也放弃了。linux 上烧录真的很香，不需要考虑驱动安装问题，硬写 `/dev/ttyUSB0` 就行，~~其他人用 windows 装 2012 年的驱动要考虑的就多了~~，有个同学 windows 服务里禁用了 Device Manager，结果驱动一整天装不上，蓝屏几十次（）

连好线，执行 `./dl.sh`（keil）或直接 `xmake dl`（sdcc + xmake），将开关由不通电拨向上电状态，等待数秒即可完成烧录。

### 编译教程

编译就要麻烦许多了。我原本想使用 sdcc + xmake，然而 keil 自己的头文件有自己的魔改，sdcc 想要编译需要大量修改，我也不是专业的，因此还是随大流使用 keil……当然，是在 wine 上。然后这样做了几天，感觉自己有能力把工具链搬到 sdcc 上了，于是 20240703 尝试了一下，成功编译了。

#### sdcc + xmake

1. 安装 sdcc 与 xmake。如果你也用 nixos，可以直接 `nix develop`。
2. 在此项目下进行配置：`xmake f -p mcs51 --toolchain=sdcc -a mcs51 --sdk=/nix/store/5jwp9pyvrrsk617qzlf9gld5ip489x4z-sdcc-4.4.0/`，把 --sdk 替换为 sdcc sdk 路径。
   - 每次 `nix develop` 都需要执行一次；并重启 clangd。否则可以直接把 sdcc 装到 user 上。
3. 对代码进行额外处理。
   - 所有的 `#include <REG52.H>` 改为 `#include <reg52.h>`。
   - 所有的类似 `sbit Motor = P1 ^ 2;` 都需要改为 `#define Motor P1_2`。原因是 sdcc 用 `sbit` 而不是 `sbit` 并且只接受常量，不接受异或运算。而 `8051.h` 里定义了 `P1_0` 等地址。如果不希望用 define，也可以 `sbit __at 0x92 MOTOR;`。bit 类似。
   - 所有的中断（`void xxx(void) interrupt 1`）改为`void xxx(void) __interrupt(1)`。
   - 所有的 `_nop_();` 换成 `__asm__("nop");`
4. 运行 `xmake && xmake dl` 编译并烧录。

参考资料：[使用 SDCC+xmake+VScode 打造一个自由的 51 单片机开放环境](https://www.stcaimcu.com/forum.php?mod=viewthread&tid=8013)

但是在成功后又出现了一些莫名其妙的问题，使我被迫放弃了 sdcc：

1. LED 不亮
2. 中断服务不运行

我看引脚都是对的。

#### keil

- [电子系统设计实践学生资料 2024.rar](https://cs.e.ecust.edu.cn/download/1d6453ca711af86c0b6a265c9d6416f4)
- [keil 安装包](https://cs.e.ecust.edu.cn/download/a92b89ce8b058019c770c905c0dfe2aa)

解压安装包，使用 wine 安装 `c51v954a.exe`（不安装 `MDK535.exe`！）。我用的 wine GUI 是 bottles，只要鼠标点点点就行了。安装好后，在 keil 里 _File - License Management_ 复制 CID 放到破解软件里破解。这里就不多说，网上都有教程。如果不破解，写程序时可能以代码超出长度为由终止编译。

新建一个项目，Device 选 Atmel 下的 AT89C52。如果安装时装的是 `MDK535.exe`，这里可能没有 Atmel 的选项。在 Target 里把 Xtal 晶振频率改成 11.0592。OUtput 里打开 _Create HEX file_。建好项目，导入一个 .c 文件，随便写个初始程序：

```c
#include <REG52.H>
sbit Motor = P1 ^ 2;
void main(void) {
  P2 = 0x00;
  Motor = 0;
}
```

此程序让绿灯亮，马达转。编译后能在 Objects 下看到与项目名相同的 bin 文件和 .hex 文件。编译输出的 bin 是不能直接用的，要让它输出 hex 再自己转成 bin 烧录。

课程提供的 keil v5 使用的 C 语言编译器是 C51.exe V9.54，仅持 C89 标准。因此在编程时有一些需要注意的：

- 不能使用 `inline`，`_Bool`
- 函数定义前必须声明
- 变量声明必须写在代码块最前面
- for 循环首个参数不允许定义变量

## 程序部分

参考资料：[电子系统设计实践——软件编写](https://blog.csdn.net/weixin_42024288/article/details/118878486)，学长的程序

### 字符表

本来我打算直接去网上抄一般八段共阴数码管的字符表的，结果你校这玩意不太标准，显示的位置跟乱序差不多，非常扭曲（举个例子，小数点显示是 0x02,这玩意居然在中间！）。网上抄不到表，让 GPT4o 写也写不出来，我只好自己写了一个，详见 [src/display.c](./src/display.c)。其实写起来也很快就是了。

### 温度传感器

PPT 上给的 DS18B20_DQ 的定义是 `sbit DS18B20_DQ = P1 ^ 4;`，但是实际上地址是 `P1 ^ 3`。。。我真服了，我说怎么读出来一直都是两个 `0xFF`，初始化一直都是 Err。。后来发现即使温度传感器没问题，也会返回高电平 err（

然后首次读温度传感器值时会出现神奇的 85.00。可以在初始化时直接读一次消除。

### 电机占空比
