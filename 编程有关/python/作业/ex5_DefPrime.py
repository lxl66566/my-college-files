#coding=utf-8
from math import sqrt,ceil
def prime(a:int) -> bool :
    if a == 2:
        return True
    for i in range(2,ceil(sqrt(a)) + 1):
        if a % i == 0:
            return False
    return True

sum,i = 0,2
while(sum < 30):
    if prime(i):
        print('%7r'%i,end='')
        sum += 1
        if sum % 6 == 0:
            print('')
    i += 1