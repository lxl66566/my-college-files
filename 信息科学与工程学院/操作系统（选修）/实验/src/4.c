#include <stdio.h>
#include <stdlib.h>
#define MIN(a, b) ((a) < (b) ? (a) : (b))

enum { N = 4, WAIT_N = 3 };                // 队列数量
const int TIME_OF_QUEUE[N] = {2, 3, 6, 8}; // 各队列的时间片长度
int time = 0;                              // 当前时间

typedef struct {
  int name; // 进程标识符
  int time; // 进程执行所需时间
} pcb;

typedef pcb QueueElementType;

typedef struct QNode {
  QueueElementType data;
  struct QNode *next;
} QNode, *QueuePtr;

typedef struct {
  QueuePtr front; // 队头指针
  QueuePtr rear;  // 队尾指针
} LinkQueue;

LinkQueue pool[N]; // 队列数组

int rand_t(int l, int r) { return (l + rand() % (r - l + 1)); }

void print_pcb(pcb p) { printf("(%d, %d)", p.name, p.time); }

// 初始化队列
void initQueue(LinkQueue *queue) {
  queue->front = queue->rear = (QueuePtr)malloc(sizeof(QNode));
  if (!queue->front) {
    exit(EXIT_FAILURE); // 内存分配失败
  }
  queue->front->next = NULL;
}

_Bool is_empty(LinkQueue *queue) { return queue->front == queue->rear; }

// 入队
void push(LinkQueue *queue, QueueElementType value) {
  QueuePtr p = (QueuePtr)malloc(sizeof(QNode));
  if (!p) {
    exit(EXIT_FAILURE); // 内存分配失败
  }
  p->data = value;
  p->next = NULL;
  queue->rear->next = p;
  queue->rear = p;
}

// 出队
int pop(LinkQueue *queue, QueueElementType *value) {
  if (is_empty(queue)) {
    return -1;
  }
  QueuePtr p = queue->front->next;
  *value = p->data;
  queue->front->next = p->next;
  if (queue->rear == p) {
    queue->rear = queue->front;
  }
  return 1;
}

void print_queue(LinkQueue *queue) {
  QueuePtr p = queue->front->next;
  while (p) {
    print_pcb(p->data);
    if (p->next)
      printf(" -> ");
    p = p->next;
  }
  printf("\n");
}

void init_pool(LinkQueue pool[]) {
  for (int i = 0; i < N; i++) {
    initQueue(&pool[i]);
  }
}

void print_pool(LinkQueue pool[]) {
  for (int i = 0; i < N; i++) {
    printf("Queue %d: ", i);
    print_queue(&pool[i]);
  }
  printf("\n");
}

_Bool is_empty_pool(LinkQueue pool[]) {
  for (int i = 0; i < N; i++) {
    if (!is_empty(&pool[i])) {
      return 0;
    }
  }
  printf("All pools are empty.\n");
  return 1;
}

// 执行一次进程。返回 0 则所有进程执行完毕。
_Bool run(LinkQueue pool[]) {
  _Bool flag = 0; // 是否执行过进程
  for (int i = 0; i < N; i++) {

    // 先按顺序找到一个非空队列
    if (is_empty(&pool[i]))
      continue;
    flag = 1;

    // 出队一个进程
    QueueElementType p;
    pop(&pool[i], &p);

    // 执行该进程
    printf("Run process %d at time %d\n", p.name, time);
    time += MIN(TIME_OF_QUEUE[i], p.time);
    p.time -= TIME_OF_QUEUE[i];

    // 如果进程未执行完，则入队
    if (p.time > 0) {
      push(&pool[i == N - 1 ? i : i + 1], p);
    } else {
      printf("Finish process %d at time %d\n", p.name, time);
    }
    if (!flag) {
      printf("All process is complete at time %d\n", time);
      return 0;
    } else {
      return 1;
    }
  }
  return 0;
}

// 模拟运行过程中有新的任务进入的情况
typedef struct {
  pcb process;
  int time; // 入队时间
} WaitList;

WaitList waitlist[WAIT_N] = {
    {{11, 5}, 8},
    {{12, 7}, 16},
    {{13, 9}, 25},
};
int wait_i = 0;

void try_add_waitlist() {
  if (wait_i >= WAIT_N) {
    // 整个 waitlist 已添加入 pool
    return;
  }
  if (time >= waitlist[wait_i].time) {
    push(&pool[0], waitlist[wait_i].process);
    printf("Add process %d in waitlist %dth at time %d\n",
           waitlist[wait_i].process.name, wait_i + 1, time);
    wait_i++;
  }
}

int main() {
  init_pool(pool);

  // 假设有一些进程初始时入队
  for (int i = 0; i < 2; i++) {
    pcb p;
    p.name = i;
    p.time = rand_t(1, 11);
    push(&pool[0], p);
  }

  printf("Initial pool:\n");
  print_pool(pool);

  while (run(pool)) {
    printf("time: %d\n", time);
    try_add_waitlist();
    print_pool(pool);
  }

  return 0;
}
