#include "24cxx.h"
//... 省略
void USR_KEYBRD_ProcessData(uint8_t data) {
  u8 buf[4];
  sprintf((char *)buf, "%02X", data);
  AT24CXX_Write(0, (u8 *)buf, 4); // 将 buffer 写入 24CXX
}