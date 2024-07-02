#include "timer.h"
#include "utils.h"
#include <reg52.h>

void timer_init(unsigned int frequency) {
  // 定义 TH0 和 TL0 的值，以便达到所需的频率
  unsigned int reload_value;
  reload_value = 65536 - (11059200 / 12 / 2 / frequency);

  TH0 = (reload_value >> 8) & 0xFF; // 高字节
  TL0 = reload_value & 0xFF;        // 低字节

  TMOD &= 0xF0; // 清除 Timer 0 的设置
  TMOD |= 0x01; // 设置 Timer 0 为模式 1 (16 位定时器)

  TR0 = 1; // 启动定时器
  ET0 = 1; // 使能 Timer 0 中断
  EA = 1;  // 开启全局中断
}
