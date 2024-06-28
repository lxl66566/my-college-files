void itoa_1(u8 i, u8 *str) { str[0] = i + '0'; } // 一位整数转字符串
int main(void) {
  u8 key, datatemp[1], buffer[1];
  HAL_Init();                      // 初始化HAL库
  Stm32_Clock_Init(360, 25, 2, 8); // 设置时钟,180Mhz
  delay_init(180);                 // 初始化延时函数
  uart_init(115200);               // 初始化USART
  KEY_Init();                      // 初始化按键
  SDRAM_Init();                    // 初始化SDRAM
  LCD_Init();                      // 初始化LCD
  AT24CXX_Init();                  // 初始化IIC
  POINT_COLOR = RED;
  LCD_ShowString(30, 130, 200, 16, 16, "KEYUP:Read  other:Write");
  POINT_COLOR = BLUE;
  while (1) {
    delay_ms(10);
    key = KEY_Scan(0);
    switch (key) {
    case 0:
      break;
    case WKUP_PRES:                      // WKUP 按下,读取字符串并显示
      LCD_Fill(0, 170, 239, 319, WHITE); // 清除半屏
      AT24CXX_Read(0, datatemp, sizeof(buffer)); // 读取 buffer 的值并显示
      LCD_ShowString(30, 190, 200, 16, 16, "The Data Readed Is: ");
      LCD_ShowString(30, 210, 200, 16, 16, buffer);
      break;
    default:
      LCD_Fill(0, 170, 239, 319, WHITE); // 清除半屏
      LCD_ShowString(30, 170, 200, 16, 16, "Start Write 24C02....");
      itoa_1(key, buffer); // 将 key 的值写入 buffer
      AT24CXX_Write(0, (u8 *)buffer, sizeof(buffer)); // 将 buffer 写入
      LCD_ShowString(30, 190, 200, 16, 16, "Write Finished!"); // 提示传送完成
      break;
    }
  }
}
