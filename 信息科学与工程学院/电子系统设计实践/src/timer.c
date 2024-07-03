#include "timer.h"

#define frequency 1000
void timer_init(void) {
  // 定义 TH0 和 TL0 的值，以便达到所需的频率
  unsigned long reload_value;
  reload_value = 65536 - (11059200 / 12 / 2 / frequency);

  TH0 = (reload_value >> 4) & 0xFF; // 高字节
  TL0 = reload_value & 0xFF;        // 低字节

  TMOD &= 0xF0; // 清除 Timer 0 的设置
  TMOD |= 0x01; // 设置 Timer 0 为模式 1 (16 位定时器)

  TR0 = 1; // 启动定时器
  ET0 = 1; // 使能 Timer 0 中断
  EA = 1;  // 开启全局中断
}

// void timer_init(void) {
//   TMOD = 0x01;
//   TH0 = 0xee;
//   TL0 = 0x00;
//   IE0 = 1;
//   ET0 = 1;
//   TR0 = 1;
//   //
//   暂时关闭全局中断，等到控制占空比时再打开；可以防止中断影响温度控制，缓解频闪
//   EA = 0;
// }

// #define FOSC 11059200L                  // 12 MHz
// #define T1MS (65536 - FOSC / 12 / 1000) // 1 ms for timer0 in mode 1
// void timer_init(void) {
//   TMOD = 0x01; // 设置定时器0为模式1 (16位)
//   TH0 = T1MS >> 8;
//   TL0 = T1MS & 0xFF;
//   ET0 = 1; // 使能定时器0中断
//   TR0 = 1; // 启动定时器0
// }