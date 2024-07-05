#include "stack.h"

#define STK_SIZE 3 // 定义栈的最大容量
#define IS_EMPTY (stack_top == -1)
#define IS_FULL (stack_top == STK_SIZE - 1)

U8 stack[STK_SIZE]; // 定义全局静态数组作为栈
int stack_top = -1; // 栈顶

U8 *stack_peek() {
  if (!IS_EMPTY) {
    return stack + stack_top;
  } else
    return 0x00;
}
bit stack_push(U8 value) {
  if (!IS_FULL) {
    stack[++stack_top] = value;
    return 1;
  }
  return 0;
}
U8 stack_pop() {
  if (!IS_EMPTY) {
    return stack[stack_top--];
  } else
    return -1;
}