#ifndef __DISPLAY_H__
#define __DISPLAY_H__

#include <REG52.H>

extern unsigned char show_chars[8];
void display_main_loop(void);
void display(char *);
void display_one(unsigned char, unsigned char);
void display_one_char(unsigned char address, char _data);
void display_address(unsigned char address);
void display_address_0x(unsigned char address);

#endif