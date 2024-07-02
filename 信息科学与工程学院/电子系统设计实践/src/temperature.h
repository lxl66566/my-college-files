#ifndef __TEMPERATURE_H__
#define __TEMPERATURE_H__

#include "utils.h"
#include <reg52.h>

sbit DS1820_DQ = P1 ^ 3; // 单总线引脚
void temperature_init();
bit DS1820_Reset();
void display_temperature();

#endif