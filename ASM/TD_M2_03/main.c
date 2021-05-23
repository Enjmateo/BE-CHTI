// programme pour calculer la somme des cubes d'une suite d'entiers consécutifs

typedef struct {
int i;
int j;
} truc;

int subtest( truc * );

int main(void)
{
truc t;
t.j = 0;
for	( t.i = 1; t.i < 5; ++t.i)
	subtest( &t );
while (1) {}
}
