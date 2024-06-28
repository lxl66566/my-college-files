#include <stdio.h>
int gcd(int x,int y){return y == 0 ? x : gcd(y,x % y);} 
int main()
{
	printf("请输入两个正整数:");
	int a,b;
	scanf("%d%d",&a,&b);
	int i = gcd(a,b);
	printf("%d,%d的最大公约数为%d\n%d%d的最小公倍数为%d",a,b,i,a,b,a * b / i);
	return 0;
 } 
