#include <stdio.h>
#include <string.h>
const int DEPTH = 10;
int a[DEPTH],head,tail;    // 使用线性数组模拟环形队列，使用head与tail查看头尾位置
// 有效深度为 DEPTH - 2
char temp;

void add_char(char c)   // add element to a
{
    if((tail - head == DEPTH - 2 && head <= 1) || head - tail == 1)
    {
        printf("cannont insert into a full queue.\n");
        return;
    }
    a[tail] = c;
    tail++;
    if(tail == DEPTH) tail = 0;
    printf("sucessfully inserted %c\n",c);
}

void pop_char()
{
    if(head == tail)
    {
        printf("cannot pop from a empty queue.\n");
        return;
    }
    head ++;
    if(head == DEPTH) head -= DEPTH;
    printf("sucessfully pop char.\n");
}
char front_char()
{
    if(head == tail) return 0;
    return a[head];
}

int main()
{
    while((temp = getchar()) != '\n' && ((temp <= 'z' && temp >= 'a') || (temp <= '9' && temp >= '0')))
    {
        if(temp == ' ') continue;
        if(temp <= 'z' && temp >= 'a')
        {
            if (front_char() != 0)
                printf("pop the front char: %c.\n",front_char());
            pop_char();
        }
        else{
            add_char(temp);
        }
    }
    return 0;
}