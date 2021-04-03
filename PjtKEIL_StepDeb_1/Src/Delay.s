	PRESERVE8
	THUMB   
		

; ====================== zone de r�servation de donn�es,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		
VarTime	dcd 0 ;initialisation de l'adresse VarTime � 0

	
; ===============================================================================================
	
;constantes (�quivalent du #define en C)
TimeValue	equ 900000


	EXPORT Delay_100ms ; la fonction Delay_100ms est rendue publique donc utilisable par d'autres modules.
	EXPORT VarTime;
		
;Section ROM code (read only) :		
	area    moncode,code,readonly
		


; REMARQUE IMPORTANTE 
; Cette mani�re de cr�er une temporisation n'est clairement pas la bonne mani�re de proc�der :
; - elle est peu pr�cise
; - la fonction prend tout le temps CPU pour... ne rien faire...
;
; Pour autant, la fonction montre :
; - les boucles en ASM
; - l'acc�s �cr/lec de variable en RAM
; - le m�canisme d'appel / retour sous programme
;
; et donc poss�de un int�r�t pour d�buter en ASM pur

Delay_100ms proc
	
	    ldr r0,=VarTime  ;on r�cup�re l'adresse de VarTime ; macro car 64bits->32bits tout �a tout �a
						  
		ldr r1,=TimeValue ;on r�cup�re la valeur de TimeValue
		str r1,[r0] 	  ;On stocke la valeur de r1 (TimeValue) � l'adresse stock�e dans r0 (dans VarTime)
		
BoucleTempo	
		ldr r1,[r0] ;On r�cup�re VarTime dans r1						
		subs r1,#1 ;on d�cr�mente r1 si =0 on enable le flag_0
		str  r1,[r0] ;On remet la valeur dans r0
		bne	 BoucleTempo ;on goto BoucleTempo tant que le flag_0 n'est pas = 1
			
		bx lr
		endp
		
		
	END	