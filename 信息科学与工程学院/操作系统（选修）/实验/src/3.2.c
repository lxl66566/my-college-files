#include <fcntl.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

int fd[2], nbytes;
pid_t childpid[2];
const int len = sizeof("Child2 is sending a message!\n");

void write_str(const char *string) {
  write(fd[1], string, (strlen(string) + 1));
}

int main(void) {
  // 使用信号量
  sem_t *sem;
  sem = sem_open("mysem", O_CREAT | O_EXCL, 0644, 0);

  if (pipe(fd) < 0 || sem == NULL) {
    exit(1);
  }

  if ((childpid[0] = fork()) == 0) {
    // 子进程 1
    write_str("Child1 is sending a message!\n");
    close(fd[1]);
    sem_post(sem);
  } else if ((childpid[1] = fork()) == 0) {
    // 子进程 2
    sem_wait(sem);
    write_str("Child2 is sending a message!\n");
    close(fd[1]);
  } else {
    // 父进程
    for (int i = 0; i < 2; i++) {
      char readbuffer[len];
      waitpid(childpid[i], NULL, 0);
      nbytes = read(fd[0], readbuffer, sizeof(readbuffer));
      printf("receive: %s", readbuffer);
    }
    sem_close(sem);
    sem_unlink("mysem");
  }
  return (0);
}