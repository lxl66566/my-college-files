#include "key.h"
#include "hd7279.h"
#include "utils.h"

#define TOLERENCE 35
U8 last_key = KEY_NONE;
U8 tolerence = TOLERENCE;

unsigned char read_key(void) {
  unsigned char readkey;
  send_byte(0x15);
  readkey = receive_byte();
  return (readkey);
}

// 任何 key 被按下时，返回 1；之后一段时间（容忍值）返回
// 0；如果继续长按，则每次都返回 1。注意 key 松开时没有任何效果。
bit key_pressed(void) {
  unsigned char temp = read_key();
  if (temp != last_key) {
    last_key = temp;
    tolerence = TOLERENCE;
    return last_key != KEY_NONE;
  } else if (last_key == KEY_NONE) {
    return 0;
  } else {
    saturate_sub1(&tolerence, 0);
    return tolerence == 0;
  }
}
