#coding=utf-8
import math
p,c = 1,1
for i in range(1,100):
    p *= i / (2 * i + 1)
    c += p 
print(f'通过级数求和得到Pi的值为：{c * 2}')
print(f'math模块的pi值为：{math.pi}')