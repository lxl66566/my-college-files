void itoa_1(u8 i, u8 *str) { str[0] = i + '0'; } // 一位整数转字符串
int main(void) {
  u8 key, datatemp[1];
  u32 FLASH_SIZE = 32 * 1024 * 1024; // FLASH 大小为32M字节
  HAL_Init();                        // 初始化HAL库
  Stm32_Clock_Init(360, 25, 2, 8);   // 设置时钟,180Mhz
  delay_init(180);                   // 初始化延时函数
  uart_init(115200);                 // 初始化USART
  KEY_Init();                        // 初始化按键
  SDRAM_Init();                      // 初始化SDRAM
  LCD_Init();                        // 初始化LCD
  W25QXX_Init();                     // W25QXX初始化
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
      W25QXX_Read(datatemp, FLASH_SIZE - 100, sizeof(datatemp));
      LCD_ShowString(30, 190, 200, 16, 16, "The Data Readed Is: ");
      LCD_ShowString(30, 210, 200, 16, 16, datatemp);
      break;
    default:
      LCD_Fill(0, 170, 239, 319, WHITE); // 清除半屏
      LCD_ShowString(30, 170, 200, 16, 16, "Start Write....");
      itoa_1(key, datatemp); // 将 key 的值写入 datatemp
      W25QXX_Write((u8 *)datatemp, FLASH_SIZE - 100, sizeof(datatemp));
      LCD_ShowString(30, 190, 200, 16, 16, "Write Finished!"); // 提示传送完成
      break;
    }
  }
}
