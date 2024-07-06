#ifndef __STACK_H__
#define __STACK_H__

#include "utils.h"

U8 *stack_peek();
bit stack_push(U8 value);
U8 stack_pop();

#endif