#ifndef __MOTOR__H_
#define __MOTOR__H_

#include "utils.h"
#include <reg52.h>

sbit MOTOR = P1 ^ 2;
extern U8 dutyCycle;

void set_duty_cycle(unsigned char dc);

#endif