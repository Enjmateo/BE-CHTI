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
		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; �crire le code ici		


CallbackSon proc 
	ldr r0,=AdresseSon ;On stocke l'adresse de AdresseSon dans r0
	ldr r3,=SortieSon ;On stocke l'adresse de Sortie dans r3
	
	ldr r1,[r0] ; On r�cup�re la valeur de AdresseSon dans r1
	cmp r1, #0 
	beq indexzero 
	;Si Adresse son != 0 on continue et sinon on branche sur indexzero
	;dans ce cas l� on est au premier appel de CallBackson
	
	;Dans le cas ou c'est diff�rent de 0 on continue
SuiteCallback
	;on incr�mente la valeur de adresseson de 16bits (2octets)
	
	add r1,#2
	str r1,[r0] ;on la stocke dans adresseson
	ldrsh r1,[r1] ;on r�cup�re la valeur � la nouvelle adresse
	 ;ldr r1,[r0],#2
	mov r2, #45
	mul r1,r2
	mov r2, #4096
	sdiv r1, r2
	adds r1, #360
	str r1,[r3] ;on la mets dans sortie son
	;ldr SortieSon,[r1]
	bx lr;

indexzero
	ldr r2,=Son
	str r2,[r0]
	mov r1,r2
	b SuiteCallback
	endp
		

		
		
	END	