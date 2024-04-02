#include <stdio.h>
#include <unistd.h>
int main() {
  int i;
  printf("ONE,");
  fflush(stdout);
  i = fork();
  printf("TWO,");
  fflush(stdout);
}
// 100 次运行结果：
// ONE,TWO,TWO,: 100