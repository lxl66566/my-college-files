#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int rd(int l,int r){return rand()%(r - l + 1) + l;}
int a[22],i,v[22],s[22];
void swap(int *j1,int *j2){int temp = *j1;*j1 = *j2;*j2 = temp;}
int erfen(int l,int r)						//归并排序 
{
    if(r - l < 1) return 0;
    if(r - l == 1){if(a[l] > a[r]) swap(a + l,a + r);return 0;}
    int mid = (l + r) / 2;
    erfen(l,mid);
    erfen(mid + 1,r);
    int j = l,k = l,k2 = mid;
    ++mid;
    for(;l <= k2 && mid <= r;)
    {
        if(a[l] < a[mid]){v[j] = a[l];++j,++l;}
        else{v[j] = a[mid];++j,++mid;}
    }
    while(l <= k2){v[j] = a[l];++j,++l;}
    while(mid <= r){v[j] = a[mid];++j,++mid;}
    for(i = k;i <= r;++i) a[i] = v[i];
    return 0;
}
int main()
{
    srand((unsigned) time((time_t*)NULL));
    for(i = 1;i <= 20;++i)
    {
        a[i] = rd(0,999);
        s[i] = a[i];
        printf("%d  ",a[i]);
        if(i % 10 == 0) printf("\n");
    }
    erfen(1,20);

    for(i = 1;i <= 20;++i)
    {
        printf("%d  ",a[i]);
        if(i % 10 == 0) printf("\n");

    }
    return 0;
}
