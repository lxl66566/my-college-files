#include <stdio.h>
int a = 0,b = 1,c = 0;
int F()
{
	a = b,b = c;
	return c = a + b;
}
int main()
{
	int i;
	for(i = 0;i < 4;++i)
	{
		int j = 0;
		for(j = 0;j < 5;++j)
			printf("%d\t",F());
		printf("\n");
	}
	return 0;
}

