#include "display.h"
#include "hd7279.h"

#define L_1 0x80
#define L_2 0x20
#define M_1 0x10
#define M_2 0x01
#define M_3 0x08
#define R_1 0x40
#define R_2 0x04
#define DOT 0x02

// 傻逼数码管排布逼我手搓码表
const unsigned char SEGMENT_TABLE[36] = {
    // Digits 0-9
    L_1 | L_2 | M_1 | M_3 | R_1 | R_2,       // 0
    R_1 | R_2,                               // 1, 0b01000100
    M_1 | M_3 | R_1 | L_2 | M_2,             // 2, 0b01111001
    M_1 | M_3 | R_1 | R_2 | M_2,             // 3, 0b01011101
    L_1 | M_2 | R_1 | R_2,                   // 4, 0b11000101
    L_1 | M_3 | M_2 | M_1 | R_2,             // 5
    L_1 | M_3 | M_2 | M_1 | L_2 | R_2,       // 6
    M_1 | R_1 | R_2,                         // 7
    L_1 | L_2 | M_1 | M_2 | M_3 | R_1 | R_2, // 8
    L_1 | M_2 | M_1 | M_3 | R_1 | R_2,       // 9

    // Letters A-Z
    L_1 | L_2 | M_1 | M_2 | R_1 | R_2, // A
    L_1 | L_2 | M_2 | M_3 | R_2,       // B
    L_1 | L_2 | M_1 | M_3,             // C
    R_1 | L_2 | M_2 | M_3 | R_2,       // D
    L_1 | L_2 | M_1 | M_2 | M_3,       // E
    L_1 | L_2 | M_1 | M_2,             // F
    L_1 | L_2 | M_1 | M_3 | R_2,       // G
    L_1 | L_2 | M_2 | R_1 | R_2,       // H
    R_2,                               // I
    M_3 | R_1 | R_2,                   // J
    L_1 | L_2 | M_1 | M_2 | R_2,       // K
    L_1 | L_2 | M_3,                   // L
    L_1 | L_2 | M_1 | R_1 | R_2,       // M
    L_2 | M_2 | R_2,                   // N
    L_2 | M_2 | R_2 | M_3,             // O
    L_1 | L_2 | M_1 | M_2 | R_1,       // P
    L_1 | R_2 | M_1 | M_2 | R_1,       // Q
    L_2 | M_2,                         // R
    L_1 | M_3 | M_2 | M_1 | R_2,       // S
    L_1 | L_2 | M_2 | M_3,             // T
    L_1 | L_2 | M_3 | R_1 | R_2,       // U
    L_2 | M_3 | R_2,                   // V
    L_1 | L_2 | M_2 | M_3 | R_1 | R_2, // W
    L_1 | M_2 | R_2,                   // X
    L_1 | M_2 | M_3 | R_1 | R_2,       // Y
    M_1 | M_3 | R_1 | L_2 | M_2 | DOT, // Z
};

// 定义

unsigned char show_chars[8] = "\0";
void clear_display() { send_byte(CMD_RESET); }

// 显示字符串
void display_main_loop(void) {
  unsigned char i;
  for (i = 0; i < 8; i++) {
    if (show_chars[i] == '\0')
      break;
    else
      display_one_char(i, show_chars[i]);
  }
}

void display(char *_data) {
  unsigned char i;
  clear_display();
  for (i = 0; i < 8; ++i) {
    show_chars[i] = _data[i];
  }
}

// 显示二进制地址，方便调试
void display_address(unsigned char address) {
  unsigned char i;
  clear_display();
  for (i = 0; i < 8; i++) {
    show_chars[i] = SEGMENT_TABLE[(address & (1 << i)) != 0 ? 1 : 0];
    if (show_chars[i] == '\0') {
      return;
    }
  }
}

// 显示十六进制地址，方便调试
void display_address_0x(unsigned char address) {
  unsigned char i;
  clear_display();
  show_chars[0] = '0';
  show_chars[1] = 'x';
  show_chars[2] = ((address & 0xf0) >> 4) + '0';
  show_chars[3] = (address & 0x0F) + '0';
  for (i = 4; i < 8; i++)
    show_chars[i] = ' ';
}

// 显示单个字符，address 为 0-7，下方 LED 是 0-3，上方是 4-7；data
// 为小写字母或数字
void display_one_char(unsigned char address, char _data) {
  if (_data == ' ') {
    return;
  }
  if (_data >= '0' && _data <= '9')
    display_one(address, SEGMENT_TABLE[_data - '0']);
  else if (_data >= 'a' && _data <= 'z')
    display_one(address, SEGMENT_TABLE[_data - 'a' + 10]);
  else if (_data >= 'A' && _data <= 'Z')
    display_one(address, SEGMENT_TABLE[_data - 'A' + 10]);
}

// 显示单个字符，address 为 0-7，下方 LED 是 0-3，上方是 4-7；data
// 为共阴数码管显示代码
void display_one(unsigned char address, unsigned char _data) {
  write_7279(UNDECODE + address, _data);
}
