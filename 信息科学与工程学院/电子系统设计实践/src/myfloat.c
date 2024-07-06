#include "myfloat.h"

float to_float(struct myfloat m) { return (float)m.i + (float)m.digit / 10; }

void myfloat_add_0_1(struct myfloat *m) {
  m->digit++;
  if (m->digit > 9) {
    ++(m->i);
    (m->digit) -= 10;
  }
}
void myfloat_sub_0_1(struct myfloat *m) {
  m->digit--;
  if (m->digit > 9) {
    --(m->i);
    (m->digit) = 9;
  }
}