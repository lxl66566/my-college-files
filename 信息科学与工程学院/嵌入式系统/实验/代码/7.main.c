int main(void) {
  HAL_Init();                      // 初始化HAL库
  Stm32_Clock_Init(360, 25, 2, 8); // 设置时钟,180Mhz
  delay_init(180);                 // 初始化延时函数
  uart_init(115200);               // 初始化USART
  LED_Init();                      // 初始化LED
  KEY_Init();                      // 初始化按键
  TIM3_Init(9000 - 1, 9000 - 1);
  // 定时器3初始化，定时器时钟为90M，分频系数为9000-1，
  // 所以定时器3的频率为90M/9000=10K，自动重装载为9000-1，那么定时器周期就是900ms
  delay_ms(10);
  while (1) {
    LED0 = !LED0; // LED0翻转
    delay_ms(500);
  }
}
