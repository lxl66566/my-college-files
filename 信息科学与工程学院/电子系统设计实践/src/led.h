#ifndef __LED_H__
#define __LED_H__

#include <reg52.h>

// sbit __at 0xA0 LED_GREEN;
#define LED_GREEN P2
#define ENABLE_LED LED_GREEN = 0
#define DISABLE_LED LED_GREEN = 1

void enable_led(void);
void disable_led(void);

#endif