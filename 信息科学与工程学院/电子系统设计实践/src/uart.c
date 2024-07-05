#include "uart.h"
#include <reg52.h>

#define FOSC 11059200L // 晶振频率
#define BAUD 9600      // 波特率

// 初始化串口
void UART_Init(void) {
  TMOD = 0x20; // 定时器1模式2（8位自动重载）
  TH1 = 256 - (FOSC / 12 / 32 / BAUD); // 设置波特率
  TR1 = 1;                             // 启动定时器1
  SCON = 0x50; // 串口模式1，8位数据，允许接收
  TI = 1;      // 设置传输中断标志位
}

// 发送一个字符到串口
void send_char(unsigned char c) {
  SBUF = c; // 将字符写入串口缓冲区
  while (!TI)
    ;     // 等待传输完成
  TI = 0; // 清除传输中断标志位
}

// 发送字符串到串口
void send_string_com(const unsigned char *str) {
  while (*str) {
    send_char(*str++); // 发送字符串中的每个字符
  }
}

void send_number_com(unsigned int num) {
  char buffer[6];                          // 5位数字 + 终止符
  char *ptr = buffer + sizeof(buffer) - 1; // 指向缓冲区末尾

  *ptr = '\0'; // 添加终止符
  do {
    *--ptr = (num % 10) + '0'; // 获取当前数字的最低位并转换为字符
    num /= 10;                 // 去掉最低位
  } while (num > 0);

  send_string_com(ptr); // 发送转换后的字符串
}