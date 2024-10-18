	const ax,main
	jmp ax


:nl
@string "\n"
:space
@string " "



; Algorithme facto_for
:facto_for
	push bp
	cp bp,sp

	const ax,1
	push ax
	cp ax,bp
	const bx,6
	sub ax,bx
	pop bx
	storew bx,ax
	const ax,1
	push ax
	cp ax,bp
	const bx,8
	sub ax,bx
	pop bx
	storew bx,ax
	cp ax,bp
	const bx,4
	sub ax,bx
	loadw bx,ax
	push bx
	const ax,0
	push ax
	const cx,cond0
	pop ax
	pop bx
	cmp ax,bx
	jmpc cx
	const ax,1
	push ax
	const cx,fin_cond0
	jmp cx
:cond0
	const ax,0
	push ax
:fin_cond0
	pop ax
	const cx,fin_if1
	const bx,0
	cmp ax,bx
	jmpc cx
:if1
:while1
	const ax,1
	push ax
	cp ax,bp
	const bx,8
	sub ax,bx
	loadw bx,ax
	push bx
	cp ax,bp
	const bx,4
	sub ax,bx
	loadw bx,ax
	push bx
	const cx,cond1
	pop ax
	pop bx
	sless ax,bx
	jmpc cx
	const ax,1
	push ax
	const cx,fin_cond1
	jmp cx
:cond1
	const ax,0
	push ax
:fin_cond1
	pop ax
	pop bx
	const cx,corps_while1
	cmp ax,bx
	jmpc cx
	const cx,fin_while1
	jmp cx
:corps_while1
	cp ax,bp
	const bx,6
	sub ax,bx
	loadw bx,ax
	push bx
	cp ax,bp
	const bx,8
	sub ax,bx
	loadw bx,ax
	push bx
	pop ax
	pop bx
	mul ax,bx
	push ax
	cp ax,bp
	const bx,6
	sub ax,bx
	pop bx
	storew bx,ax
	const cx,while1
	jmp cx
:fin_while1

:fin_if1
	cp ax,bp
	const bx,6
	sub ax,bx
	loadw bx,ax
	push bx
	cp ax,bp
	const bx,10
	sub ax,bx
	pop bx
	storew bx,ax

	pop bp
	ret


:val
@int 0

:phrase1.5
@string "\nEntrez une valeur :\n"
:debug
@string "DEBUG\n"
:s_res
@string "\nLe résultat est :\n"
:erreur_div
@string "Erreur division par 0 interdite\n"
:rec
@string "Résultat n°0 :"

:errdiv
	const ax,erreur_div
	callprintfs ax
	end


:main
	const bp,pile
	const sp,pile
	const cx,2
	sub sp,cx

	const ax,0
	push ax
	push ax
	push ax
	const ax,phrase1.5
	callprintfs ax
	const ax,val
	callscanfd ax
	loadw bx,ax
	push bx
	const ax,facto_for
	call ax
	pop ax
	pop ax
	pop ax

	const ax,s_res
	callprintfs ax
	cp ax,sp
	callprintfd ax
	pop ax
	const ax,nl
	callprintfs ax
	end
:pile
@int 0
