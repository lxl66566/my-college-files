#ifndef __DISPLAY_H__
#define __DISPLAY_H__

#include <REG52.H>

void display_init(void);
void send_byte(unsigned char);
unsigned char receive_byte(void);
void display(unsigned char *);
void display_one(unsigned char, unsigned char);
void write_7279(unsigned char, unsigned char);
unsigned char read_7279(unsigned char);
void display_one_char(unsigned char address, unsigned char _data);

#endif