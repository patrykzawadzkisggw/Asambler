org 100h
%macro Print 1
	push dx
	push ax
	mov ah,9
	mov dx, %1
	int 21h
	pop ax
	pop dx
%endmacro

%macro readKey 0
	mov ah,7
	int 21h
%endmacro

%macro printKey 1
	push dx
	push ax
	mov ah,2
	mov dx, %1
	int 21h
	pop ax
	pop dx
%endmacro
%macro clearLine 0
	printKey 13
	Print spacje
	printKey 13
%endmacro

%macro getCursorPos 0
	mov ah,03h
	mov bh,0
	int 10h
%endmacro

%macro removeLine 0
	push ax
	push cx
	push dx
	clearLine
	getCursorPos
	mov ah,02h
	mov bh, 0
	dec dh
	int 10h
	clearLine
	pop dx
	pop cx
	pop ax
%endmacro

%macro removeLastKey 0
	push ax
	push cx
	push dx
	getCursorPos
	mov ah,02h
	mov bh, 0
	dec dl
	int 10h
	printKey ' '
	getCursorPos
	mov ah,02h
	mov bh, 0
	dec dl
	int 10h
	pop dx
	pop cx
	pop ax
%endmacro
%macro changeLineColor 1
	push ax
	push bx
	mov ah,9h
	mov bl, %1
	mov al,' '
	int 10h
	pop bx
	pop ax
%endmacro
%define TAK 1
%define NIE 0

start:
	cmp byte [ContinueFlag], NIE
	jz zamknij
	
	Print podajA
	call _WczytajLiczbe
	mov word [_x1], ax
	
	Print podajB
	call _WczytajLiczbe
	mov word [_x2], ax
	
	call _getWspDzielniki
	
	call _CzyKontynuowac
	cmp byte [ContinueFlag], TAK
	jz start
zamknij:
	mov ax, 4c00h
	int 21h

_continue:
	push ax
	printKey [nwl]
	changeLineColor 9
	Print kontynuj
	readKey
	changeLineColor 7
	removeLine
	changeLineColor 7
	pop ax
ret

_CzyKontynuowac:
	push ax
	push dx
	Print nwl
	changeLineColor 9
	Print contQ
pytanie:
	readKey
	cbw
	push ax
	
	mov byte [ContinueFlag],NIE
	cmp ax,'N'
	jz koniec_pytania
	
	cmp ax,'n'
	jz koniec_pytania
	
	mov byte [ContinueFlag],TAK
	cmp ax,'T'
	jz koniec_pytania
	
	cmp ax,'t'
	jz koniec_pytania
	pop ax
	jmp pytanie
koniec_pytania:
	changeLineColor 7
	pop dx
	printKey dx
	Print nwl
	cmp byte [ContinueFlag],TAK
	jnz bez_nowej_lini
	Print nwl
	bez_nowej_lini:
	pop dx
	pop ax
ret

printNum:
	push ax
	push bx
	push dx
	push dx
	push	bp
	mov	bp,sp
	%define INDEX word [bp+2]
	mov word INDEX,0
	
	;mov word [_idx], 0;
wyswietl:
	
	mov bx, 10
	cwd
	div bx
	
	add dx,"0"
	;mov si, word [_idx]
	;mov	word  _tab[si],dx
	push dx
	inc INDEX

	cmp ax, 0
	jg wyswietl
	
	poczatek_wypisywania:
	dec INDEX
	mov ah,2
	;mov si,word  [_idx]
	;mov dx,word  _tab[si]
	pop dx
	int 21h
	cmp INDEX, 0
	jg poczatek_wypisywania
	%undef INDEX
	mov	sp,bp
	pop	bp
	pop dx
	pop dx
	pop bx
	pop ax
ret

_WczytajLiczbe:
	push bx
	push dx
	push dx
	push dx
	push dx
	push bp
	mov	bp,sp
	%define WYNIK word [bp+2]
	%define ZNAK byte [bp+4]
	mov WYNIK, 0

poczatek_wczytywania:
	readKey
	mov ZNAK, al
	cmp ZNAK, 13
	jz koniec_read
	
	cmp ZNAK, 8
	jnz rnnb
	
	mov ax, WYNIK
	cmp ax,0
	jz poczatek_wczytywania
	
	mov bx, 10
	cwd
	idiv bx
	mov WYNIK, ax
	
	removeLastKey
	jmp poczatek_wczytywania
	
rnnb:
	cmp WYNIK,3275
	jg poczatek_wczytywania
	
	
	cmp ZNAK,'9'
	jg poczatek_wczytywania
	
	cmp ZNAK,'0'
	jl poczatek_wczytywania
	
	mov ah,2
	mov dl,ZNAK
	int 21h
	
	mov ax, WYNIK
	mov bx, 10
	cwd
	imul bx
	mov WYNIK,ax
	mov al,ZNAK
	sub al,'0'
	movzx ax,al
	add WYNIK,ax

	jmp poczatek_wczytywania
koniec_read_p:
	mov ah,2
	mov dx,[nwl]
	int 21h
	koniec_read:
	cmp WYNIK,0
	jz poczatek_wczytywania
	mov ax, WYNIK
	%undef ZNAK
	%undef WYNIK
	mov	sp,bp
	pop	bp
	pop dx
	pop dx
	pop dx
	pop dx
	pop bx
	ret
	
_getWspDzielniki:
	push ax
	push bx
	push dx
	push dx
	push dx
	push	bp
	mov	bp,sp
	
	%define I word [bp+2]
	%define J word [bp+4]
	mov I,0
	mov J,1
	push word [_x2]
	push word [_x1]
	mov ax, word [_x1]
	mov bx, word [_x2]
	cmp ax,bx
	jg poZamianieLiczb
	
	mov word [_x2], ax
	mov word [_x1], bx
poZamianieLiczb:
	cmp word [_x2],0
	jz gwdk
	
	Print msggwc1
	pop ax
	call printNum
	Print separator
	pop ax
	call printNum
	Print msggwc2
gwdc:
	inc I
	mov ax, word [_x2]
	cmp I, ax
	jg gwdk

	mov ax, word [_x1]
	cwd
	div I
	cmp dx,0
	jnz gwdc
	
	mov ax, word [_x2]
	cwd
	div I
	cmp dx,0
	jnz gwdc
	
	mov ax, J
	mov bx,22
	cwd
	idiv bx
	cmp dx, 0
	jnz gwc_wypisz_dzielnik
	call _continue

gwc_wypisz_dzielnik:
	mov ax, I
	call printNum
	Print nwl
	inc J
	jmp gwdc
gwdk:
	%undef I
	%undef J
	pop bp
	pop dx
	pop dx
	pop dx
	pop bx
	pop ax
	ret
	
podajA db 13,"Wprowadz pierwsza liczbe: $"
podajB db 10,13,"Wprowadz druga liczbe: $"
spacje db "                                             $"
nwl db 10,13,"$"
kontynuj db "Kliknij dowolny klawisz aby kontynowac $"
ContinueFlag db TAK
contQ db 13,"Czy chcesz kontynowac [T/N]: $"
_x1 dw 0
_x2 dw 0
separator db ", $"
msggwc1 db 10,10,13,"Liczby: $"
msggwc2 db " maja nastepujace wspolne dzielniki:",10,13,"$"