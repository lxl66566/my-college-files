#import "template.typ": *


#show: project.with(
  title: "实验三 进程间管道通信",
  authors: (
    "absolutex",
  )
)

#align(right)[21012792 刘宣乐]

+ *实验目的*
  - 理解Linux系统中进程管道通信的基本原理及实现。


+	实验内容：
  + 编写一个程序，建立一个管道pipe，同时父进程生成一个子进程，子进程向管道pipe中写入一字符串，父进程从pipe中读出该字符串，并每隔3秒输出打印一次。
    #include_code("src/3.1.c")
    - 运行结果：程序每 3 秒钟输出一次 `receive: subprocess here\n`.
    - 解释说明：每三秒子进程向管道发送一次消息，每三秒父进程接收并打印。
  + 进程的管道通信: 编制一段程序,实现进程的管道通信。使用系统调用`pipe()`建立一条管道线;两个子进程`P1`和`P2`分别向管道各写一句话: `Child1 is sending a message! Child2 is sending a message!`而父进程则从管道中读出来自于两个子进程的信息,显示在屏幕上。要求父进程先接收子进程`P1`发来的消息,然后再接收子进程`P2`发来的消息。
    #include_code("src/3.2.c")
    - 运行结果：重复运行 100 次，全部输出均为 
      ```
      receive: Child1 is sending a message!
      receive: Child2 is sending a message!
      ```
    - 解释说明：此处控制先接收子进程`P1`发来的消息的方法是信号量，而不是`lockf`。由于本题只能使用一条管道，而管道一定是 FIFO 的，因此父进程无法选择性接收某一子进程消息。想要让输出有序，必须在发送端确定发送次序。