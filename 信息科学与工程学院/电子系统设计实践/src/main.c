#include "display.h"
#include "hd7279.h"
#include "key.h"
#include "led.h"
#include <REG52.H>
#include <intrins.h>
#include <math.h>
#include <stdio.h>

sbit Motor = P1 ^ 2;

int main(void) {
  hd7279_init();
  while (1) {
    display_main_loop();
    if (key_changed()) {
      LED_GREEN = LED_DISABLE;
      if (last_key == KEY_UP) {
        display("88888888");
      } else {
        display_address_0x(last_key);
      }
    } else {
      LED_GREEN = LED_ENABLE;
    }
  }
}