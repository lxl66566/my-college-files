#include "display.h"
#include "hd7279.h"
#include "key.h"
#include "led.h"
#include "utils.h"
#include <REG52.H>
#include <intrins.h>
#include <math.h>
#include <stdio.h>

sbit Motor = P1 ^ 2;
void display_menu();

// 其他 不在 main menu 中
// 0 - tp 温度检测
// 1 - run 电机测试
// 2 - Con 电机调速
// 3 - PA 参数设置
unsigned char menu = 0;
const unsigned char MENU_ITEMS_NUM = 4;

int main(void) {
  hd7279_init();
  display_menu();
  while (1) {
    display_main_loop();
    if (key_pressed()) {
      switch (last_key) {
      case KEY_DOWN:
        overflow_add1(&menu, MENU_ITEMS_NUM);
        break;
      case KEY_UP:
        overflow_sub1(&menu, MENU_ITEMS_NUM);
        break;
      default:
        display("err");
      }
      display_menu();
    }
  }
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