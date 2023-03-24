#!/usr/bin/python3
# coding=utf-8
import random

#print()
a = input("请输入您的选择1、2或其它:")

if a == "1":
    b = float(input("请输入红包金额:"))
    c = int(input("请输入红包个数:"))
    print("红包总金额为:",b*c)
elif a == "2":
    b = int(input("请输入您的猜测:"))
    c = random.randint(1,6)
    if b == c:
        print("恭喜，您猜对了！")
    elif b > c:
        print("您猜大了,色子数是",c)
    else: print("您猜小了,色子数是",c)
else: print("您的输入有误！！！")