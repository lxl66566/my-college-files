#ifndef __TIMER_H__
#define __TIMER_H__

#include "utils.h"
#include <reg52.h>

#define ENABLE_INTERRUPT EA = 1
#define DISABLE_INTERRUPT EA = 0

void timer_init(void);
void timer0_isr(void);

#endif