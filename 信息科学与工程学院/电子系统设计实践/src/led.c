#include "led.h"

void enable_led(void) { LED_GREEN = 0; }
void disable_led(void) { LED_GREEN = 1; }