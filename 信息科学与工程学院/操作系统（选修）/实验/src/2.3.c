#include <stdio.h>
#include <unistd.h>
int main() {
  int i, j;
  j = fork();
  printf("ONE,");
  fflush(stdout);
  i = fork();
  printf("TWO,");
  fflush(stdout);
}

// 100 次运行结果统计
// ONE,ONE,TWO,TWO,TWO,TWO,: 9,
// ONE,TWO,ONE,TWO,TWO,TWO,: 26,
// ONE,TWO,TWO,ONE,TWO,TWO,: 65