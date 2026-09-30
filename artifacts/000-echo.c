/* 000-echo.c — Cycle 0 artifact of the echOS engine.
 *
 * A quine that cannot repeat itself perfectly. Each generation prints
 * its own source with the cycle count incremented by one: an echo that
 * changes what it repeats.
 *
 *   gcc -o echo 000-echo.c && ./echo > gen1.c
 *   gcc -o gen1 gen1.c && ./gen1 > gen2.c   (note: int n=2;)
 */
#include <stdio.h>
int main(void){
int n=0;
char*s="#include <stdio.h>%cint main(void){%cint n=%d;%cchar*s=%c%s%c;%cprintf(s,10,10,n+1,10,34,s,34,10,10,10,10);%creturn 0;%c}%c";
printf(s,10,10,n+1,10,34,s,34,10,10,10,10);
return 0;
}
