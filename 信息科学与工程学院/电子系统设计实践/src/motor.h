#ifndef __MOTOR__H_
#define __MOTOR__H_

#include "utils.h"
#include <reg52.h>

// keil
sbit MOTOR = P1 ^ 2;
// sdcc
// #define MOTOR P1_2

#define ENABLE_INTERRUPT EA = 1
#define ENABLE_MOTOR MOTOR = 1
#define DISABLE_MOTOR MOTOR = 0

extern U8 counter;
extern U8 dutyCycle;
void set_duty_cycle(unsigned char dc);

#endif