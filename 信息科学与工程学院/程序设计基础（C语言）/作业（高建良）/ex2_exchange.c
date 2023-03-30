#include <stdio.h>
void swap(float *a,float *b)
{
	float f = *a;*a = *b;*b = f;
}
int main()
{
	float x,y;
	printf("请输入x的值:");
	scanf("%f",&x);
	printf("请输入y的值:");
	scanf("%f",&y);
	printf("交换前x的值为:%.2f,y的值为:%.2f\n",x,y);
	swap(&x,&y);
	printf("交换后x的值为:%.2f,y的值为:%.2f",x,y);
    return 0;
}
