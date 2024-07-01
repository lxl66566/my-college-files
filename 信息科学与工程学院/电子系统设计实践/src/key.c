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

unsigned char key_changed() {
  unsigned char temp = read_key();
  if (temp != last_key) {
    last_key = temp;
    return 1;
  }
  return 0;
}