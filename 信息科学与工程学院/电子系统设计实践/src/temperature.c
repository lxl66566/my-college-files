#include "temperature.h"
#include "display.h"
#include "utils.h"
#include <reg52.h>

sbit DS18B20_DQ = P1 ^ 3;
U8 temperature[2];

void DS18B20_WriteData(U8 wData);
U8 DS18B20_ReadData(void);
void display_temperature(U8 pos, U8 *temperature);
U8 *read_temperature(void);

// pos，0 为显示在上一排，1 为显示在下一排
void display_temperature(U8 pos, U8 *temperature) {
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
  temp_data = temp_data | temp_data_2; // 组合成完整数据
  show_chars[4 - 4 * pos] =
      (temp_data % 100) / 10 + '0'; // 取十位转换为 ASCII 码
  show_chars[5 - 4 * pos] =
      (temp_data % 100) % 10 + '0'; // 取个位转换为 ASCII 码
  dot[5 - 4 * pos] = 1;
  temperature[0] &= 0x0f; // 取小数位转换为 ASCII 码
  TempDec = temperature[0] *
            625; // 625=0.0625*10000,表示小数部分,扩大 1 万倍 ,方便显示
  show_chars[6 - 4 * pos] = TempDec / 1000 + '0'; // 取小数十分位转换为 ASCII 码
  show_chars[7 - 4 * pos] =
      (TempDec % 1000) / 100 + '0'; // 取小数百分位转换为 ASCII 码
}

U8 *read_temperature(void) {
  U8 i;
  DS18B20_Reset();
  DS18B20_WriteData(0xcc); // 跳过 ROM 命令
  DS18B20_WriteData(0x44); // 温度转换命令
  DS18B20_Reset();
  DS18B20_WriteData(0xcc); // 跳过 ROM 命令
  DS18B20_WriteData(0xbe); // 读 DS18B20 温度暂存器命令
  for (i = 0; i < 2; i++) {
    temperature[i] = DS18B20_ReadData();
  }
  DS18B20_Reset(); // 复位,结束读数据
  return temperature;
}

void read_and_display_temperature(U8 pos) {
  read_temperature();
  // 调试原始数据
  // display_address_0x(0, temperature[0]);
  // display_address_0x(1, temperature[1]);
  display_temperature(pos, temperature);
}

void temperature_init(void) {
  DS18B20_Reset();
  DS18B20_WriteData(0xCC);
  DS18B20_WriteData(0x4E);
  DS18B20_WriteData(0x20);
  DS18B20_WriteData(0x00);
  DS18B20_WriteData(0x7F);
  DS18B20_Reset();
  // 初始化时读一次温度，消除默认值 85.00
  read_temperature();
}

// 返回 1 为故障
bit DS18B20_Reset(void) {
  bit flag;
  DS18B20_DQ = 0;
  empty_loop(240);
  DS18B20_DQ = 1;
  empty_loop(40);
  flag = DS18B20_DQ;
  empty_loop(200);
  return flag;
}

void DS18B20_WriteData(U8 wData) {
  U8 i, j;
  for (i = 8; i > 0; i--) {
    DS18B20_DQ = 0;
    for (j = 2; j > 0; j--)
      ;
    DS18B20_DQ = wData & 0x01;
    for (j = 30; j > 0; j--)
      ;
    DS18B20_DQ = 1;
    wData >>= 1;
  }
}

U8 DS18B20_ReadData(void) {
  U8 i, j, s = 0;
  for (i = 8; i > 0; i--) {
    s >>= 1;
    DS18B20_DQ = 0;
    for (j = 2; j > 0; j--)
      ;
    DS18B20_DQ = 1;
    for (j = 4; j > 0; j--)
      ;
    if (DS18B20_DQ == 1)
      s |= 0x80;
    for (j = 30; j > 0; j--)
      ;
    DS18B20_DQ = 1;
  }
  return s;
}
