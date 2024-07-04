#include "motor.h"
#include "display.h"
#include "led.h"
#include "utils.h"

// 折算系数，越大占空比结果越不精确，但是定时器频率要求越低
#define DUTY_RATE 4
#define DUTY_LIMIT (100 / DUTY_RATE)
// #define DUTY_LIMIT 100
U8 dutyCycle = DUTY_LIMIT / 2; // 初始占空比为50%
U8 counter = 0;

// sdcc
void Timer0_ISR(void) interrupt 1 {
  // overflow_add1(&counter, DUTY_LIMIT);
  // display_number(0, counter);
  // if (counter < dutyCycle) {
  //   ENABLE_MOTOR;
  //   ENABLE_LED;
  // } else {
  //   DISABLE_MOTOR;
  //   DISABLE_LED;
  // }
  // ENABLE_LED;
  // delay_ms(50);
  // DISABLE_LED;
  // counter += 1;
  P2 = !P2;
}

void set_duty_cycle(unsigned char dc) {
  dc /= DUTY_RATE;
  if (dc <= DUTY_LIMIT) {
    dutyCycle = dc;
  } else {
    display(0, "err");
  }
}