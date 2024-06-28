void space_ratio(u8 delayms, float rate) {
  LED0 = 0;
  delay_ms((u8)(delayms * rate));
  LED0 = 1;
  delay_ms((u8)(delayms * (1 - rate)));
}
void space_ratio(u8 delayms, float rate) {
  LED1 = 0;
  delay_ms((u8)(delayms * rate));
  LED1 = 1;
  delay_ms((u8)(delayms * (1 - rate)));
}
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin) {
  delay_ms(100);
  switch (GPIO_Pin) {
  case GPIO_PIN_0:
    if (WK_UP == 1) {
      for (int j = 0; j < 100; j++) {
        space_ratio(20, (float)j / 100.0 * 1.8);
      }
      for (int j = 99; j > 0; --j) {
        space_ratio(20, (float)j / 100.0 * 1.8);
      }
    }
    break;
  case GPIO_PIN_2:
    if (KEY1 == 0) {
      LED1 = !LED1;
    }
    break;
  case GPIO_PIN_3:
    if (KEY0 == 0) {
      for (int j = 0; j < 100; j++) {
        space_ratio2(20, (float)j / 100.0 * 1.8);
      }
      for (int j = 99; j > 0; --j) {
        space_ratio2(20, (float)j / 100.0 * 1.8);
      }
    }
    break;
  case GPIO_PIN_13:
    if (KEY2 == 0) {
      LED0 = !LED0;
    }
    break;
  }
}