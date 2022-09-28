#coding=utf-8
from math import sqrt,acos
mc = ['一','二','三']
a = [0] * 3
for i in range(3):
    a[i] = float(input(f'请输入第{mc[i]}条边边长：'))
a.sort()
if(a[0] + a[1] <= a[2]):
    print("此三条边不能组成一个三角形")
elif(a[0] ** 2 + a[1] ** 2 == a[2] ** 2):
    print("此三条边能组成一个直角三角形")
elif(a[0] ** 2 + a[1] ** 2 < a[2] ** 2):
    print("此三条边能组成一个钝角三角形")
elif(a[0] ** 2 + a[1] ** 2 > a[2] ** 2):
    print("此三条边能组成一个锐角三角形")