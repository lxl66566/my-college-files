#coding=utf-8
from math import gcd
a = list(map(int,input('请输入两个正整数：').split()))
b = gcd(a[0],a[1])
print(f'通过程序求得{a[0]},{a[1]}的最大公约数为{b}')
print(f'{a[0]},{a[1]}的最小公倍数为{a[0] * a[1] // b}')