#include <stdio.h>
#include <string.h>
int i,j;
void swap(char* a,char*b){char temp = *a;*a = *b;*b = temp;}
//由键盘输入长度不超过80的字符串，再原样输出。
void samestr()
{
	char c[82];
	gets(c);
	puts(c);
}

//字符串逆序
void reverse()
{
	char c[82];
	gets(c);
	int n = strlen(c) - 1;		//去除\0 
	for(i = 0;i < n;++i,--n) swap(&c[i],&c[n]);
	puts(c);
}

//字符串的加密解密
void encrypt()
{
	char c[82];
	gets(c);
	for(i = 0;i < strlen(c) -1;++i) c[i] += 5;//加密 
	puts("加密后的字符串：");
	puts(c);
	for(i = 0;i < strlen(c) -1;++i) c[i] -= 5;//解密 
	puts("解密后的字符串：");
	puts(c);
}

//编写程序，实现通讯录查询功能
void search()
{
	char c[82][82] = {},f[82];
	int n = 0,find = 0;
	puts("请输入需要记录的名字，电话号码，以00作为结束信号：");
	c[n][0] = 1;
	while(c[n][0] != '0' || c[n][1] != '0')
		gets(c[++n]);
	puts("请输入若干个需要查找的手机号或姓名：");
	while(1)
	{
		find = 0;
		gets(f);
		for(i = 1;i <= n;++i)
		{
			if(strstr(c[i],f) != NULL)
			{
				printf("您需要查找的信息可能是：");
				puts(c[i]);
				find = 1;
				break;
			}
		}
		if(!find) puts("未查找到该信息！");
	}
	
}

int main()
{
//	samestr();
//	reverse();
//	encrypt();
	search();
	return 0;
}

