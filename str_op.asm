include console.inc 
.data ;все значения подобранны опытным путем
	max equ 100; длина, чтобы быть  текстом
	first equ 128; код русской 'А'
	last equ 159; код русской 'Я'
	str_a equ 160; код русской 'а'
	text1 db  max dup (?)
	text2 db  max dup (?)
.code
input proc
	push ebp 
	mov ebp,esp
;==========cохранение регистров===========	
	for r,<ebx,ecx> ;ebx - cам текст, ecx - cчетчик длины
		push r
	endm
	mov ebx,[ebp+8]
	mov ecx,-1
	outstr 'Input text with <.> in end: '
main:
	inc ecx
	inchar byte ptr [ebx][ecx];ввод очередного символа
	cmp byte ptr [ebx][ecx],'.'
	jne main
	mov byte ptr [ebx][ecx],0;конец строки
	cmp ecx,max
	ja false
	jmp true
false:
	mov eax,0;результат функции
	jmp result
true:
	mov eax,0FFh;результат функции
	jmp result
result:
	for r,<ecx,ebx,ebp> ;возврат регистров
		pop r
	endm
	ret 4
input endp

num1 proc
	push ebp
	mov ebp,esp
;==========cохранение регистров===========
	for r,<eax,ebx,ecx,edx>
		push r
	endm 
	mov eax,[ebp+8];сам текст
	xor ecx,ecx;счетчик
main: 
	mov dl,byte ptr [eax][ecx];очередная буква текста
	cmp dl,first
	jb next
	cmp dl,last
	ja next 
	;сюда попадаем только если прописная русская буква
	inc byte ptr [eax][ecx] 
	cmp byte ptr [eax][ecx],last+1
	jne next 
	;сюда попадаем если была буква я и мы "перевалили"
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
	mov edi,[ebp+8];cам текст
	mov al,str_a;код 'а'
	cld
	repne scasb;доходим до первого вхождения
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
	outstrln 'Погосян Арсен 109 группа 2022'
	outstrln 'Задание практикума 4 '
	outstrln 'Обработка строки на ассемблере'
	outstrln 'Вариант задания:'
	outstrln '5)Заменить каждую прописную русскую букву следующей за ней по алфавиту, букву Я менять на А.'
	outstrln '10)Заменить на "*" все элементы, идущие за первым вхождением русской "а" в текст. (строковыми командами)'
	outstrln '===================================================================================================='
	ret
info endp 

reg proc;вывод всех используемых регистров + стека 
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
	xor ecx,ecx;счетчик 
	mov eax,[ebp+8];текст 2
	mov ebx,[ebp+12];текст 1 	
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
;проверка регистров
	mov eax,1
	mov ebx,2
	mov ecx,3
	mov edx,4
	mov ebp,5
	mov edi,6
main_cycle:
	call info;информация обо мне и задании
	newline 
	newline
	outstrln '========================================================'
	outstrln 'регистры до'
	outstrln '========================================================'
	newline
	call reg;вывод регистров
	newline
	outstrln '========================================================'
cycle:
	push eax 
;ввод текста 1
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
;cравниваем строки
	push offset text1
	push offset text2
	call length_cmp
	cmp eax,1
	je case1
	push offset text2;боллее короткий
	call num2
	push offset text1;длинный
	call num1
	jmp skip
	
case1:
	push offset text2;боллее длинный
	call num1
	push offset text1;короткий
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
	outstrln 'регистры после'
	outstrln '========================================================'
	newline
	call reg
	newline
	outstrln '========================================================'
	outstr 'Введите 1-продолжить, или любую другую клавишу, чтобы закончить:'
	inint eax
	newline 
	newline
	cmp eax,1
	je main_cycle
	
	exit
end Start