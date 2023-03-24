#include <stdio.h>
#include <string.h>
#include <math.h>
int i,j;
//在  C程序设计(2021).ppt 中缺乏　指针　课堂例题。

//求下列分段函数的函数值：

int jc(int x)
{
	if(x == 1) return 1;
	else return x * jc(x - 1);
}

double f(double x)
{
	if(x < 0) return x * x;
	else if(x >= 0 && x < 1) return sqrt(x);
	else return (double) jc((int) x);
} 

int main()
{
	double x;
	scanf("%lf",&x);
	double (*h) (double);
	h = f;
	double s = (*h)(x);
	printf("%lf",s);
	return 0;
}

