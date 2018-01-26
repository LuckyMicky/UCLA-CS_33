#include<stdio.h>
#include<limits.h>
#define TMAX 2147483647
#define TMIN (-TMAX -1)

int saturating_add(int x, int y)
{
  int w = sizeof(x) << 3;
  int sum = x + y;
  int mask = 1 << (w - 1);
  int x_msb = x & mask;
  int y_msb = y & mask;
  int sum_msb = sum & mask;
  int pos_ovf = ~x_msb & ~y_msb & sum_msb;
  int neg_ovf = x_msb & y_msb & !sum_msb;
  (pos_ovf) && (sum = TMAX);
  (neg_ovf) && (sum = TMIN);
   
  return sum;
}

int main(void){
  printf("%d\n", INT_MAX);
  printf("%d\n", INT_MIN);
  printf("%d\n", saturating_add(100,100);)
  printf("%d\n",saturating_add（INT_MAX,1);
  printf("%d\n",saturating_add（INT_MIN,-1);
  printf("%d\n",saturating_add（INT_MAX,0);
  printf("%d\n",saturating_add（INT_MIN,1);
}
