#include "display.h"
#include "hd7279.h"
#include "key.h"
#include "led.h"
#include "motor.h"
#include "storage.h"
#include "temperature.h"
#include "timer.h"
#include "utils.h"
#include <reg52.h>

// 函数声明
void display_layer_0(void);
void deal_with_key_pressed(void);
void do_by_layer_and_menu(void);
void deal_key_down(void);
void deal_key_up(void);
void deal_key_enter(void);
void do_run(void);

// 菜单
#define MENU_TP 0  // 温度检测
#define MENU_RUN 1 // 电机测试
#define MENU_CON 2 // 电机调速
#define MENU_PA 3  // 参数设置
U8 menu = 0;
const unsigned char MENU_ITEMS_NUM = 4;

// 0: 菜单选择界面
// x: x级子菜单
U8 layer = 0;

// 电机配置
#define MOTOR_INDEX_LIMIT 10
U8 motor_index = 0;

int main(void) {
  U8 i = 0;
  DISABLE_MOTOR;
  timer_init();
  hd7279_init();
  temperature_init();
  display_layer_0();
  do {
    display_main_loop();
    if (key_pressed()) {
      deal_with_key_pressed();
      if (last_key == KEY_UP)
        ++i;
      else
        --i;
      display_number(0, i);
    }
    // do_by_layer_and_menu();
  } while (1);
}

void do_by_layer_and_menu(void) {
  switch (layer) {
  case 0:
    display_layer_0();
    break;
  case 1:
    switch (menu) {
    case MENU_TP:
      read_and_display_temperature(1);
      break;
    case MENU_RUN:
      break;
    default:
      display(1, "err1");
    }
  }
}

void deal_key_up(void) {
  // overflow_add1(&menu, MENU_ITEMS_NUM);
}

void deal_key_down(void) {
  switch (layer) {
  case 0:
    overflow_sub1(&menu, MENU_ITEMS_NUM);
    return;
  case 1:
    switch (menu) {
    case MENU_RUN:
      overflow_sub1(&motor_index, MOTOR_INDEX_LIMIT);
      break;
    }
  }
}

void deal_key_enter(void) {
  switch (layer) {
  case 0:
    ++layer;
    break;
  default:
    break;
  }
}

// 电机测试操作
void do_run(void) {
  char s[4] = {'r', '-', ' ', 'e'};
  s[3] = motor_index + '0';
  display(1, s);
  set_duty_cycle(read_byte(motor_index));
}

// 显示首层 menu
void display_layer_0(void) {
  switch (menu) {
  case 0:
    display(0, "tp-");
    break;
  case 1:
    display(0, "run-");
    break;
  case 2:
    display(0, "Con-");
    break;
  case 3:
    display(0, "PA-");
    break;
  default:
    display(1, "err0");
  }
}

void deal_with_key_pressed(void) {
  switch (last_key) {
  case KEY_RETURN:
    saturate_sub1(&layer, 0);
    DISABLE_INTERRUPT;
    clear_display();
    return;
  case KEY_DOWN:
    deal_key_down();
    break;
  case KEY_UP:
    deal_key_up();
    break;
  case KEY_ENTER:
    deal_key_enter();
    break;
  default:
    display(1, "err");
  }
}