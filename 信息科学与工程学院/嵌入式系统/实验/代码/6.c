#include "ap3216c.h"
#include "delay.h"
#include "key.h"
#include "lcd.h"
#include "led.h"
#include "math.h"
#include "sdram.h"
#include "sys.h"
#include "usart.h"

int main(void) {
  u16 ir, als, ps;
  HAL_Init();                      // 初始化HAL库
  Stm32_Clock_Init(360, 25, 2, 8); // 设置时钟,180Mhz
  delay_init(180);                 // 初始化延时函数
  uart_init(115200);               // 初始化USART
  LED_Init();                      // 初始化LED
  KEY_Init();                      // 初始化按键
  SDRAM_Init();                    // 初始化SDRAM
  LCD_Init();                      // 初始化LCD
  POINT_COLOR = RED;
  while (AP3216C_Init()) // 检测不到AP3216C
  {
    LCD_ShowString(30, 130, 200, 16, 16, "AP3216C Check Failed!");
    delay_ms(500);
    LCD_ShowString(30, 130, 200, 16, 16, "Please Check!        ");
    delay_ms(500);
    LED0 = !LED0; // DS0闪烁
  }
  LCD_ShowString(30, 130, 200, 16, 16, "AP3216C Ready!");
  LCD_ShowString(30, 160, 200, 16, 16, " IR:");
  LCD_ShowString(30, 180, 200, 16, 16, " PS:");
  LCD_ShowString(30, 200, 200, 16, 16, "ALS:");
  POINT_COLOR = BLUE; // 设置字体为蓝色
  const int center[] = {230, 400};
  u8 key;
  _Bool mode = 0;
  while (1) {
    key = KEY_Scan(0);
    switch (key) {
    case WKUP_PRES:
      mode = !mode;
      break;
    default:;
    }
    AP3216C_ReadData(&ir, &ps, &als); // 读取数据
    LCD_Clear(99999);
    LCD_ShowString(30, 130, 200, 16, 16,
                   !mode ? "mode: distance" : "mode: brightness");
    const float temp = !mode ? (float)ps / 10 : sqrt(als) * 1.5;
    LCD_Draw_Circle(center[0], center[1], temp);
    LCD_Draw_Circle(center[0], center[1], temp + 1);
    LCD_Draw_Circle(center[0], center[1], temp + 2);
    LED0 = !LED0;
    ; // 提示系统正在运行
    delay_ms(90);
  }
}
