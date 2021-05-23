; ce programme est pour l'assembleur RealView (Keil)
	thumb

	area  madata, data;, readonly  <-enlevé pcq empèche l'écriture
	export compteur4

compteur4	dcd	0



	area  moncode, code, readonly
	export t4_callback
;
t4_callback	proc
	ldr	r1, =compteur4 	;On load l'adresse de compteur 4 en r1
	ldr	r0, [r1]	;On récupère la valeur du compteur en r0
	add	r0, #1 		;On incrémente le compteur 
	str	r0, [r1] 	;On mets r0 dans r1
	bx	lr		; dernière instruction de la fonction
	endp
;
	end