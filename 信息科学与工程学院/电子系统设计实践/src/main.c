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

void display_menu(void);

// 0 - tp 温度检测
// 1 - run 电机测试
// 2 - Con 电机调速
// 3 - PA 参数设置
U8 menu = 0;
const unsigned char MENU_ITEMS_NUM = 4;

// 0: 菜单选择界面
// 1: 一级子菜单
U8 layer = 0;

U8 i = 0;

int main(void) {
  timer_init();
  hd7279_init();
  temperature_init();
  DISABLE_MOTOR;
  ENABLE_INTERRUPT;
  // display_menu();
  do {
    // display_main_loop();
    //   display_menu();
    //   if (key_pressed()) {
    //     switch (last_key) {
    //     case KEY_DOWN:
    //       overflow_add1(&menu, MENU_ITEMS_NUM);
    //       break;
    //     case KEY_UP:
    //       overflow_sub1(&menu, MENU_ITEMS_NUM);
    //       break;
    //     default:
    //       display(1, "err");
    //     }
    //     display_address_0x(1, readbyte(0x10));
    //   }
    // read_and_display_temperature();
    // overflow_add1(&i, 100);
    // display_number(1, i);
    // set_duty_cycle(i);
    // delay_ms(5000);

    display_main_loop();
  } while (1);
}

void display_menu(void) {
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
