#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
int main() {
  int i = fork();
  if (i == -1) {
    printf("fork failed\n");
    return 1;
  } else if (i == 0) {
    // 子进程
    printf("B%d ", i);
  } else {
    // 父进程
    wait(NULL); // 等待子进程结束
    printf("A%d ", i);
  }
}

// 运行结果：B0 A23133
// 执行结果符合：子进程先输出，然后父进程再输出