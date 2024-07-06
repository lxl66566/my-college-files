#ifndef __MOTOR_H__
#define __MOTOR_H__

#include "myfloat.h"
#include "utils.h"
#include <reg52.h>

// keil
sbit MOTOR = P1 ^ 2;
// sdcc
// #define MOTOR P1_2

#define ENABLE_MOTOR MOTOR = 1
#define DISABLE_MOTOR MOTOR = 0

extern U8 counter;
extern U8 dutyCycle;
void set_duty_cycle(unsigned char dc);

void calc_duty_by_temperature(U8, U8);
void calc_duty_by_pid(struct myfloat expect);

#endif