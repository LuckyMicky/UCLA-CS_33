/*Daxuan Shu
  UID: 204853061*/
// Use gcc -o1 to compile

long cread_alt(int *xp)
{
        long t = 0;
        return *(xp ? xp : &t);
}


