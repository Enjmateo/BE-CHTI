; ce programme est pour l'assembleur RealView (Keil)
	thumb
	area  moncode, code, readonly
	export subtest
;
subtest	proc
	add	r0, r0, r0
	bx	lr
	endp
;
	end
