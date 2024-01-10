section .text use32
;Algorytm herona
;double a = 1., b = P;
;do{
;   a = (a+b)/2.;
;   b = P/a;
;} while(eps<=abs(a-b));
;return (a+b)/2.;
	global	_pierwiastek

	_pierwiastek:
	; po wykonaniu push ebp i mov ebp, esp:
	; [ebp]    stare EBP
	; [ebp+4]  Punkt powrotu z procedury
	; [ebp+8]  Pierwszy parametr procedury

	%idefine	x	[ebp+8] ;2

		push	ebp
		mov	ebp, esp

		finit
		
		;poczatek
		fld1;A0=a
		fld qword x;b A0
		 
		 
		;petla
		petla:
		fxch st0,st1 ;a b
		fadd st1; a+b b
		fdiv qword [s2];A1=(a+b)/2 b
		fxch st0,st1 ;b A1
		fstp st0;A1
		fld qword x ;b A1
		fdiv st1;B=P/A1 A1
		
		;warunek petli
		fldz; 0 b a
		fadd st1; b b a
		fsub st2; b-a b a
		fabs; abs(b-a) b a
		fld qword  [eps]; eps abs(b-a) b a
		fcompp;eps<= abs
		fstsw ax
		;fwait
		sahf
		jbe petla
		 
		;return
		fxch st0,st1 ;a b
		fadd st1;a+b b
		fdiv qword [s2];(a+b)/2 b


	; LEAVE = mov esp, ebp / pop ebp
		leave
		ret
section .data use32
	s2 dq 2.0
	eps dq 0.0000000000000001