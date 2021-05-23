	thumb
	area	reset, data, readonly
	export __Vectors
__Vectors
	dcd	0x20004000	; stack en fin de la zone de 20k de RAM
	dcd	Reset_Handler	; point d'entree de notre programme
;
	area	moncode, code, readonly
;
; procedure principale
;
	export	Reset_Handler
Reset_Handler proc

boo     b       boo
	endp
;
	end