#include "display.h"
#include "utils.h"

sbit CS = P1 ^ 4;
sbit DAT = P1 ^ 7;
sbit CLK = P1 ^ 5;
sbit KEY = P1 ^ 6;

#define CMD_RESET 0xa4
#define CMD_TEST 0xbf
#define DECODE0 0x80
#define DECODE1 0xc8
#define CMD_READ 0x15
#define UNDECODE 0x90
#define RTL_CYCLE 0xa3
#define RTR_CYCLE 0xa2
#define RTL_UNCYL 0xa1
#define RTR_UNCYL 0xa0
#define ACTCTL 0x98
#define SEGON 0xe0
#define SEGOFF 0xc0
#define BLINKCTL 0x88

void long_delay(void);
void short_delay(void);

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

void clear_display() { send_byte(CMD_RESET); }

// 显示字符串
void display(unsigned char *str) {
  unsigned char i;
  for (i = 0; i < 8; i++) {
    if (str[i] == '\0')
      break;
    else
      display_one_char(i, str[i]);
  }
}

// 显示单个字符，address 为 0-7，下方 LED 是 0-3，上方是 4-7；data
// 为小写字母或数字
void display_one_char(unsigned char address, unsigned char _data) {
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

void display_init(void) {
  CS = 0;
  clear_display();
  CS = 1;
}
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
  delay_ms(50); // 时序初始延时
  for (i = 0; i < 8; i++) {
    CLK = 1;
    delay_ms(10);
    // 左移一位，空出最后一位存放新进来的位DAT
    in_byte = in_byte * 2;
    // 若新进来的位DAT为1，则in_byte的末位置1，否则不需要变
    if (DAT)
      in_byte = in_byte | 0x01;
    CLK = 0;
    delay_ms(10);
  }
  DAT = 0;
  return (in_byte); // 返回接收值
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