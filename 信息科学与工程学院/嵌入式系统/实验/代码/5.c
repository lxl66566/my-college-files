void space_ratio(u8 delayms, float rate, _Bool rev) {
  // 根据占空比调整 LED 亮度
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
  u8 stage = 0; // 共有 5 个状态，0 - 3 有不同闪烁频率，4 是亮度高低闪烁。
  LED1 = 1, LED0 = 0;                                 // 初始状态
  uint16_t delay = 10, temp[] = {1000, 500, 100, 50}; // 设置闪烁间隔
  for (uint16_t t = 0;; ++t) {                        // t 用于计时
    if (TPAD_Scan(0)) { // 检测到按键，改变当前状态
      ++stage, stage %= 5;
    }
    if (stage < 4 && t > temp[stage] / delay / 4) {
      // 若处于闪烁状态且该次闪烁已打到时间，闪烁
      LED1 = !LED1, LED0 = !LED1;
      t = 0;
    } else if (stage == 4) { // 在亮度调节状态
      LED1 = 1;              // 初始亮度最低
      if (t > 20)
        t = 0;                    // 反复闪烁
      for (int _ = 0; _ < 3; ++_) // 延时
        space_ratio(15, (float)t / 15, 0);
    }
    if (stage < 4) // 4 状态的 space_ratio 自带延时，因此不需要再 delay
      delay_ms(delay);
  }
}
