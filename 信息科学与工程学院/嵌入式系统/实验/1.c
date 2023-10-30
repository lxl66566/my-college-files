// 寄存器版本

#include "sys.h"
#include "delay.h" 
#include "led.h"
int main(void)
{ 
	Stm32_Clock_Init(360,25,2,8);
	delay_init(180);
	LED_Init();
	int d = 5;
	int sist = 7;
	while(1)
	{
		for(int i = 0;i < d;++i)
		{
			for(int _ = 0;_ < sist;++_){
				LED1=0;
				delay_ms(i);
				LED1=1;
				delay_ms(d * 4 - i);
			}
		}
		for(int i = d - 1;i > 0;--i)
		{
			for(int _ = 0;_ < sist;++_){
				LED1=0;
				delay_ms(i);
				LED1=1;
				delay_ms(d * 4 - i);
			}
		}
	}
}
