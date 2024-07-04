#ifndef __KEY_H__
#define __KEY_H__

#include "utils.h"
#include <reg52.h>

#define KEY_DOWN 0x3B
#define KEY_UP 0x3A
#define KEY_RETURN 0x39
#define KEY_ENTER 0x38
#define KEY_NONE 0xFF

extern U8 last_key;
extern U8 tolerence;

U8 read_key(void);
bit key_pressed(void);

#endif