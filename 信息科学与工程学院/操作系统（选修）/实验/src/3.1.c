#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

int main(void) {
  int fd[2], nbytes;
  pid_t childpid;
  char readbuffer[80];

  pipe(fd);

  if ((childpid = fork()) == -1) {
    exit(1);
  }

  if (childpid == 0) {
    // 子进程
    while (1) {
      const char *string = "subprocess here\n";
      write(fd[1], string, (strlen(string) + 1));
      sleep(3);
    }
  } else {
    // 父进程
    while (1) {
      nbytes = read(fd[0], readbuffer, sizeof(readbuffer));
      printf("receive: %s", readbuffer);
      sleep(3);
    }
  }
  return (0);
}