#include "utils.h"

void empty_loop(unsigned int times) {
  while (times--)
    ;
}

void delay_ms(unsigned int ms) {
  for (; ms > 0; ms--)
    empty_loop(110);
  ;
}

void overflow_add1(unsigned char *num, unsigned char limit) {
  (*num)++;
  *num %= limit;
}

void overflow_sub1(unsigned char *num, unsigned char limit) {
  if (*num == 0)
    *num = limit - 1;
  else
    (*num)--;
}