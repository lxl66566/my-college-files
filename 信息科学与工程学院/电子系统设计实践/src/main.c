#include "display.h"
#include "hd7279.h"
#include "key.h"
#include "led.h"
#include "motor.h"
#include "storage.h"
#include "temperature.h"
#include "timer.h"
#include "uart.h"
#include "utils.h"
#include <reg52.h>

// 函数声明
void tp(void);     // 温度检测
void run(void);    // 电机测试
void con(void);    // 电机调速
void pa_run(void); // 参数设置 run
void pa_con(void); // 参数设置 con
void pa_con_display(const char *prefix);
void calc_duty_by_temperature(void);
// void menu_select(bit position, const char *menu_names[], void
// (*func[])(void), U8 num);
void menu_select_1(void);
void menu_select_2(void);
void menu_adjust(U8 *after, U8 write_adr, U8 limit);

// 降低代码重复率，~~喜欢我宏孩儿吗~~
#define HANDLE_KEY_RETURN(on_exit)                                             \
  case KEY_RETURN:                                                             \
    DISABLE_INTERRUPT;                                                         \
    DISABLE_MOTOR;                                                             \
    clear_display();                                                           \
    on_exit;                                                                   \
    return;

#define HANDLE_KEY_CASE(key, action)                                           \
  case key:                                                                    \
    action;                                                                    \
    break;

#define LOOP_BEGIN(action_on_every_loop_start)                                 \
  do {                                                                         \
    display_main_loop();                                                       \
    action_on_every_loop_start;                                                \
    if (key_pressed()) {                                                       \
      switch (last_key) {

#define LOOP_END(action_on_every_loop_end)                                     \
  }                                                                            \
  }                                                                            \
  action_on_every_loop_end;                                                    \
  }                                                                            \
  while (1)                                                                    \
    ;

// 电机配置
#define MOTOR_INDEX_LIMIT 10
// 电机预设转速的地址就设为它的 index + 1
#define MOTOR_ADR (motor_index + 1)
#define MOTOR_READ_ADR() read_byte(MOTOR_ADR)
#define MOTOR_WRITE_ADR(x) write_byte(x, MOTOR_ADR)
U8 motor_index = 0;

// 用于调整温度上下限参数的值
// con_mode = 0 为调下限，= 1 为调上限
bit con_mode = 0;
#define TEMPERATURE_ADR                                                        \
  (con_mode ? TEMPERATURE_UP_LIMIT_ADR : TEMPERATURE_DOWN_LIMIT_ADR)

// 菜单
#define MENU_ITEMS_NUM 4
const char *code MENU_ITEMS[] = {"tp-", "run-", "con-", "pa-"};
const void (*code func_array[MENU_ITEMS_NUM])(void) = {tp, run, con,
                                                       menu_select_2};
U8 menu_1 = 0;
#define MENU_ITEMS_2_NUM 2
const char *code MENU_ITEMS_2[] = {"run", "con"};
void (*code func_array_2[MENU_ITEMS_2_NUM])(void) = {pa_run, pa_con};
U8 menu_2 = 0;

int main(void) {
  DISABLE_MOTOR;
  timer_init();
  hd7279_init();
  temperature_init();
  UART_Init();
  do {
    menu_select_1();
  } while (1);
}

void code tp(void) {
  send_string_com((unsigned char *)"tp\n");
  LOOP_BEGIN(read_and_display_temperature(1))
  HANDLE_KEY_RETURN()
  LOOP_END()
}

// 电机测试操作
void code run(void) {
  char s[4] = {'r', '-', ' ', 'e'};
  U8 temp;
  ENABLE_MOTOR;
  ENABLE_INTERRUPT;
  send_string_com((unsigned char *)"run");
  LOOP_BEGIN(temp = MOTOR_READ_ADR();)
  HANDLE_KEY_RETURN()
  HANDLE_KEY_CASE(KEY_UP, overflow_add1(&motor_index, MOTOR_INDEX_LIMIT))
  HANDLE_KEY_CASE(KEY_DOWN, overflow_sub1(&motor_index, MOTOR_INDEX_LIMIT))
  LOOP_END(s[3] = motor_index + '0'; display(0, s); display_number(1, temp);
           set_duty_cycle(temp))
}

// 电机调速
void code con(void) {
  send_string_com((unsigned char *)"con\n");
  ENABLE_MOTOR;
  ENABLE_INTERRUPT;
  LOOP_BEGIN(calc_duty_by_temperature())
  HANDLE_KEY_RETURN()
  LOOP_END()
}

// 根据环境温度与上下限，决定电机占空比
void calc_duty_by_temperature(void) {
  U8 pwnow;
  U8 TEMPERATURE_UP = read_byte(TEMPERATURE_UP_LIMIT_ADR),
     TEMPERATURE_DOWN = read_byte(TEMPERATURE_DOWN_LIMIT_ADR);
  U8 temperature = read_and_display_temperature(0);
  pwnow = temperature >= TEMPERATURE_UP ? 100
          : temperature <= TEMPERATURE_DOWN
              ? 0
              : (temperature - TEMPERATURE_DOWN) * 50 /
                        (TEMPERATURE_UP - temperature) +
                    50;
  display_number(1, pwnow);
  set_duty_cycle(pwnow);
}

// run 参数调节
void pa_run(void) {
  U8 temp = MOTOR_READ_ADR();
  clear_display();
  LOOP_BEGIN(display(0, "p- "); display_number(1, temp);
             show_chars[7] = motor_index + '0')
  HANDLE_KEY_RETURN()
  HANDLE_KEY_CASE(KEY_ENTER, display(0, "a- ");
                  show_chars[7] = motor_index + '0';
                  menu_adjust(&temp, MOTOR_ADR, 100))
  HANDLE_KEY_CASE(KEY_UP, overflow_add1(&motor_index, MOTOR_INDEX_LIMIT);
                  temp = MOTOR_READ_ADR())
  HANDLE_KEY_CASE(KEY_DOWN, overflow_sub1(&motor_index, MOTOR_INDEX_LIMIT);
                  temp = MOTOR_READ_ADR())
  LOOP_END()
}

// con 参数调节
void pa_con(void) {
  U8 temp = read_byte(TEMPERATURE_ADR);
  clear_display();
  LOOP_BEGIN(pa_con_display("pa-"); display_number(1, temp))
  HANDLE_KEY_RETURN()
  HANDLE_KEY_CASE(KEY_ENTER, pa_con_display("a- ");
                  menu_adjust(&temp, TEMPERATURE_ADR, 100));
  HANDLE_KEY_CASE(KEY_UP, con_mode = !con_mode;
                  temp = read_byte(TEMPERATURE_ADR))
  HANDLE_KEY_CASE(KEY_DOWN, con_mode = !con_mode;
                  temp = read_byte(TEMPERATURE_ADR))
  LOOP_END()
}
void pa_con_display(const char *prefix) {
  KEY_ENTER, display(0, prefix);
  show_chars[7] = con_mode ? 'u' : 'd';
}

// 该函数已废弃，有栈溢出的问题
// 显示菜单函数，选择菜单位置，菜单的名字与选择菜单后的执行函数，菜单的大小。
// 执行的函数必须是阻塞的，每个函数都必须自己处理 key。
// menu_select 函数本身是阻塞的，按下 RETURN key 可以从此函数返回。
//
// 调用方法：
// menu_select(0, MENU_ITEMS, func_array, MENU_ITEMS_NUM);
//
//
// void menu_select(bit position, const char *menu_names[], void
// (*func[])(void),
//                  U8 num) {
//   // U8 menu = 0; // 堆栈溢出，menu 值被覆盖！！
//   LOOP_BEGIN(display(position, menu_names[menu]))
//   HANDLE_KEY_RETURN()
//   HANDLE_KEY_CASE(KEY_UP, overflow_add1(&menu, num);
//                   send_number_com(menu))
//   HANDLE_KEY_CASE(KEY_DOWN, overflow_sub1(&menu, num);
//                   send_number_com(menu))
//   HANDLE_KEY_CASE(KEY_ENTER, send_number_com(menu);
//                   func[menu](); send_number_com(menu););
//   LOOP_END()
// }

// 主菜单
void menu_select_1(void) {
  LOOP_BEGIN(display(0, MENU_ITEMS[menu_1]))
  HANDLE_KEY_RETURN()
  HANDLE_KEY_CASE(KEY_UP, overflow_add1(&menu_1, MENU_ITEMS_NUM);
                  send_number_com(menu_1))
  HANDLE_KEY_CASE(KEY_DOWN, overflow_sub1(&menu_1, MENU_ITEMS_NUM);
                  send_number_com(menu_1))
  HANDLE_KEY_CASE(KEY_ENTER, send_number_com(menu_1); func_array[menu_1]();
                  send_number_com(menu_1););
  LOOP_END()
}

// PA 菜单
void menu_select_2(void) {
  LOOP_BEGIN(display(1, MENU_ITEMS_2[menu_2]))
  HANDLE_KEY_RETURN()
  HANDLE_KEY_CASE(KEY_UP, overflow_add1(&menu_2, MENU_ITEMS_2_NUM);
                  send_number_com(menu_2))
  HANDLE_KEY_CASE(KEY_DOWN, overflow_sub1(&menu_2, MENU_ITEMS_2_NUM);
                  send_number_com(menu_2))
  HANDLE_KEY_CASE(KEY_ENTER, send_number_com(menu_2); func_array_2[menu_2]();
                  send_number_com(menu_2););
  // return 会清除全屏，因此把上一层菜单继续拿来显示
  LOOP_END(display(0, MENU_ITEMS[menu_1]))
}

// 数值调整菜单
void menu_adjust(U8 *num, U8 write_adr, U8 limit) {
  U8 temp = *num;
  LOOP_BEGIN(display_number(1, temp))
  HANDLE_KEY_RETURN()
  HANDLE_KEY_CASE(KEY_ENTER, *num = temp; write_byte(temp, write_adr); return)
  HANDLE_KEY_CASE(KEY_UP, saturate_add1(&temp, limit); send_number_com(temp))
  HANDLE_KEY_CASE(KEY_DOWN, saturate_sub1(&temp, 0); send_number_com(temp))
  LOOP_END()
}