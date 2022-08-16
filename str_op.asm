include console.inc 
.data ;��� �������� ���������� ������� �����
	max equ 100; �����, ����� ����  �������
	first equ 128; ��� ������� '�'
	last equ 159; ��� ������� '�'
	str_a equ 160; ��� ������� '�'
	text1 db  max dup (?)
	text2 db  max dup (?)
.code
input proc
	push ebp 
	mov ebp,esp
;==========c��������� ���������===========	
	for r,<ebx,ecx> ;ebx - c�� �����, ecx - c������ �����
		push r
	endm
	mov ebx,[ebp+8]
	mov ecx,-1
	outstr 'Input text with <.> in end: '
main:
	inc ecx
	inchar byte ptr [ebx][ecx];���� ���������� �������
	cmp byte ptr [ebx][ecx],'.'
	jne main
	mov byte ptr [ebx][ecx],0;����� ������
	cmp ecx,max
	ja false
	jmp true
false:
	mov eax,0;��������� �������
	jmp result
true:
	mov eax,0FFh;��������� �������
	jmp result
result:
	for r,<ecx,ebx,ebp> ;������� ���������
		pop r
	endm
	ret 4
input endp

num1 proc
	push ebp
	mov ebp,esp
;==========c��������� ���������===========
	for r,<eax,ebx,ecx,edx>
		push r
	endm 
	mov eax,[ebp+8];��� �����
	xor ecx,ecx;�������
main: 
	mov dl,byte ptr [eax][ecx];��������� ����� ������
	cmp dl,first
	jb next
	cmp dl,last
	ja next 
	;���� �������� ������ ���� ��������� ������� �����
	inc byte ptr [eax][ecx] 
	cmp byte ptr [eax][ecx],last+1
	jne next 
	;���� �������� ���� ���� ����� � � �� "����������"
	mov byte ptr [eax][ecx],first
next:
	inc ecx
	cmp byte ptr [eax][ecx],0
	jne main
	for r,<edx,ecx,ebx,eax,ebp>
		pop r
	endm
	ret 4
num1 endp 


num2 proc 
	push ebp
	mov ebp,esp
	for r,<eax,edi,ecx>
		push r
	endm
	mov ecx,max
	mov edi,[ebp+8];c�� �����
	mov al,str_a;��� '�'
	cld
	repne scasb;������� �� ������� ���������
	mov al,'*'
main:
	cmp byte ptr [edi],0
	je next 
	stosb
	jmp main
next: 	
	for r,<ecx,edi,eax,ebp>
		pop r
	endm
	ret 4
num2 endp

info proc 
	outstrln '������� ����� 109 ������ 2022'
	outstrln '������� ���������� 4 '
	outstrln '��������� ������ �� ����������'
	outstrln '������� �������:'
	outstrln '5)�������� ������ ��������� ������� ����� ��������� �� ��� �� ��������, ����� � ������ �� �.'
	outstrln '10)�������� �� "*" ��� ��������, ������ �� ������ ���������� ������� "�" � �����. (���������� ���������)'
	outstrln '===================================================================================================='
	ret
info endp 

reg proc;����� ���� ������������ ��������� + ����� 
	for r,<eax,ebx,ecx,edx,ebp,edi,esp>
		outwordln r
	endm
	ret 
reg endp 


length_cmp proc
	push ebp
	mov ebp,esp	
	for r,<ebx,ecx>
		push r
	endm	
	xor ecx,ecx;������� 
	mov eax,[ebp+8];����� 2
	mov ebx,[ebp+12];����� 1 	
main: 
	cmp byte ptr [eax][ecx],0
	je var1
	cmp byte ptr [ebx][ecx],0
	je var2
	inc ecx
	jmp main 
var1:
	mov eax,0
	jmp fin
var2:
	mov eax,1
fin:
	for r,<ecx,ebx,ebp>
		pop r
	endm
	ret 8
length_cmp endp 

Start:
	clrscr
;=================================================
;�������� ���������
	mov eax,1
	mov ebx,2
	mov ecx,3
	mov edx,4
	mov ebp,5
	mov edi,6
main_cycle:
	call info;���������� ��� ��� � �������
	newline 
	newline
	outstrln '========================================================'
	outstrln '�������� ��'
	outstrln '========================================================'
	newline
	call reg;����� ���������
	newline
	outstrln '========================================================'
cycle:
	push eax 
;���� ������ 1
    push offset text1
	call input
	flush
	cmp eax,0
	jne txt2
	outstrln 'TEXT ERROR, REPEAT INPUT'
	jmp cycle
txt2:
	push offset text2
	call input
	cmp eax,0
	jne next1
	outstrln 'TEXT ERROR, REPEAT INPUT'
	jmp txt2
next1:
	outstrln '======================================='
	outstrln 'YOUR STRINGS:'
	newline
	outstrln offset text1
	outstrln offset text2
;=============================================
;c��������� ������
	push offset text1
	push offset text2
	call length_cmp
	cmp eax,1
	je case1
	push offset text2;������ ��������
	call num2
	push offset text1;�������
	call num1
	jmp skip
	
case1:
	push offset text2;������ �������
	call num1
	push offset text1;��������
	call num2
;========================================
skip:
	newline
	outstrln '==========================================='
	outstrln 'AFTER OPERATING: '
	newline
	outstrln offset text1
	outstrln offset text2
	newline
	newline
	outstrln '============================================='
	outstrln '========================================================'
	pop eax
	outstrln '�������� �����'
	outstrln '========================================================'
	newline
	call reg
	newline
	outstrln '========================================================'
	outstr '������� 1-����������, ��� ����� ������ �������, ����� ���������:'
	inint eax
	newline 
	newline
	cmp eax,1
	je main_cycle
	
	exit
end Start