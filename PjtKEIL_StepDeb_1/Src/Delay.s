	PRESERVE8
	THUMB   
		

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		
VarTime	dcd 0 ;initialisation de l'adresse VarTime à 0

	
; ===============================================================================================
	
;constantes (équivalent du #define en C)
TimeValue	equ 900000


	EXPORT Delay_100ms ; la fonction Delay_100ms est rendue publique donc utilisable par d'autres modules.
	EXPORT VarTime;
		
;Section ROM code (read only) :		
	area    moncode,code,readonly
		


; REMARQUE IMPORTANTE 
; Cette manière de créer une temporisation n'est clairement pas la bonne manière de procéder :
; - elle est peu précise
; - la fonction prend tout le temps CPU pour... ne rien faire...
;
; Pour autant, la fonction montre :
; - les boucles en ASM
; - l'accés écr/lec de variable en RAM
; - le mécanisme d'appel / retour sous programme
;
; et donc possède un intérêt pour débuter en ASM pur

Delay_100ms proc
	
	    ldr r0,=VarTime  ;on récupère l'adresse de VarTime ; macro car 64bits->32bits tout ça tout ça
						  
		ldr r1,=TimeValue ;on récupère la valeur de TimeValue
		str r1,[r0] 	  ;On stocke la valeur de r1 (TimeValue) à l'adresse stockée dans r0 (dans VarTime)
		
BoucleTempo	
		ldr r1,[r0] ;On récupère VarTime dans r1						
		subs r1,#1 ;on décrémente r1 si =0 on enable le flag_0
		str  r1,[r0] ;On remet la valeur dans r0
		bne	 BoucleTempo ;on goto BoucleTempo tant que le flag_0 n'est pas = 1
			
		bx lr
		endp
		
		
	END	