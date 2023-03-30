#coding=utf-8
from math import gcd

def tgcd(a:int,b:int) -> tuple:
    temp = gcd(a,b)
    return (temp,a * b // temp)

a = list(map(int,input('请输入两个正整数：').split()))
print(f'{a[0]}和{a[1]}的最大公约数和最小公倍数分别为：{tgcd(a[0],a[1])}')