#include <stdio.h>
#include <malloc.h>
struct node
{
    int data;
    struct node *ls;
    struct node *rs;
}*root;

struct node* find(struct node *n,int x)   // n: now node
{
    if(n == NULL) return NULL;
    if(n->data == x) return n;
    else if(n->data > x) return find(n->ls,x);
    else return find(n->rs,x);
}

void findnode(int x)
{
    struct node* ans;
    ans = find(root,x);
    if(ans!= NULL)
    {
        printf("已找到值：%d，地址为%p\n",ans->data,ans);
    }
    else printf("未找到值：%d\n",x);
}

int main()
{
    root = (struct node*) malloc(sizeof(struct node));
    root->data = 3;
    root->ls = (struct node*) malloc(sizeof(struct node));
    root->ls->data = 1;
    root->ls->ls = NULL;
    root->ls->rs = NULL;
    root->rs = (struct node*) malloc(sizeof(struct node));
    root->rs->data = 5;
    root->rs->ls = (struct node*) malloc(sizeof(struct node));
    root->rs->ls->data = 4;
    root->rs->ls->ls = NULL;
    root->rs->ls->rs = NULL;
    root->rs->rs = (struct node*) malloc(sizeof(struct node));
    root->rs->rs->data = 7;
    root->rs->rs->ls = NULL;
    root->rs->rs->rs = NULL;
/*
        3
       / \
      1   5
         / \
        4   7
*/
    findnode(5);
    findnode(1);
    findnode(4);
    findnode(7);
    findnode(3);
    findnode(2);
    findnode(6);
}