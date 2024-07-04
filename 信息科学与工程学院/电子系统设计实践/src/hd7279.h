// HD7279.h 是 display 和 key 的底层库。

#ifndef __HD7279_H__
#define __HD7279_H__

#include <reg52.h>

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

void hd7279_init(void);
void long_delay(void);
void short_delay(void);
void write_7279(unsigned char, unsigned char);
unsigned char read_7279(unsigned char);
void send_byte(unsigned char);
unsigned char receive_byte(void);

#endif