#coding=utf-8
a = [1] * 151
for i in range(2,150):
    if a[i] == 1:
        for j in range(i * 2,150,i):
            a[j] = 0
jl = 0
for i in range(2,150):
    if a[i] == 1:
        print(i,end=' ')
        jl += 1
        if jl % 9 == 0:
            print('')