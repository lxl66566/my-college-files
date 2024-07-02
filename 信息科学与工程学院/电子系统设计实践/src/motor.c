#include "motor.h"
#include "utils.h"

// 折算系数，越大占空比结果越不精确，但是定时器频率要求越低
#define DUTY_RATE 4
U8 dutyCycle = 50 / DUTY_RATE; // 初始占空比为50%

void Timer0_ISR(void) interrupt 1 {
  static unsigned char counter = 0;
  overflow_add1(&counter, DUTY_RATE);
  if (counter < dutyCycle) {
    MOTOR = 1; // 电机开
  } else {
    MOTOR = 0; // 电机关
  }
}

void set_duty_cycle(unsigned char dc) {
  dc /= DUTY_RATE;
  if (dc <= 100 / DUTY_RATE) {
    dutyCycle = dc;
  }
}