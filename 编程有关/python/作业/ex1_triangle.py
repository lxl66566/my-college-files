#coding=utf-8
from math import sqrt,acos
mc = ['一','二','三']
a = [0] * 3
p = 0
for i in range(3):
    a[i] = float(input(f'请输入第{mc[i]}条边边长：'))
    p += a[i]
p /= 2
print(f'三角形的面积为：{round(sqrt(p * (p - a[0]) * (p - a[1]) * (p - a[2])),1)}')
print(f'角A为{round(acos((a[0] ** 2 + a[1] ** 2 - a[2] ** 2) / (2 * a[0] * a[1])),2)}弧度')