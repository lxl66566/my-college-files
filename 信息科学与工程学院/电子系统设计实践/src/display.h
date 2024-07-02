#ifndef __DISPLAY_H__
#define __DISPLAY_H__

#include <REG52.H>

extern unsigned char show_chars[8];
extern unsigned char dot[8];

void display_main_loop(void);
void display(char *);
void display_address(unsigned char address);
void display_address_0x(unsigned char position, unsigned char address);

#endif