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
		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici		


CallbackSon proc 
	push {lr}
	ldr r0,=AdresseSon ;On stocke l'adresse de AdresseSon dans r0
	ldr r3,=SortieSon ;On stocke l'adresse de Sortie dans r3
	
	ldr r1,[r0] ; On récupère la valeur de AdresseSon dans r1
	cmp r1, #0 
	beq indexzero 
	;Si Adresse son != 0 on continue et sinon on branche sur indexzero
	;dans ce cas là on est au premier appel de CallBackson
	
	;Dans le cas ou c'est différent de 0 on continue
SuiteCallback
	;on incrémente la valeur de adresseson de 16bits (2octets)
	add r1,#2
	str r1,[r0] ;on la stocke dans adresseson
	ldr r1,[r1] ;on récupère la valeur à la nouvelle adresse
	str r1,[r3] ;on la mets dans sortie son test
	;ldr SortieSon,[r1]
	pop {pc}
indexzero
	ldr r2,=Son
	str r2,[r0]
	mov r1,r2
	bl SuiteCallback
	endp
		

		
		
	END	