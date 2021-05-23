; ce programme est pour l'assembleur RealView (Keil)
	thumb
	area  moncode, code, readonly
	export subtest
;
subtest	proc
	push	{lr}
	bl	subtest2
	add	r0, r1
	pop	{pc}
	endp
;

; rend le carre sur 32 bits
subtest2	proc
	; multiplie r0*r0 (i*i) -> dans r4
	mul	r6, r0, r0
	mov	r0, r6
	bx	lr
	endp
	end