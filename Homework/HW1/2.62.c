#include <stdio.h>

int  int_shifts_are_arithmetic()
{
  int a = -1;
  if ((a>>1) == a)
    return 1;
  else
    return 0;
}
int main(void)
{
  printf("%d",int_shifts_are_arithmetic());
  return 0;
}
 
