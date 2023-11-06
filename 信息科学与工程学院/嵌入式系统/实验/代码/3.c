#include "delay.h"
#include "key.h"
#include "led.h"
#include "sys.h"
#include "usart.h"

// 调整占空比，即工作时间与总时间的比值。函数需要放在循环中才可用。
void space_ratio(u8 delayms, float rate) {
  LED1 = 0;
  delay_ms((u8)(delayms * rate));
  LED1 = 1;
  delay_ms((u8)(delayms * (1 - rate)));
}

// 根据不同按键，让 LED 灯显示不同亮度。

int main(void) {
  u8 key;
  HAL_Init();                      // 初始化HAL库
  Stm32_Clock_Init(360, 25, 2, 8); // 设置时钟,180Mhz
  delay_init(180);                 // 初始化延时函数
  uart_init(115200);               // 初始化USART
  LED_Init();                      // 初始化LED
  KEY_Init();                      // 初始化按键
  float f = 0;
  while (1) {
    key = KEY_Scan(0); // 按键扫描
    switch (key) {
    case WKUP_PRES:
      f = 0;
      break;
    case KEY2_PRES:
      f = f == 0.05f ? 0 : 0.05f;
      break;
    case KEY1_PRES:
      f = f == 0.2f ? 0 : 0.2f;
      break;
    case KEY0_PRES:
      f = f == 0.8f ? 0 : 0.8f;
      break;
    }
    space_ratio(20, f);
  }
}
