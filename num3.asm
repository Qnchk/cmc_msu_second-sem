include console.inc 
.data
count1 equ 10
count2 equ 20
data1 db count1 dup (?)
data2 db count2 dup (?)
.code
;ввод (сначала push кол-во эл-во, потом ссылку на массив)
input proc
	push ebp 
	mov ebp,esp
	push eax
	push ecx
	mov eax,[ebp+8];cсылка на массив
	outstr 'input '
	outword [ebp+12];кол-во эл-в
	outstr ' nums with space: '
	xor ecx,ecx
	main:
		inint edi;вводим в больше чем байт, чтобы отследить незнаковые
		cmp edi,255
		ja main;если больше в беззнаке 255 значит ввели отрицательное или сильно большее
		mov [eax][ecx],edi
		inc ecx
		cmp ecx,[ebp+12]
		jne main
	pop ecx
	pop eax
	pop ebp
	ret 4*2
input endp

;вывод (сначала push кол-во эл-во, потом ссылку на массив)
output proc
	push ebp 
	mov ebp,esp
	push eax
	push ecx
	mov eax,[ebp+8]
	outstr 'array: '
	xor ecx,ecx
	main:
		outword byte ptr [eax][ecx]
		outchar ' '
		inc ecx
		cmp ecx,[ebp+12]
		jne main
	newline
	pop ecx
	pop eax
	pop ebp
	ret 4*2
output endp

;сортировка
sort proc
	push ebp
	mov ebp,esp
	;cохраняем реги
	push edi
	push eax
	push ebx
	push esi
	mov edi,[ebp+8];ссылка на массив 
	xor eax,eax;cчетчик для прямого хода 
	xor ebx,ebx
	;"прямой ход" пока не найдем mas[i]<mas[i+1]
	main_sort:
		mov bl,byte ptr [edi][eax]
		cmp bl,byte ptr [edi][eax+1]
		jae next2
		push eax;если нашли то запоминаем на каком месте
		inc eax;увеличиваем, чтобы начать обратный ход
		reverse:;обратный ход
			mov bl,byte ptr [edi][eax]
			cmp bl,byte ptr [edi][eax-1]
			jb  next1
			xchg byte ptr [edi][eax-1],bl;сюда попадаем если нашли нужное место для вставки
			mov byte ptr[edi][eax],bl;меняем местами
			next1:
				dec eax;продолжаем обратный ход
				cmp eax,0 
				jne reverse
		pop eax
		next2:
			inc eax;продолжаем прямой ход
			mov esi,[ebp+12]
			dec esi
			cmp eax,esi
			jne main_sort
	;возвращаем сохраненные реги
	pop esi
	pop ebx
	pop eax
	pop edi
	pop ebp
	ret 4*2
sort endp
Start:
	;=================================
	;ввод первого массива
	push count1
	push offset data1
	call input
	;=================================
	;ввод второго массива
	push count2
	push offset data2
	call input
	;==================================
	outstrln '++++++++BEFORE SORT+++++++++++++'
	;вывод первого массива
	push count1
	push offset data1
	call output
	;===================================
	;вывод второго массива 
	push count2
	push offset data2
	call output
	;==================================
	;сортировка первого массива
	push count1
	push offset data1
	call sort
	;====================================
	;сортировка второго массива
	push count2
	push offset data2
	call sort
	;======================================	
	outstrln '++++++++AFTER	SORT+++++++++++++'
	;вывод первого массива после сортировки
	push count1 
	push offset data1
	call output
	;========================================
	;вывод второго массива после сортировки
	push count2 
	push offset data2
	call output
	exit
end Start
