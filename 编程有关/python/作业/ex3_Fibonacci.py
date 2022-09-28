#coding=utf-8
i , j = 0,1
while(j <= 100):
    if j != 89:
        print(j,end=',')
    else:
        print(j)
    k = i + j
    i,j = j,k