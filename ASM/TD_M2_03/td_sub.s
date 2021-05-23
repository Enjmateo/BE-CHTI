; ce programme est pour l'assembleur RealView (Keil)
	thumb
	area  moncode, code, readonly
	export subtest
;
subtest	proc
	push	{lr}
	push	{r0}
	ldr	r0, [r0] ;on récupère i dans r0
	bl	subtest2
	pop	{r2} ;on récupère l'adresse de la structure dans le registre r2
	ldr 	r1,[r2,#4] ;car iint (32 bits ) donc 4 octets donc on décale de 4 pour avoir l'adresse de J
	add	r1,r0 ;r1+=r0
	str	r1,[r2,#4]  ;On stocke R1 à l'adresse de J (cf au dessus)

	pop	{pc}
	endp
;

; rend le cube sur 32 bits
subtest2	proc
	mul	r3, r0, r0
	mul	r0, r3, r0
	bx	lr
	endp
	end