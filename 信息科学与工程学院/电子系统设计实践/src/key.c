#include "key.h"
#include "hd7279.h"
#include "utils.h"

unsigned char last_key = KEY_NONE;

unsigned char read_key(void) {
  unsigned char readkey;
  send_byte(0x15);
  readkey = receive_byte();
  return (readkey);
}

// 任何 key 被按下时，返回 1，否则返回 0。注意松开时返回 0.
bit key_pressed(void) {
  unsigned char temp = read_key();
  if (temp != last_key) {
    last_key = temp;
    if (last_key != KEY_NONE)
      return 1;
  }
  return 0;
}
