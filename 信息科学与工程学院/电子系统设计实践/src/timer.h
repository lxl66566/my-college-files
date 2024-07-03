#ifndef __TIMER_H__
#define __TIMER_H__

#include "utils.h"
#include <reg52.h>

// void timer_init(unsigned int frequency);
void timer_init(void);
void timer0_isr(void);

#endif