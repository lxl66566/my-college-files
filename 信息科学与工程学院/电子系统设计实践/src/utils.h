#ifndef __UTILS_H__
#define __UTILS_H__

#define U8 unsigned char

void empty_loop(unsigned int times);
void delay_ms(unsigned int ms);
void delay_us(unsigned long us);
void overflow_add1(unsigned char *num, unsigned char limit);
void overflow_sub1(unsigned char *num, unsigned char limit);
void saturate_add1(unsigned char *num, unsigned char limit);
void saturate_sub1(unsigned char *num, unsigned char limit);

#endif