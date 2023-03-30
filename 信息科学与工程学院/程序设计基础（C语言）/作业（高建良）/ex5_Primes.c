#include <stdio.h>
#define zssize 200
int zs[zssize] = {1,1,0,0};//0 质数  1 非质数 
void makelist()
{
	int i,j;
	for(i = 2;i < zssize / 2;++i)
	{
		if(!zs[i]) for(j = i + i;j < zssize;j += i) zs[j] = 1;
	}
}

int main()
{
	int i = 0,j = 0,s = 2;
	makelist();
	while(s <= 150)
	{
		if(!zs[s])
		{
			printf("%d\t",s);
			++i;
			if(i > 6)
			{
				printf("\n");
				i = 0;
			}
		}
		++s;
	}
	return 0;
}

