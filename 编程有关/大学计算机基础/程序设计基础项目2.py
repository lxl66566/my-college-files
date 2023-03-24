#!/usr/bin/python3
#!coding=utf-8
import qrcode
import os
import image
from turtle import*
from math import*
bili = 200

def dr(t):
    goto(bili * cos(2 * t) * cos(t), bili * cos(2 * t) * sin(t))

print("*1个人信息二维码 *2四叶草的动态绘制\n*3自动关机小程序 *4师生举行募捐活动")
while 1:
    xz = int(input("请输入您的选择（输入0退出）"))
    if xz == 4:
        answ = 0
        for i in range(0,4):
            juankuan = int(input("请输入您的捐款："))
            answ += juankuan
        answ /= 4
        print("捐款人数为4，平均金额为%.1f" %answ)
    elif xz == 1:
        # qr = qrcode.QRCode(
        #    version = 3,
        #    error_correction = qrcode.constants.ERROR_CORRECT_Q,
        #    box_xize = 10,
        #    border = 4
        # qr.make(fit = True)
        # img = qr.make_image(fill_color = "black",back_color = "white")
        # img.show()
        img = qrcode.make("")
        img.show()
    elif xz == 3:
        time = int(input("您希望多少秒后关机："))
        shutdown = "shutdown -s -t " + str(time)
        os.system(str(shutdown))
        cancle = input("是否取消关机Y/N:")
        if cancle == "Y" :
            os.system("shutdown -a")
    elif xz == 2:
        setup(600,600)
        pencolor("red")
        speed(1)
        t = 0
        penup()
        dr(t)
        pendown()
        while t <= 2 * pi:
            t += 0.01
            dr(t)
    elif xz == 0:
        exit()