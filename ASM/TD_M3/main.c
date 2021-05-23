#include <stdio.h>
int subtest( int );

int main(void)
{
int i = 123;
int t = i;
t = subtest( t );
i = i * 1.5708;
printf("%d3\n",t);
return 0;
}
