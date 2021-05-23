#include "gassp72.h"

void t4_callback(void );
extern unsigned int compteur4;

int main(void)
{
// activation de la PLL qui multiplie la fr�quence du quartz par 9
CLOCK_Configure(); //Ici 72 Mhz
// config port PB1 pour �tre utilis� en sortie
GPIO_Configure(GPIOB, 1, OUTPUT, OUTPUT_PPULL);
// initialisation du timer 4
Timer_1234_Init_ff( TIM4, 72000 ); // temps �coul� 1/72 MHz * 72 000 = temps entre 2 d�bordement de compteur = 1 ms (explication : d�bordement toutes les 72000 valeurs)
// enregistrement de la fonction de traitement de l'interruption timer (priorit� 2)
Active_IT_Debordement_Timer( TIM4, 2, t4_callback );
// lancement du timer
Run_Timer( TIM4 );
// boucle principale
while	(1)
	{
	if	( ( compteur4 & 0x7 ) == 5 ) //0000111 
		GPIO_Set( GPIOB, 1 );
	else	GPIO_Clear( GPIOB, 1 );
	}
}
