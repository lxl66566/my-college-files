#include "delay.h"
#include "ftl.h"
#include "lcd.h"
#include "malloc.h"
#include "nand.h"
#include "pcf8574.h"
#include "sdio_sdcard.h"
#include "sdram.h"
#include "string.h"
#include "sys.h"
#include "text.h"
#include "usart.h"
#include "usbh_usr.h"

USBH_HOST USB_Host;
USB_OTG_CORE_HANDLE USB_OTG_Core_dev;
extern HID_Machine_TypeDef HID_Machine;

void USBH_Msg_Show(u8 msgx) {
  POINT_COLOR = RED;
  if (!msgx)
    LCD_Fill(0, 150, lcddev.width, lcddev.height, WHITE);
}
// HID 重新连接
void USBH_HID_Reconnect(void) {
  // 关闭之前的连接
  USBH_DeInit(&USB_OTG_Core_dev, &USB_Host); // 复位 USB HOST
  USB_OTG_StopHost(&USB_OTG_Core_dev);       // 停止 USBhost
  if (USB_Host.usr_cb->DeviceDisconnected)   // 存在，才禁止
  {
    USB_Host.usr_cb->DeviceDisconnected(); // 关闭 USB 连接
    USBH_DeInit(&USB_OTG_Core_dev, &USB_Host);
    USB_Host.usr_cb->DeInit();
    USB_Host.class_cb->DeInit(&USB_OTG_Core_dev, &USB_Host.device_prop);
  }
  USB_OTG_DisableGlobalInt(&USB_OTG_Core_dev); // 关闭所有中断
  // 重新复位 USB
  __HAL_RCC_USB_OTG_FS_FORCE_RESET(); // USB OTG FS 复位
  delay_ms(5);
  __HAL_RCC_USB_OTG_FS_RELEASE_RESET(); // 复位结束
  memset(&USB_OTG_Core_dev, 0, sizeof(USB_OTG_CORE_HANDLE));
  memset(&USB_Host, 0, sizeof(USB_Host));
  // 重新连接 USB HID 设备
  USBH_Init(&USB_OTG_Core_dev, USB_OTG_FS_CORE_ID, &USB_Host, &HID_cb,
            &USR_Callbacks);
}

typedef struct {
  u16 x, y, l, w;
  u8 index;
} rect;

typedef struct {
  u16 x;
  u16 y;
  u16 r;
} circle;

const u16 areax = 460;                     // 显示区域 x 440
const u16 areay = 700 - 20;                // 显示区域 y700
const u16 edge = 3;                        // 纵向下落区域的间隔
const u16 rr = (areax / 4 - edge * 2) / 2; // 根据宽度计算半径
const u16 rect_area_height = 12;           // 矩形区域高
const u16 rect_area_gap = 2;               // 矩形边界与区域的间隔
const u16 string_pos_y = areay + rr + rect_area_height + 1; // 显示信息的纵坐标

// 转换 index 到横坐标起点，index = 0~3
u16 map_index_x(u16 index) { return 5 + areax / 4 * index + edge; }

void initCircle(circle *c, u8 index) {
  c->x = map_index_x(index) + c->r;
  c->y = edge + c->r;
  c->r = rr;
}
void clear_circle(circle *c) {
  LCD_Fill(c->x - c->r, c->y - c->r, c->x + c->r, c->y + c->r, WHITE);
}
void draw(circle *c) { LCD_Draw_Circle(c->x, c->y, c->r); }
void drop(circle *c) {
  clear_circle(c);
  c->y += 6;
  draw(c);
  delay_us(2000);
}

u8 map_str_index(u8 *str) { // 将键盘信息映射为整数，方便数组索引
  str[2] = 0;               // 取前两位
  if (strcmp(str, "61") == 0) // A
    return 0;
  else if (strcmp(str, "73") == 0) // S
    return 1;
  else if (strcmp(str, "35") == 0) // Num4
    return 2;
  else if (strcmp(str, "36") == 0) // Num5
    return 3;
  else
    return 4;
}

// 显示得分
void show_score(u32 score) {
  u8 score_buf[10];
  sprintf((char *)score_buf, "%u", score);
  LCD_ShowString(250, string_pos_y, 200, 16, 16, score_buf);
}
// 移动矩形
void rect_move(rect *r) {
  LCD_Fill(r->x, r->y, r->x + r->w, r->y + r->l, WHITE);
  r->x = map_index_x(r->index) + rect_area_gap;
  r->y = areay + rr - 1;
  r->l = rect_area_height - 2 * rect_area_gap;
  r->w = rr * 2;
  LCD_DrawRectangle(r->x, r->y, r->x + r->w, r->y + r->l);
}
void draw_line(u16 y) { LCD_DrawLine(0, y, areax, y); } // 画线

int main(void) {
  Stm32_Clock_Init(384, 25, 2, 8); // 设置时钟，192Mhz
  delay_init(192);                 // 初始化延时函数
  uart_init(115200);               // 初始化 USART
  SDRAM_Init();                    // SDRAM 初始化
  LCD_Init();                      // LCD 初始化
  PCF8574_Init();                  // 初始化 PCF8574
  AT24CXX_Init();
  POINT_COLOR = RED;
  // 初始化 USB 主机
  USBH_Init(&USB_OTG_Core_dev, USB_OTG_FS_CORE_ID, &USB_Host, &HID_cb,
            &USR_Callbacks);

  u32 score = 0;  // 得分
  u8 index = 0;   // 圆形在哪个区域
  _Bool flag = 0; // 当前圆形是否结束
  circle now; // 同一时刻只会有一个圆形；注意不能使用 malloc，至少需要 mymalloc
  rect press_rect;
  u8 buf[4]; // 键盘字符

  show_score(score);
  rect_move(&press_rect);
  LCD_ShowString(200, string_pos_y, 50, 16, 16, "score");
  LCD_ShowString(10, string_pos_y, 40, 16, 16, "key");
  draw_line(string_pos_y - 2);
  while (1) {
    USBH_Process(&USB_OTG_Core_dev, &USB_Host);
    if (bDeviceState == 1) // 连接建立了
    {
      if (USBH_Check_HIDCommDead(&USB_OTG_Core_dev, &HID_Machine))
        // 检测 USB HID 通信，是否还正常？
        USBH_HID_Reconnect();
    } else // 连接未建立的时候，检测
    {
      if (USBH_Check_EnumeDead(&USB_Host))
        // 检测 USB HOST 枚举是否死机了？死机了，则重新初始化
        USBH_HID_Reconnect();
    }
    AT24CXX_Read(0, (u8 *)buf, 4); // 读取 buf 的值
    LCD_ShowString(50, string_pos_y, 40, 16, 16, buf);
    u8 temp = map_str_index(buf);
    if (temp < 4 && press_rect.index != temp) { // 移动矩形
      press_rect.index = temp;
      rect_move(&press_rect);
    }
    if (!flag) { // 没有圆形则生成圆形
      flag = 1;
      index = rand() % 4;
      initCircle(&now, index);
      draw(&now);
    } else
      drop(&now);
    if (now.y >= areay - rect_area_height + rect_area_gap) { // 触线
      clear_circle(&now);
      flag = 0;
      if (map_str_index(buf) == index)
        ++score;
      else if (score > 0)
        --score;
      show_score(score);
    }
  }
}
