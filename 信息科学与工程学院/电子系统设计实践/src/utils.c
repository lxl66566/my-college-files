#include "utils.h"

void empty_loop(unsigned int times) {
  unsigned int i;
  while (times--)
    ;
}

void delay_ms(unsigned int ms) {
  for (; ms > 0; ms--)
    empty_loop(110);
  ;
}