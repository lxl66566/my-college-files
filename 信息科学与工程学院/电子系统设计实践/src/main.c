#include <REG52.H>
#include <intrins.h>
#include <math.h>
#include <stdio.h>
sbit Motor = P1 ^ 2;
void main(void) {
  P2 = 0x00;
  Motor = 0;
}