#include <stdio.h>
#include <math.h>
double a,b,c,p;
int main()
{
	printf("请输入第一条边边长:");
	scanf("%lf",&a);
	printf("请输入第二条边边长:");
	scanf("%lf",&b);
	printf("请输入第三条边边长:");
	scanf("%lf",&c);
	p = (a + b + c) / 2;
	printf("三角形的面积为:%.1lf\n",sqrt(p * (p - a) * (p - b) * (p - c)));
	printf("角A为%.2lf弧度",acos((b*b + c*c - a*a)/(2 * b * c)));
	return 0;
}
