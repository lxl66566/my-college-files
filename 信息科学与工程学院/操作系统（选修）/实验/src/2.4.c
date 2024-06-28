#include <stdio.h>
#include <unistd.h>
int main() {
  int x;
  while ((x = fork()) == -1)
    ;
  if (x > 0)
    printf("b");
  else
    printf("a");

  printf("c");
}

// 100 次运行结果：
// bcac: 100