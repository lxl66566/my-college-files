#ifndef __KEY_H__
#define __KEY_H__

#include <REG52.H>

#define KEY_DOWN 0x3B
#define KEY_UP 0x3A
#define KEY_RETURN 0x39
#define KEY_ENTER 0x38
#define KEY_NONE 0xFF

extern unsigned char last_key;

void key_init();
unsigned char read_key();
bit key_pressed();

#endif