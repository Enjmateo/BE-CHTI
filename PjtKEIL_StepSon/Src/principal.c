#include "DriverJeuLaser.h"
#include "GestionSon.h"


int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers
CLOCK_Configure();


	
Timer_1234_Init_ff( TIM4, 6552 ); 
	
GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
// Activation des interruptions issues du Timer 4
// Association de la fonction à exécuter lors de l'interruption : timer_callback
// cette fonction (si écrite en ASM) doit être conforme à l'AAPCS
Active_IT_Debordement_Timer( TIM4, 2, CallbackSon );


//============================================================================	
	
PWM_Init_ff( TIM3, 3, 720);	

for(int i = 0; i<5000000;i++);
StartSon();
while	(1)
	{
	}
}

