	PRESERVE8
    THUMB

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
    area    mesdata,data,readonly


;Section RAM (read write):
    area    maram,data,readwrite

FlagCligno dcd 0 ; On mets la varaible dans la ram (partie write pcq sinon constante)
	export FlagCligno ;On exporte la variable pour pouvoir l'obsrever en watch

; ===============================================================================================




;Section ROM code (read only) :
    area    moncode,code,readonly
; écrire le code ici
	;On import les fonctions :
    extern GPIOB_Set
    extern GPIOB_Clear
	;on exporte notre fonction
    export timer_callbackasm


timer_callbackasm proc	
    ldr r2,=FlagCligno ;on stocke dans r2 (pas r1 pcq GPIOB_Set l'utilise et ça fait chier) l'adresse de FlaCligno qui est dans la ram (On ne stocke pas la valeur ici pcq c'est pas une constante -cf au dessus- sinon la macro le ferait)
	ldr r3,[r2] ;On prend la valeur de FlagCligno dans r3 (en recupérant à l'adresse stockée dans r2)
    cmp r3, #1 ;On compare la valeur de FlagCligno à 1 si c'est vrai on active flag d'égalité

    bne sipasegal ;si flag égalité on continu sion on va à sipassignal
	;if(FlagCligno ==1){
	mov r3,#0 ; on mets 0 dans r3 provisoirement juste pour pouvoir le srt apres dans r2
	str r3,[r2] ;On mets la valeur de r3 (0) dans FlagCligno (dont l'adresse est stocké dans r2)
    push {lr} ;On mets lr dans la pille (car lr est la ligne de programme principal ou on était avant d'appeler callback et on en aura besoin apres) (on fait ça car GPIOB_Set va utiliser se registre pour pouvoir reveni dans ce programme)
    mov r0,#1 ;On mets 1 dans r0 qui sera le registre utilisé pour passer l'argument de GPUIB_Set
    bl    GPIOB_Set ;On branche sur GPIOB_Set (on appele la fonction en gros)
    pop {pc} ;On remets la valeur de lr (stockée dans la pile) dans le pc -> ça rebranche sur le programme principal là où on étais avant
    ;}else{
sipasegal
	;Pareil qu'au dessus mais on set FlagCligno à 1 cette fois et on appelle GPIOB_Clear
	mov r3,#1
	str r3,[r2]
    push {lr}
    mov r0,#1
    bl    GPIOB_Clear;est-ce que le passage d'argument marche comme ça?
    pop {pc}
    endp ;Fin de  timer_Callback
    END ;fin du program