	PRESERVE8
	THUMB   
		

; ====================== zone de r�servation de donn�es,  ======================================
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
		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; �crire le code ici		


CallbackSon proc 
	ldr r0,=AdresseSon ;On stocke l'adresse de AdresseSon dans r0
	ldr r3,=SortieSon ;On stocke l'adresse de Sortie dans r3
	
	ldr r2,=Son ; On stocke l'adresse  du son dans r2
	
	ldr r1,[r0] ; On r�cup�re la valeur de AdresseSon dans r1
	
	;SI AdresseSon vaut 0, c'est qu'on l'a pas initialis� -> On appele getStartPoint (pour set l'adresse dans notre programme)
	cmp r1, #0 
	beq getStartPoint
	
	; SI AdresseSon est �gale � l'adresse de fin du son (adresse d�but du son + 2 * longueur son) -> On appele getStartPoint (pour reset l'adresse dans notre programme)
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
	
	beq getStartPoint
	
	


	;Si Adresse son != 0 on continue et sinon on branche sur indexzero
	;dans ce cas l� on est au premier appel de CallBackson
	;Dans le cas ou c'est diff�rent de 0 on continue

	;on incr�mente la valeur de adresseson de 16bits (2octets)
	add r1,#2
	
SuiteCallback
	str r1,[r0] ;on la stocke dans adresseson
	ldrsh r1,[r1] ;on r�cup�re la valeur � la nouvelle adresse (ldr sign� half - on prend que 2 octets-)
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

getStartPoint
	mov r1,r2
	str r2,[r0]
	b SuiteCallback
	endp
		

		
		
	END	