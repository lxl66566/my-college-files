#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void handle_fork(int i, char letter) {
  switch (i) {
  case -1:
    printf("fork failed\n");
    exit(1);
  case 0:
    // 子进程
    printf("%c", letter);
    exit(0);
  default:
    // 父进程
    break;
  }
}

int main() {
  int i = fork();
  handle_fork(i, 'B');
  i = fork();
  handle_fork(i, 'C');
  printf("A");
  fflush(stdout);
  return 0;
}

// 执行结果：
// ACB: 63,
// ABC: 37