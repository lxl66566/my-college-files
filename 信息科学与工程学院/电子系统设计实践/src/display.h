#ifndef __DISPLAY_H__
#define __DISPLAY_H__

#include "utils.h"
#include <reg52.h>

extern unsigned char show_chars[8];
extern unsigned char dot[8];

void display_main_loop(void);
void display(bit position, const char *str);
void display_number(bit position, unsigned int num);
void display_number_float_1(bit position, float num);
void display_address(unsigned char address);
void display_address_0x(bit position, unsigned char address);
void clear_display(void);
void clear_display_pos(bit pos);

#endif