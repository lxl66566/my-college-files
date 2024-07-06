#ifndef __UART_H__
#define __UART_H__

void UART_Init(void);
void send_char(unsigned char c);
void send_string_com(const unsigned char *str);
void send_number_com(unsigned int num);
void send_number_com_float(float num);

#endif