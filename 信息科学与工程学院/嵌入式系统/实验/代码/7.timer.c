// 回调函数，定时器中断服务函数调用
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim) {
  if (htim == (&TIM3_Handler)) {
    LED1 = !LED1; // 发生中断时 LED1 闪烁
    if (!LED1)
      LED0 = 1; // 并且打断 LED0 的点亮状态
  }
}
