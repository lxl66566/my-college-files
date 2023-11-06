#import "template.typ": *

#show: project.with(
  title: "实验报告 1",
  authors: (
    "absolutex",
  )
)

= 跑马灯实验（寄存器版本）
== 实验目的

源代码通过代码控制 ALIENTEK 阿波罗 STM32 开发板上的两个 LED 灯 DS0 和 DS1 交替闪烁，实现类似跑马灯的效果。

需要修改代码，初步掌握 STM32F429 基本 IO 口的使用。

== 代码描述

```cpp
#include "delay.h"
#include "led.h"
#include "sys.h"
int main(void) {
  Stm32_Clock_Init(360, 25, 2, 8);
  delay_init(180);
  LED_Init();
  int d = 5;
  int sist = 7;
  while (1) {
    for (int i = 0; i < d; ++i) {
      for (int _ = 0; _ < sist; ++_) {
        LED1 = 0;
        delay_ms(i);
        LED1 = 1;
        delay_ms(d * 4 - i);
      }
    }
    for (int i = d - 1; i > 0; --i) {
      for (int _ = 0; _ < sist; ++_) {
        LED1 = 0;
        delay_ms(i);
        LED1 = 1;
        delay_ms(d * 4 - i);
      }
    }
  }
}
```
用到了两个 for 循环，外层循环控制占空比，内层循环起到延时作用，使人眼能够观测到占空比变化。

== 实验结果

观察到 DS1 由暗到亮，再由亮到暗的循环闪烁。

== 心得体会

想要达到比较好的观察效果需要细致地调整参数。LED 的占空比在 0.3 以下时可以明显看出亮度变化，而在 0.4 以上时，LED 较亮，导致亮度变化不明显。

= 跑马灯实验（HAL 库版本）

= 按键输入实验

= 外部中断实验

== 心得体会

由于不熟悉串口调试工具的使用，在串口调试时遇到了麻烦。需要接对串口线，选中正确的波特率，才可以看到正常输出。选择了错误的波特率可能导致接收的信息乱码。