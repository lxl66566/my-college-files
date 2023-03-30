#include <stdio.h>
#include <stdlib.h>
int a[20][20],i,j,k;
int main()
{
	a[1][1] = 1;
	for(i = 2;i <= 8;++i)
	{
		a[i][1] = 1;
		for(j = 2;j <= i;++j)
		{
			a[i][j] = a[i - 1][j - 1] + a[i - 1][j];
		}
	}
	for(i = 1;i <= 8;++i)
	{
		for(k = 1;k <= (8 - i);++k) printf("\t");
		for(j = 1;j <= i;++j)
		{
			printf("%d\t\t",a[i][j]);
		}
		printf("\n\n");
	}
    return 0;
}
