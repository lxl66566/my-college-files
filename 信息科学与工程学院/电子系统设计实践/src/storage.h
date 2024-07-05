#ifndef __STORAGE_H__
#define __STORAGE_H__

// 预设的地址，随便取的
#define TEMPERATURE_UP_LIMIT_ADR 0x65   // 电机温度上限地址
#define TEMPERATURE_DOWN_LIMIT_ADR 0x66 // 电机温度下限地址

unsigned char read_byte(unsigned char);
void write_byte(unsigned char dat, unsigned char addr);

#endif