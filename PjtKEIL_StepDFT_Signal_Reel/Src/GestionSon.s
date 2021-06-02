	PRESERVE8
	THUMB   
		

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
SortieSon dcd 0
AdresseSon dcd 0

; ===============================================================================================
	
	extern Son
	export CallbackSon
	export SortieSon
	export AdresseSon
	extern PWM_Set_Value_TIM3_Ch3
	extern LongueurSon
	export StartSon
		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici	

StartSon proc 
	ldr r0,=AdresseSon
	mov r1, #0
	str r1, [r0]
	bx lr
	endp

CallbackSon proc 
	ldr r0,=AdresseSon ;On stocke l'adresse de AdresseSon dans r0
	ldr r3,=SortieSon ;On stocke l'adresse de Sortie dans r3
	
	ldr r2,=Son ; On stocke l'adresse  du son dans r2
	
	ldr r1,[r0] ; On récupère la valeur de AdresseSon dans r1
	
	;SI AdresseSon vaut 0, c'est qu'on l'a pas initialisé -> On appele getStartPoint (pour set l'adresse dans notre programme)
	cmp r1, #0 
	beq getStartPoint
	
	; SI AdresseSon est égale à l'adresse de fin du son (adresse début du son + 2 * longueur son) -> On fait rien
	push{r12}
	ldr r12,=LongueurSon
	ldr r12, [r12]
	push{r0}
	mov r0, #2
	mul r12, r0
	pop{r0}
	add r12, r2
	cmp r12, r1
	pop{r12}
	
	beq exit
	
	


	;Si Adresse son != 0 on continue et sinon on branche sur indexzero
	;dans ce cas là on est au premier appel de CallBackson
	;Dans le cas ou c'est différent de 0 on continue

	;on incrémente la valeur de adresseson de 16bits (2octets)
	add r1,#2
	
SuiteCallback
	str r1,[r0] ;on la stocke dans adresseson
	ldrsh r1,[r1] ;on récupère la valeur à la nouvelle adresse (ldr signé half - on prend que 2 octets-)
	;On divise par 2^16/720=4096/45 -> on mul par 45 et div par 4096 :: NORMALISATION
	mov r2, #45 
	mul r1,r2
	mov r2, #4096
	sdiv r1, r2
	adds r1, #360
	str r1,[r3] ;on la mets dans sortie son
	
	;et on set la PWM
	push {lr}
	mov r0,r1
	bl PWM_Set_Value_TIM3_Ch3
	pop {pc}

getStartPoint ; on mets l'adresse du son dans r1 et dans la variable AdresseSon
	mov r1,r2
	str r2,[r0]
	b SuiteCallback
exit
	bx lr
	endp
		

		
		
	END	