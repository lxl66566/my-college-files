#include <stdio.h>
#include <unistd.h>
int main() {
  int i;
  i = fork();
  if (i == 0) {
    /* 子进程执行 */
    printf("This is child process\n");
  } else {
    /* 父进程执行 */
    printf("This is parent process\n");
  }
}

// 运行结果（已重复多次）：
// This is parent process
// This is child process