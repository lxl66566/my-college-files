#ifndef __MYFLOAT_H__
#define __MYFLOAT_H__

#include "utils.h"

struct myfloat {
  U8 i;
  U8 digit;
};
float to_float(struct myfloat);
void myfloat_add_0_1(struct myfloat *);
void myfloat_sub_0_1(struct myfloat *);

#endif