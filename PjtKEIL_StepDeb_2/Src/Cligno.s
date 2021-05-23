	PRESERVE8
    THUMB

; ====================== zone de r�servation de donn�es,  ======================================
;Section RAM (read only) :
    area    mesdata,data,readonly


;Section RAM (read write):
    area    maram,data,readwrite

FlagCligno dcd 0 ; On mets la varaible dans la ram (partie write pcq sinon constante)
	export FlagCligno ;On exporte la variable pour pouvoir l'obsrever en watch

; ===============================================================================================




;Section ROM code (read only) :
    area    moncode,code,readonly
; �crire le code ici
	;On import les fonctions :
    extern GPIOB_Set
    extern GPIOB_Clear
	;on exporte notre fonction
    export timer_callbackasm


timer_callbackasm proc	
    ldr r2,=FlagCligno ;on stocke dans r2 (pas r1 pcq GPIOB_Set l'utilise et �a fait chier) l'adresse de FlaCligno qui est dans la ram (On ne stocke pas la valeur ici pcq c'est pas une constante -cf au dessus- sinon la macro le ferait)
	ldr r3,[r2] ;On prend la valeur de FlagCligno dans r3 (en recup�rant � l'adresse stock�e dans r2)
    cmp r3, #1 ;On compare la valeur de FlagCligno � 1 si c'est vrai on active flag d'�galit�

    bne sipasegal ;si flag �galit� on continu sion on va � sipassignal
	;if(FlagCligno ==1){
	mov r3,#0 ; on mets 0 dans r3 provisoirement juste pour pouvoir le srt apres dans r2
	str r3,[r2] ;On mets la valeur de r3 (0) dans FlagCligno (dont l'adresse est stock� dans r2)
    push {lr} ;On mets lr dans la pille (car lr est la ligne de programme principal ou on �tait avant d'appeler callback et on en aura besoin apres) (on fait �a car GPIOB_Set va utiliser se registre pour pouvoir reveni dans ce programme)
    mov r0,#1 ;On mets 1 dans r0 qui sera le registre utilis� pour passer l'argument de GPUIB_Set
    bl    GPIOB_Set ;On branche sur GPIOB_Set (on appele la fonction en gros)
    pop {pc} ;On remets la valeur de lr (stock�e dans la pile) dans le pc -> �a rebranche sur le programme principal l� o� on �tais avant
    ;}else{
sipasegal
	;Pareil qu'au dessus mais on set FlagCligno � 1 cette fois et on appelle GPIOB_Clear
	mov r3,#1
	str r3,[r2]
    push {lr}
    mov r0,#1
    bl    GPIOB_Clear;est-ce que le passage d'argument marche comme �a?
    pop {pc}
    endp ;Fin de  timer_Callback
    END ;fin du program