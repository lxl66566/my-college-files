#include <stdio.h>
float* swap(float *a,float *b)
{
	float f = *a;*a = *b;*b = f;
	return a;
}
int main()
{
	float x,y,z;
	printf("请输入第一条边边长:");
	scanf("%f",&x);
	printf("请输入第二条边边长:");
	scanf("%f",&y);
	printf("请输入第三条边边长:");
	scanf("%f",&z);
	
//	if(x > y) swap(&x,&y);
//	if(y > z)
//	{
//		if()
//	}
	if(x + y <= z || x + z <= y || y + z <= x)
		printf("此三条边不能组成一个三角形");
	else if(x * x + y * y == z * z || x * x == y * y + z * z || y * y == x * x + z * z)
		printf("此三条边能组成一个直角三角形");
	else if(x == y && y == z) 
		printf("此三条边能组成一个等边三角形");
	else if(x == y || y == z)
		printf("此三条边能组成一个等腰三角形");
	else printf("此三条边能组成一个普通三角形");
//	else if(x * x + y * y < z * z)
//		printf("此三条边能组成一个钝角三角形");
//	else  printf("此三条边能组成一个锐角三角形");
    return 0;
}
