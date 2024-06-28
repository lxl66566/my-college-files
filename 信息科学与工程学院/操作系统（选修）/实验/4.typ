#import "template.typ": *


#show: project.with(
  title: "实验四 进程调度模拟程序",
  authors: (
    "absolutex",
  )
)

#align(right)[]

+ *实验目的*
  
  理解Linux系统中时间片轮转调度算法。


+	实验内容：

  编写程序完成单处理机系统中的进程调度，要求采用固定时间片轮转调度算法。实验具体包括：首先确定进程控制块的内容，进程控制块的组成方式，然后完成进程创建函数和进程调度函数，最后编写主函数对所做工作进行测试。要求：创建多个进程（所需执行时间不同），按照时间片轮转的调度算法将进程的执行顺序显示出来。程序写在实验报告上，并写出运行结果。

  进程调度模拟程序主要要考虑三个问题:如何组织进程、如何创建进程和如何实现处理器调度。
  为了简化，将进程控制块结构定义如下:
  ```c
  struct pcb
  {
    int name;//进程标识符
    int time ;//进程执行所需时间
  }
  ```
  操作系统的实现中，系统往往在主存中划分出一个连续的专门区域存放系统的进程控制块，实验中应该用数组模拟这个专门的进程控制块区域。

  #include_code("src/4.c")

  执行结果：

  ```
Initial pool:
Queue 0: (0, 7) -> (1, 11)
Queue 1: 
Queue 2: 
Queue 3: 

Run process 0 at time 0
time: 2
Queue 0: (1, 11)
Queue 1: (0, 5)
Queue 2: 
Queue 3: 

Run process 1 at time 2
time: 4
Queue 0: 
Queue 1: (0, 5) -> (1, 9)
Queue 2: 
Queue 3: 

Run process 0 at time 4
time: 7
Queue 0: 
Queue 1: (1, 9)
Queue 2: (0, 2)
Queue 3: 

Run process 1 at time 7
time: 10
Add process 11 in waitlist 1th at time 10
Queue 0: (11, 5)
Queue 1: 
Queue 2: (0, 2) -> (1, 6)
Queue 3: 

Run process 11 at time 10
time: 12
Queue 0: 
Queue 1: (11, 3)
Queue 2: (0, 2) -> (1, 6)
Queue 3: 

Run process 11 at time 12
Finish process 11 at time 15
time: 15
Queue 0: 
Queue 1: 
Queue 2: (0, 2) -> (1, 6)
Queue 3: 

Run process 0 at time 15
Finish process 0 at time 17
time: 17
Add process 12 in waitlist 2th at time 17
Queue 0: (12, 7)
Queue 1: 
Queue 2: (1, 6)
Queue 3: 

Run process 12 at time 17
time: 19
Queue 0: 
Queue 1: (12, 5)
Queue 2: (1, 6)
Queue 3: 

Run process 12 at time 19
time: 22
Queue 0: 
Queue 1: 
Queue 2: (1, 6) -> (12, 2)
Queue 3: 

Run process 1 at time 22
Finish process 1 at time 28
time: 28
Add process 13 in waitlist 3th at time 28
Queue 0: (13, 9)
Queue 1: 
Queue 2: (12, 2)
Queue 3: 

Run process 13 at time 28
time: 30
Queue 0: 
Queue 1: (13, 7)
Queue 2: (12, 2)
Queue 3: 

Run process 13 at time 30
time: 33
Queue 0: 
Queue 1: 
Queue 2: (12, 2) -> (13, 4)
Queue 3: 

Run process 12 at time 33
Finish process 12 at time 35
time: 35
Queue 0: 
Queue 1: 
Queue 2: (13, 4)
Queue 3: 

Run process 13 at time 35
Finish process 13 at time 39
time: 39
Queue 0: 
Queue 1: 
Queue 2: 
Queue 3:
  ```

  该程序还存在一个问题，即当 pool中新增一个进程时，将不会打断低优先级的正在执行中的进程。这是因为在此程序中，时间片并不是离散独立的。