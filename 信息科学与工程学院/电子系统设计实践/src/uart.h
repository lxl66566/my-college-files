#ifndef __UART_H__
#define __UART_H__

#include "myfloat.h"

void UART_Init(void);
void send_char(unsigned char c);
void send_string_com(const unsigned char *str);
void send_number_com(unsigned int num);
void send_number_com_myfloat(struct myfloat num);

#endif