

#include "DriverJeuLaser.h"
int DFT_ModuleAuCarre( short int * Signal64ech, char k) ;
extern short int LeSignal;


int main(void)
{
	CLOCK_Configure();
	DFT_ModuleAuCarre(&LeSignal, 1);
while	(1)
	{
	}
}

