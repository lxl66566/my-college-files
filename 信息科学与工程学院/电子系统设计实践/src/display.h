#ifndef __DISPLAY_H__
#define __DISPLAY_H__

#include "utils.h"
#include <reg52.h>

extern unsigned char show_chars[8];
extern unsigned char dot[8];

void display_main_loop(void);
void display(unsigned char position, char *);
void display_number(unsigned char position, unsigned int);
void display_address(unsigned char address);
void display_address_0x(unsigned char position, unsigned char address);
void clear_display(void);
void clear_display_pos(U8 pos);

#endif