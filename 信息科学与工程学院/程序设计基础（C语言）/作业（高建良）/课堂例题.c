#include <stdio.h>
#include <stdlib.h>
#define N 4
int i,j;
int  a[4][4]={{0,1},{2,4},{5,8}},(*p)[4]=a;

int main()
{
	printf("%d %d %d %d",*a[1]+1,*(++p)+1,a[2][2],p[1][1]);
    return 0;
}
