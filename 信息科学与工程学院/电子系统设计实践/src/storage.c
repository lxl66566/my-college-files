#include "storage.h"
#include "utils.h"
#include <reg52.h>

// #define SCL P1 ^ 1
// #define SDA P1 ^ 0
sbit SCL = P1 ^ 1;
sbit SDA = P1 ^ 0;
#define WriteDeviceAddress 0xa0
#define ReadDeviceAddress 0xa1

unsigned char readbyte_I2C(void);
void writebyte_I2C(unsigned char);
void I2C_noack(void);
void I2C_ack(void);
void I2C_stop(void);
void I2C_start(void);
void init_24c16(void);

void init_24c16(void) {
  SDA = 1;
  SCL = 1;
}

void I2C_start(void) {
  SDA = 1;
  delay_us(5);
  SCL = 1;
  delay_us(5);
  SDA = 0;
  delay_us(5);
}

void I2C_stop(void) {
  SDA = 0;
  delay_us(5);
  SCL = 1;
  delay_us(5);
  SDA = 1;
  delay_us(5);
}

void I2C_ack(void) {
  unsigned char i = 0;
  SCL = 1;
  delay_us(5);
  while ((SDA == 1) && (i < 200))
    i++;
  SCL = 0;
  delay_us(5);
}

void I2C_noack(void) {
  SDA = 1;
  delay_us(5);
  SCL = 1;
  delay_us(5);
  SCL = 0;
  delay_us(5);
}
void writebyte_I2C(unsigned char input) {
  unsigned char i;
  SCL = 0;
  for (i = 0; i < 8; i++) {
    if (input & 0x80)
      SDA = 1;
    else
      SDA = 0;
    input = input << 1;
    delay_us(5);
    SCL = 1;
    delay_us(5);
    SCL = 0;
    delay_us(5);
  }
  SDA = 1;
  delay_us(5);
}

unsigned char readbyte_I2C(void) {
  unsigned char i, rbyte = 0;
  SCL = 0;
  delay_us(5);
  SDA = 1;
  delay_us(5);
  for (i = 0; i < 8; i++) {
    SCL = 1;
    delay_us(5);
    rbyte = rbyte << 1;
    if (SDA)
      rbyte++;
    SCL = 0;
    delay_us(5);
  }
  return rbyte;
}

void write_byte(unsigned char dat, unsigned char addr) {
  init_24c16();
  I2C_start();
  writebyte_I2C(WriteDeviceAddress);
  I2C_ack();
  writebyte_I2C(addr);
  I2C_ack();
  writebyte_I2C(dat);
  I2C_ack();
  I2C_stop();
}

unsigned char read_byte(unsigned char addr) {
  unsigned char output;
  init_24c16();
  I2C_start();
  writebyte_I2C(WriteDeviceAddress);
  I2C_ack();
  writebyte_I2C(addr);
  I2C_ack();
  I2C_start();
  writebyte_I2C(ReadDeviceAddress);
  I2C_ack();
  output = readbyte_I2C();
  I2C_noack();
  I2C_stop();
  return output;
}
