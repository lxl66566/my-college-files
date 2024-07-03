#include "utils.h"
#include <intrins.h>

void delay_1us(void) {
  // __asm__("nop");
  // __asm__("nop");
  // __asm__("nop");
  // __asm__("nop");
  // __asm__("nop");
  _nop_();
  _nop_();
  _nop_();
  _nop_();
  _nop_();
}

void empty_loop(unsigned int times) {
  while (times--)
    ;
}

void delay_ms(unsigned int ms) {
  for (; ms > 0; ms--)
    empty_loop(100);
  ;
}

void delay_us(unsigned long us) {
  while (us--) {
    _nop_();
  }
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