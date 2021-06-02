

#include "DriverJeuLaser.h"
#include "GestionSon.h"
#include "Affichage_Valise.h"

short int dma_buf[64];
int results[64];
int scores[6];
int comptTimeout = 0;
const int dureeTimout = 20;

int DFT_ModuleAuCarre( short int * Signal64ech, char k) ;
extern short int LeSignal;

void DFT_64_points(){
		comptTimeout=(comptTimeout+1)%dureeTimout;
		for(int k=0; k<64;k++){
			if(comptTimeout !=0) break;
			results[k]=DFT_ModuleAuCarre(dma_buf, k);
			if(results[k]>0x10000) {
				switch(k){
					case 17:
						scores[0]++;
					break;
					case 18:
						scores[1]++;
					break;
					case 19:
						scores[2]++;
					break;
					case 20:
						scores[3]++;
					break;
					case 23:
						scores[4]++;
					break;
					case 24:
						scores[5]++;
					break;
					default:
						continue;
				}
				StartSon();
			}
		}
}

void callback_Systick(){
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	DFT_64_points();

	Stop_DMA1;
}


int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================
	
	CLOCK_Configure();
	
Systick_Period_ff(360000);
Systick_Prio_IT( 1,*callback_Systick );
SysTick_On ;
SysTick_Enable_IT ;

//Initialisation du timer de l'ADC
	
Init_TimingADC_ActiveADC_ff( ADC1, 72 );
Single_Channel_ADC( ADC1, 2 );
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
Init_ADC1_DMA1( 0, dma_buf );

	
Timer_1234_Init_ff( TIM4, 6552 ); 
GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
Active_IT_Debordement_Timer( TIM4, 2, CallbackSon );
PWM_Init_ff( TIM3, 3, 720);

for(int i =0; i<6; i++) scores[i]=0;
//============================================================================	

	
while	(1)
	{
	}
}

