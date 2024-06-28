#coding=utf-8
import os
from random import randint

def transf(b1) -> str:
    if b1 < 60:
        return 'D'
    elif 60 <= b1 < 70:
        return 'C'
    elif 70 <= b1 < 80:
        return 'B'
    elif 80 <= b1 < 90:
        return 'A'
    elif 90 <= b1 < 95:
        return 'S'
    elif b1 < 100:
        return 'SS'
    else:
        return 'SSS'

if(os.path.exists('ex4_scores.txt')):
    os.remove('ex4_scores.txt')
f1 = open('ex4_scores.txt','a')
for i in range(20):
    f1.write(str(randint(0,100)) + ' ')
f1.close()

f2 = open('ex4_scores.txt','r')
if(os.path.exists('ex4_degrees.txt')):
    os.remove('ex4_degrees.txt')
f3 = open('ex4_degrees.txt','a')

a = list(map(int,f2.read().split()))

for i in range(20):
    s = transf(a[i])
    f3.write(str(a[i]) + ',' + s + '\n')
    print(a[i],s,sep=',',end='\n')

f3.close()
f2.close()