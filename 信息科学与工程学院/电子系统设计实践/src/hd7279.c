#include "hd7279.h"
#include "utils.h"

void send_byte(unsigned char out_byte) {
  unsigned char i;
  CS = 0;
  long_delay();
  for (i = 0; i < 8; i++) {
    if (out_byte & 0x80) {
      DAT = 1;
    } else {
      DAT = 0;
    }
    CLK = 1;
    short_delay();
    CLK = 0;
    short_delay();
    out_byte = out_byte * 2;
  }
}

unsigned char receive_byte(void) {
  unsigned char i, in_byte;
  DAT = 1;
  long_delay();
  for (i = 0; i < 8; i++) {
    CLK = 1;
    short_delay();
    in_byte = in_byte * 2;
    if (DAT) {
      in_byte = in_byte | 0x01;
    }
    CLK = 0;
    short_delay();
  }
  DAT = 0;
  return (in_byte);
}

void write_7279(unsigned char command, unsigned char _data) {
  send_byte(command);
  send_byte(_data);
}

unsigned char read_7279(unsigned char command) {
  send_byte(command);
  return (receive_byte());
}

void long_delay(void) {
  unsigned char i;
  for (i = 0; i < 0x30; i++)
    ;
}
void short_delay(void) {
  unsigned char i;
  for (i = 0; i < 8; i++)
    ;
}

void hd7279_init() {
  CS = 0;
  send_byte(CMD_RESET);
  CS = 1;
}