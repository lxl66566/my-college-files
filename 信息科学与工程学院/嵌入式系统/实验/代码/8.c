int main(void) {
  u16 led0pwmval = 0, maxn = 100;
  u8 dir = 1, delay = 10, key;
  HAL_Init();                      // 初始化HAL库
  Stm32_Clock_Init(360, 25, 2, 8); // 设置时钟,180Mhz
  delay_init(180);                 // 初始化延时函数
  uart_init(115200);
  KEY_Init();
  LED_Init(); // 初始化LED
  TIM3_PWM_Init(500 - 1, 90 - 1);
  // 90M/90=1M的计数频率，自动重装载为500，那么PWM频率为1M/500=2kHZ
  while (1) {
    key = KEY_Scan(0); // 调整 delay 的值，从而控制闪烁频率
    switch (key) {
    case WKUP_PRES:
      delay = 10;
      break;
    case KEY2_PRES:
      delay = 5;
      break;
    case KEY1_PRES:
      delay = 2.5;
      break;
    case KEY0_PRES:
      delay = 1.25;
      break;
    }
    delay_ms(delay);
    if (dir)
      led0pwmval++; // dir==1 led0pwmval递增
    else
      led0pwmval--; // dir==0 led0pwmval递减
    if (led0pwmval > maxn)
      dir = 0; // led0pwmval到达 maxn 后，方向为递减
    if (led0pwmval == 0)
      dir = 1; // led0pwmval递减到0后，方向改为递增
    TIM_SetTIM3Compare4(led0pwmval); // 修改比较值，修改占空比
  }
}
