#include "motor.h"
#include "display.h"
#include "led.h"
#include "temperature.h"
#include "timer.h"
#include "utils.h"

// 折算系数，越大占空比结果越不精确，但是定时器频率要求越低
#define DUTY_RATE 2
#define DUTY_LIMIT (100 / DUTY_RATE)
U8 dutyCycle = DUTY_LIMIT / 2; // 初始占空比为50%
U8 counter = 0;

void Timer0_ISR(void) interrupt 1 {
  overflow_add1(&counter, DUTY_LIMIT);
  if (counter < dutyCycle) {
    ENABLE_MOTOR;
    ENABLE_LED;
  } else {
    DISABLE_MOTOR;
    DISABLE_LED;
  }
}

// 设置占空比
void set_duty_cycle(unsigned char dc) {
  ENABLE_INTERRUPT;
  dc /= DUTY_RATE;
  if (dc <= DUTY_LIMIT) {
    dutyCycle = dc;
  } else {
    display(0, "err");
  }
}

// 根据环境温度与上下限，决定电机占空比
void calc_duty_by_temperature(U8 TEMPERATURE_UP, U8 TEMPERATURE_DOWN) {
  unsigned long pwnow;
  unsigned long temperature = read_and_display_temperature(0);
  pwnow = temperature >= TEMPERATURE_UP ? 100
          : temperature <= TEMPERATURE_DOWN
              ? 0
              : (temperature - TEMPERATURE_DOWN) * 50 /
                        (TEMPERATURE_UP - TEMPERATURE_DOWN) +
                    50;
  display_number(1, pwnow);
  set_duty_cycle(pwnow);
}

// PID 全局变量
float previous_error = 0.0;
float integral = 0.0;

// PID 调占空比
void calc_duty_by_pid(struct myfloat expect) {
#define KP (1)
#define KI (1)
#define KD (0.8)
#define DT 0.5 // 时间间隔，根据实际情况进行调整
#define MAX_DUTY 100.0
#define MIN_DUTY 0.0

  float current_temperature, error, derivative, output;
  current_temperature = read_and_display_temperature(0);
  error = to_float(expect) - current_temperature;
  integral += error * DT; // 积分项累积，注意防止积分 wind-up
  // 防止积分过饱和
  if (integral > MAX_DUTY * KI / KP)
    integral = MAX_DUTY * KI / KP;
  else if (integral < MIN_DUTY * KI / KP)
    integral = MIN_DUTY * KI / KP;

  derivative = (error - previous_error) / DT;

  output = 100 - (KP * error + KI * integral + KD * derivative);

  // 限幅操作确保输出在合理范围内
  output = max(min(output, MAX_DUTY), MIN_DUTY);
  set_duty_cycle(output);
  display_number(1, output);
  previous_error = error;
}