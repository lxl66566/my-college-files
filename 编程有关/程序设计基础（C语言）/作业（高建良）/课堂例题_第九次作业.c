#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define N 200
//调整排序数据个数 
int a[N],i,j;
int rd(int l,int r){return rand()%(r - l + 1) + l;}
void swap(int *j1,int *j2){int temp = *j1;*j1 = *j2;*j2 = temp;}		

	//随机数进行冒泡排序 
	//杨辉三角在第九次作业 第一题 
	
int main()
{
	for(i = 1;i <= N;++i)
	{
		a[i] = rd(1,5000);//调整随机数范围 
	}
	for(i = N;i > 1;--i)
		for(j = 1;j < i;++j)
			if(a[j] > a[j + 1]) swap(&a[j],&a[j + 1]);
	
	for(i = 1;i <= N;++i)
		printf("%d ",a[i]);
	return 0;
}

