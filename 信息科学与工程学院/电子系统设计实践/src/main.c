#include "display.h"
#include "utils.h"
#include <REG52.H>
#include <intrins.h>
#include <math.h>
#include <stdio.h>

sbit Motor = P1 ^ 2;

int main(void) {
  display_init();
  while (1) {
    display("xyz");
  }
}