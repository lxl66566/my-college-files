// 与 1.c 相同效果，不过是库函数版本
#include "delay.h"
#include "led.h"
#include "sys.h"
#include "usart.h"
int main(void) {
  HAL_Init();                      // 初始化HAL库
  Stm32_Clock_Init(360, 25, 2, 8); // 设置时钟,180Mhz
  delay_init(180);                 // 初始化延时函数
  LED_Init();
  int d = 5;
  int sist = 7;
  while (1) {
    for (int i = 0; i < d; ++i) {
      for (int _ = 0; _ < sist; ++_) {
        HAL_GPIO_WritePin(GPIOB, GPIO_PIN_1, GPIO_PIN_RESET);
        delay_ms(i);
        HAL_GPIO_WritePin(GPIOB, GPIO_PIN_1, GPIO_PIN_SET);
        delay_ms(d * 4 - i);
      }
    }
    for (int i = d - 1; i > 0; --i) {
      for (int _ = 0; _ < sist; ++_) {
        HAL_GPIO_WritePin(GPIOB, GPIO_PIN_1, GPIO_PIN_RESET);
        delay_ms(i);
        HAL_GPIO_WritePin(GPIOB, GPIO_PIN_1, GPIO_PIN_SET);
        delay_ms(d * 4 - i);
      }
    }
  }
}
