.686
.model flat,stdcall
option casemap:none
.code

	public pack  ; внешнее имя _pack@0
	pack proc
    push ebp
    mov ebp, esp     
   	push ebx
	mov ax,word ptr [ebp+8]; stickers_count
	;000000000000aaaa
   	shl ax,4
    ;00000000aaaa0000	
	mov bx, word ptr [ebp+12]; quality_count
	or ax,bx
	;00000000aaaabbbb
	shl ax,8
	;aaaabbbb00000000
	mov bx,word ptr [ebp+16]; price 
	or ax,bx  
	pop ebx
    pop ebp
    ret 4*3 ;
	pack endp



	public unpack  ; внешнее имя _unpack@0
	unpack proc
   	push ebp
    mov ebp, esp 
	for r,<eax,ebx,edx>
		push r
	endm
	mov ax,word ptr [ebp+8]; zip
	
;================price========================
	mov bx,ax
    and bx, 11111111b; price 0-100
	mov edx, [ebp+20]
	mov word ptr [edx],bx

;==============quality count======================
	mov bx,ax
	shr bx,8
	and bx, 1111b; 
	mov edx, [ebp+16];quality count
	mov word ptr [edx],bx

;============stickers count=======================	
	mov bx,ax
	shr bx,12
	and bx,1111b; stickers count
	mov edx, [ebp+12]
	mov word ptr [edx],bx
	for r,<edx,ebx,eax,ebp>
		pop r
	endm
  	ret 4*4 
	unpack endp
	end

