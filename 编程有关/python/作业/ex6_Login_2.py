from asyncio.windows_events import NULL
import tkinter as tk
from tkinter.messagebox import *
global text1,text2
def welcome():
    showinfo('欢迎','Welcome!')
def wrong():
    showerror('错误','账号或密码有误!')
def pd1():
    if text1.get().strip() == 'abc' and text2.get().strip() == '123456':
        welcome()
    else:
        wrong()
def pd2():
    with open('login.txt','r') as f:
        s = f.readline()
        while s:
            s = s.split()
            if text1.get().strip() == s[0] and text2.get().strip() == s[1]:
                welcome()
                return
            s = f.readline()
        wrong()
win =tk.Tk()
win.title('登录')
win.geometry('200x100')
fm1 = tk.Frame(win)
tk.Label(fm1,text="姓名:").pack(side=tk.LEFT)
text1 = tk.Entry(fm1)
text1.pack(side=tk.LEFT)
fm1.pack(side=tk.TOP)

fm2 = tk.Frame(win)
tk.Label(fm2,text="密码:").pack(side=tk.LEFT)
text2 = tk.Entry(fm2)
text2.pack(side=tk.LEFT)
fm2.pack(side=tk.TOP)
fm3 = tk.Frame(win)
# tk.Label(fm3,text='  ').pack(side=tk.LEFT)
tk.Button(fm3,text="登录",command=pd1).pack(side=tk.LEFT)
tk.Button(fm3,text="登录2",command=pd2).pack(side=tk.LEFT)
tk.Button(fm3,text="退出",command=win.quit).pack(side=tk.LEFT)
fm3.pack(side=tk.TOP)
win.mainloop()