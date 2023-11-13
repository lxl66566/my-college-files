#include "math.h"
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
  POINT_COLOR = BLUE;              // 设置字体为蓝色
  const int center[] = {230, 400}; // 圆圈的中心点
  u8 key;
  _Bool mode = 0; // 模式，0 为距离模式，1 为光照模式
  while (1) {
    key = KEY_Scan(0); // 监测按键，改变工作模式
    if (key == WKUP_PRES)
      mode = !mode;
    AP3216C_ReadData(&ir, &ps, &als); // 读取数据
    LCD_Clear(99999); // 每个循环清屏，让圆形能动态显示
    LCD_ShowString(30, 130, 200, 16, 16,
                   !mode ? "mode: distance"
                         : "mode: brightness"); // 在显示屏上显示工作模式
    const float temp =
        !mode ? (float)ps / 10 : sqrt(als) * 1.5; // 预处理距离/亮度，坐标变换
    LCD_Draw_Circle(center[0], center[1], temp);
    LCD_Draw_Circle(center[0], center[1], temp + 1);
    LCD_Draw_Circle(center[0], center[1], temp + 2);
    // 画圆。LCD_Draw_Circle 函数没有调节粗细的功能，因此画三个圆来加粗。
    delay_ms(90);
  }
}
