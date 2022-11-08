#include <stdio.h>
#include <string.h>
const int MAXN = 50;
char a[MAXN],stack[MAXN];
int n;
void push_char(char c)
{
    if(n < MAXN)
    {
        stack[n] = c;
        n++;
    }
}
void pop_char()
{
    if(n > 0) n--;
}
char top()
{
    if(n == 0) return 0; // empty stack
    return stack[n-1];
}
int main()
{
    scanf("%s",a);
    char c = a[0];
    for(int i = 1; i < MAXN && c != '\0'; i++)
    {
        push_char(c);
        c = a[i];
    }
    int flag = 1;   // 1 回文 0 不回文
    for(int i = 0; i < MAXN && top() != 0; i++)
    {
        if(top() != a[i]){flag = 0;break;}
        pop_char();
    }
    if(flag) printf("回文");
    else printf("不回文");
    return 0;
}