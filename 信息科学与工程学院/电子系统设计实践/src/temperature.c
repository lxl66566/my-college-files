#include "temperature.h"
#include "display.h"
#include "utils.h"
#include <reg52.h>

void DS1820_WriteData(U8 wData);
U8 DS1820_ReadData();
void deal_with_returned_data(U8 *temperature);

void deal_with_returned_data(U8 *temperature) {
  U8 temp_data, temp_data_2;
  unsigned int TempDec; // 用来存放 4 位小数
  temp_data = temperature[1];
  temp_data &= 0xf0;     // 取高 4 位
  if (temp_data == 0xf0) // 判断是正温度还是负温度读数
  {
    // 负温度读数求补,取反加 1,判断低 8 位是否有进位
    if (temperature[0] == 0) { // 有进位,高 8 位取反加 1
      temperature[0] = ~temperature[0] + 1;
      temperature[1] = ~temperature[1] + 1;
    } else { // 没进位,高 8 位不加 1
      temperature[0] = ~temperature[0] + 1;
      temperature[1] = ~temperature[1];
    }
  }
  temp_data = temperature[1]
              << 4; // 取高字节低 4 位(温度读数高 4 位),注意此时是 12 位精度
  temp_data_2 = temperature[0] >>
                4; // 取低字节高 4 位(温度读数低 4 位),注意此时是 12 位精度
  temp_data = temp_data | temp_data_2;          // 组合成完整数据
  show_chars[4] = (temp_data % 100) / 10 + '0'; // 取十位转换为 ASCII 码
  show_chars[5] = (temp_data % 100) % 10 + '0'; // 取个位转换为 ASCII 码
  dot[5] = 1;
  temperature[0] &= 0x0f; // 取小数位转换为 ASCII 码
  TempDec = temperature[0] *
            625; // 625=0.0625*10000,表示小数部分,扩大 1 万倍 ,方便显示
  show_chars[6] = TempDec / 1000 + '0'; // 取小数十分位转换为 ASCII 码
  show_chars[7] = (TempDec % 1000) / 100 + '0'; // 取小数百分位转换为 ASCII 码
}

void display_temperature() {
  U8 i;
  U8 temperature[2];
  DS1820_Reset();
  DS1820_WriteData(0xcc); // 跳过 ROM 命令
  DS1820_WriteData(0x44); // 温度转换命令
  DS1820_Reset();
  DS1820_WriteData(0xcc); // 跳过 ROM 命令
  DS1820_WriteData(0xbe); // 读 DS1820 温度暂存器命令
  for (i = 0; i < 2; i++) {
    temperature[i] = DS1820_ReadData();
  }
  DS1820_Reset(); // 复位,结束读数据
  // 调试原始数据
  // display_address_0x(0, temperature[0]);
  // display_address_0x(1, temperature[1]);
  deal_with_returned_data(temperature);
}

void temperature_init() {
  DS1820_Reset();
  DS1820_WriteData(0xCC);
  DS1820_WriteData(0x4E);
  DS1820_WriteData(0x20);
  DS1820_WriteData(0x00);
  DS1820_WriteData(0x7F);
  DS1820_Reset();
}

// 返回 1 为故障
bit DS1820_Reset(void) {
  bit flag;
  DS1820_DQ = 0;
  empty_loop(240);
  DS1820_DQ = 1;
  empty_loop(40);
  flag = DS1820_DQ;
  empty_loop(200);
  return flag;
}

void DS1820_WriteData(U8 wData) {
  U8 i, j;
  for (i = 8; i > 0; i--) {
    DS1820_DQ = 0;
    for (j = 2; j > 0; j--)
      ;
    DS1820_DQ = wData & 0x01;
    for (j = 30; j > 0; j--)
      ;
    DS1820_DQ = 1;
    wData >>= 1;
  }
}

U8 DS1820_ReadData() {
  U8 i, j, s;
  for (i = 8; i > 0; i--) {
    s >>= 1;
    DS1820_DQ = 0;
    for (j = 2; j > 0; j--)
      ;
    DS1820_DQ = 1;
    for (j = 4; j > 0; j--)
      ;
    if (DS1820_DQ == 1)
      s |= 0x80;
    for (j = 30; j > 0; j--)
      ;
    DS1820_DQ = 1;
  }
  return s;
}