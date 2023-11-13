#include "delay.h"
#include "led.h"
#include "sys.h"
#include "tpad.h"
#include "usart.h"

void space_ratio(u8 delayms, float rate, _Bool rev) {
  LED1 = rev;
  delay_ms((u8)(delayms * rate));
  LED1 = !rev;
  delay_ms((u8)(delayms * (1 - rate)));
}

int main(void) {
  HAL_Init();                      // 初始化HAL库
  Stm32_Clock_Init(360, 25, 2, 8); // 设置时钟,180Mhz
  delay_init(180);                 // 初始化延时函数
  uart_init(115200);               // 初始化USART
  LED_Init();                      // 初始化LED
  TPAD_Init(2); // 初始化触摸按键,以90/8=11.25Mhz频率计数
  u8 stage = 0;
  LED1 = 1;
  LED0 = 0;
  uint16_t delay = 10;
  uint16_t temp[] = {1000, 500, 100, 50};
  for (uint16_t t = 0;; ++t) {
    if (TPAD_Scan(0)) {
      ++stage;
      stage %= 5;
    }
    if (stage < 4 && t > temp[stage] / delay / 4) {
      LED1 = !LED1;
      LED0 = !LED1;
      t = 0;
    } else if (stage == 4) {
      LED1 = 1;
      if (t > 20)
        t = 0;
      for (int _ = 0; _ < 3; ++_)
        space_ratio(15, (float)t / 15, 0);
    }
    if (stage < 4)
      delay_ms(delay);
  }
}
