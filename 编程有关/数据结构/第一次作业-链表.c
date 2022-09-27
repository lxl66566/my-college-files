#include <stdio.h>
#include <malloc.h>
struct node
{
    int data;
    int size; // 记录链表长度
    struct node* next;
    struct node* tail;  // 为降低尾插法的时间复杂度，此处设置记录链表尾节点
};
struct node *a_head,*b_head,*c_head,*d_head;

int head_insert(struct node *head,int temp)
{
    struct node *p;
    p = (struct node*) malloc(sizeof(struct node));
    p->data = temp;
    p->next = head->next;
    head->next = p;
    head->size ++;
    if(head->tail == head)
        head->tail = p;
    return temp;
}
int tail_insert(struct node *head,int temp)
{
    struct node *p;
    p = (struct node*) malloc(sizeof(struct node));
    p->data = temp;
    head->tail->next = p;
    head->tail = p;
    head->size ++;
    return temp;
}
void make_list(struct node *head,int a[],int size)
{
    for(int i = 0;i < size; ++i){
        tail_insert(head,a[i]);
    }
}
struct node* merge_two_list_to_one_list(struct node *x_head,struct node *y_head,struct node *z_head,int reverse)//reverse = 0 , 正序，为1则逆序
{
    struct node *x = x_head->next,*y = y_head->next;
    int x_temp = 1,y_temp = 1;
    while(x_temp <= x_head->size && y_temp <= y_head->size)
    {
        if(x->data < y->data)
        {
            if(reverse) head_insert(z_head,x->data);
            else tail_insert(z_head,x->data);
            x = x->next;
            ++ x_temp;
        }
        else
        {
            if(reverse) head_insert(z_head,y->data);
            else tail_insert(z_head,y->data);
            y = y->next;
            ++ y_temp;
        }
    }
    while (x_temp <= x_head->size)
    {
        if(reverse) head_insert(z_head,x->data);
        else tail_insert(z_head,x->data);
        x = x->next;
        ++ x_temp;
    }
    while (y_temp <= y_head->size)
    {
        if(reverse) head_insert(z_head,y->data);
        else tail_insert(z_head,y->data);
        y = y->next;
        ++ y_temp;
    }
    return z_head;
}// 时间复杂度分析：O(n)
void print_a_list(struct node *x)
{
    int i = x->size;
    printf("size:%d | ", i);
    x = x->next;
    while (i--)
    {
        printf("%d ",x->data);
        x = x->next;
    }
    printf("\n");
    // while((x = x->next)) printf("%d ",x->data);
    // printf("\n");
}
struct node * reverse(struct node* head,struct node * ans) // 就地逆置算法
{
    ans->tail = ans;
    ans->size = 0;
    struct node *x = head;
    for (int i = 0; i < head->size; i++){
        x = x->next;
        head_insert(ans,x->data);
    }
    return ans;
}
void del_node(struct node *head,struct node *x,struct node * pre)
{
    pre->next = x->next;
    head->size--;
    if(x == head->tail) head->tail = pre;
    free(x);
}
struct node * cut(struct node * head,int mink,int maxk) // 有序列表删除元素
{
    struct node *x = head->next,*pre = head,*node_next;
    while(x->data <= mink) pre = x,x = x->next;
    while(x->data < maxk)
    {
        node_next = x->next;
        del_node(head,x,pre);
        x = node_next;
    }
    return head;
}
int main()
{
    int a[3] = {1,4,6};int b[3] = {2,3,5};
    a_head = (struct node*) malloc(sizeof(struct node));
    a_head->tail = a_head;
    a_head->size = 0;
    b_head = (struct node*) malloc(sizeof(struct node));
    b_head->tail = b_head;
    b_head->size = 0;
    c_head = (struct node*) malloc(sizeof(struct node));
    c_head->tail = c_head;
    c_head->size = 0;
    d_head = (struct node*) malloc(sizeof(struct node));
    d_head->tail = d_head;
    d_head->size = 0;
    make_list(a_head,a,3);
    make_list(b_head,b,3);
    merge_two_list_to_one_list(a_head,b_head,c_head,0); // 顺序合并
    print_a_list(c_head);
    // c_head = (struct node*) malloc(sizeof(struct node));
    merge_two_list_to_one_list(a_head,b_head,d_head,1); // 逆序合并
    print_a_list(d_head);
    struct node *n = (struct node*) malloc(sizeof(struct node));
    reverse(b_head,n);   // 就地逆置
    print_a_list(n);
    n = cut(c_head,2,5); // 删除元素。时间复杂度：O(n)
    print_a_list(n);
    return 0;
}
