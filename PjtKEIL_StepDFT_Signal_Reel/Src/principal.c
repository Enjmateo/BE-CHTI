

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
		//Pour éviter de d'incrémenter les scores plusieurs fois par tirs, on va utiliser un timeout
		//Ceci va également permettre d'éviter d'effectuer la DFT trop de fois et monopoliser les ressources du micropocesseur
		comptTimeout=(comptTimeout+1)%dureeTimout;
		if(comptTimeout !=0) return;
	
		//On effectue la DFT pour chaque points
		for(int k=0; k<64;k++){
			results[k]=DFT_ModuleAuCarre(dma_buf, k);
			
			//Si un point a une valeur supérieur à 0x10000 (une valeur de seuil trouvée expérimentalement)
			//on va mettre à jour le score du jouer correspondant (si s'en est un), l'afficher, et jouer le son
			//On utilise un modulo 99 sur les scores afin d'éviter les problèmes avec l'afficheur LED
			if(results[k]>0x10000) {
				switch(k){
					case 17:
						scores[0] = (scores[0]+1)%99;
						Prepare_Afficheur(1, scores[0]);
					break;
					case 18:
						scores[1]=(scores[1]+1)%99;
						Prepare_Afficheur(2, scores[1]);
					break;
					case 19:
						scores[2]=(scores[2]+1)%99;
						Prepare_Afficheur(3, scores[2]);
					break;
					case 20:
						scores[3]=(scores[3]+1)%99;
						Prepare_Afficheur(4, scores[3]);
					break;
					case 23:
						scores[4]=(scores[4]+1)%99;
					break;
					case 24:
						scores[5]=(scores[5]+1)%99;
					break;
					default:
						continue;
				}
				StartSon();
				Mise_A_Jour_Afficheurs_LED();
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
Systick_Prio_IT( 9,*callback_Systick );
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

Init_Affichage();
for (int i=1;i<=4;i++){
	Prepare_Afficheur(i,0);
}
Mise_A_Jour_Afficheurs_LED();

for(int i =0; i<6; i++) scores[i]=0;

//============================================================================	

	
while	(1)
	{
	}
}

