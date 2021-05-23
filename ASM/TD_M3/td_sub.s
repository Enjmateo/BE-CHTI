; ce programme est pour l'assembleur RealView (Keil)
	thumb
	area  moncode, code ;, readonly
	export subtest
;
subtest proc 

	ldr r1 ,=#102944 
	mul r0, r0, r1; * 102944
	lsr r0, r0, #16 ; /65 536
	bx lr
	endp
;
	end

; *102944/65536 = 1.5..