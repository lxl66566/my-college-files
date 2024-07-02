#include "display.h"
#include "hd7279.h"
#include "key.h"
#include "led.h"
#include "motor.h"
#include "temperature.h"
#include "timer.h"
#include "utils.h"
#include <REG52.H>
#include <intrins.h>

void display_menu();

// 其他 不在 main menu 中
// 0 - tp 温度检测
// 1 - run 电机测试
// 2 - Con 电机调速
// 3 - PA 参数设置
unsigned char menu = 0;
const unsigned char MENU_ITEMS_NUM = 4;

int main(void) {
  U8 i;
  timer_init(6000000);
  hd7279_init();
  temperature_init();
  // display_menu();
  do {
    display_main_loop();
    // if (key_pressed()) {
    //   switch (last_key) {
    //   case KEY_DOWN:
    //     overflow_add1(&menu, MENU_ITEMS_NUM);
    //     break;
    //   case KEY_UP:
    //     overflow_sub1(&menu, MENU_ITEMS_NUM);
    //     break;
    //   default:
    //     display("err");
    //   }
    //   display_menu();
    // }
    set_duty_cycle(i);
    overflow_add1(&i, 100);
    display_number(i);
    delay_ms(2000);
  } while (1);
}

void display_menu() {
  switch (menu) {
  case 0:
    display("tp");
    break;
  case 1:
    display("run");
    break;
  case 2:
    display("Con");
    break;
  case 3:
    display("PA");
    break;
  default:
    return;
  }
}