#include <stdio.h>
int main()
{
	int a;
	printf("请输入一个三位的正整数:");
	scanf("%d",&a);
	printf("百位数为:%d\n十位数为:%d\n个位数为:%d",a / 100,a / 10 % 10,a % 10);
    return 0;
}
