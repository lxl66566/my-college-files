#ifndef __KEY_H__
#define __KEY_H__

#include <reg52.h>

#define KEY_DOWN 0x3B
#define KEY_UP 0x3A
#define KEY_RETURN 0x39
#define KEY_ENTER 0x38
#define KEY_NONE 0xFF

extern unsigned char last_key;

unsigned char read_key(void);
bit key_pressed(void);

#endif