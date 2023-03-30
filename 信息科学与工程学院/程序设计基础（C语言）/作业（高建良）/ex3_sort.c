#include <stdio.h>
long* swap(long *a,long *b)
{
	long f = *a;*a = *b;*b = f;
	return a;
}
int main()
{
	long x,y,z;
	printf("请输入三个长整型整数:");
	scanf("%ld%ld%ld",&x,&y,&z);
	printf("排序前三个数为:x=%ld,y=%ld,z=%ld\n",x,y,z);
	if(x > y) swap(&x,&y);
		if(y > z)
		{
			if(x > z) swap(swap(&y,&z) , &x);
			else swap(&y,&z);
		}
	printf("排序后三个数为:x=%ld,y=%ld,z=%ld",x,y,z);
    return 0;
}
