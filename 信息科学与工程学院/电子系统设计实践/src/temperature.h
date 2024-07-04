#ifndef __TEMPERATURE_H__
#define __TEMPERATURE_H__

#include "utils.h"
#include <reg52.h>

void temperature_init(void);
bit DS18B20_Reset(void);
U8 read_and_display_temperature(U8 pos);

#endif