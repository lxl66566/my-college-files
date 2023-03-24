#include <stdio.h>
double a,b;
int main()
{
	printf("请输入华氏温度:");
	scanf("%lf",&a);
	b = (a - 32) * 5.0 / 9.0;
	printf("对应的摄氏温度为:%.1lf",b);
	return 0;
}
