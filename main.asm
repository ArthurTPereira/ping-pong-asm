; versão de 18/10/2022
; Uso de diretivas extern e global 
; Professor Camilo Diaz

extern line, full_circle, circle, cursor, caracter, plot_xy 
global cor

segment code

;org 100h
..start:
        MOV     AX,data			;Inicializa os registradores
    	MOV 	DS,AX
    	MOV 	AX,stack
    	MOV 	SS,AX
    	MOV 	SP,stacktop

;Salvar modo corrente de video(vendo como esta o modo de video da maquina)
        MOV  	AH,0Fh
    	INT  	10h
    	MOV  	[modo_anterior],AL   

;Alterar modo de video para grafico 640x480 16 cores
    	MOV     AL,12h
   		MOV     AH,0
    	INT     10h
		

	; Tela de dificuldade
	


;escrever uma mensagem
; MSN: 
; 		MOV 	CX,14						;número de caracteres
;     	MOV    	BX,0			
;     	MOV    	DH,0						;linha 0-29
;     	MOV     DL,30						;coluna 0-79
; 		MOV		byte [cor],azul
; l4:
; 		CALL	cursor
; 		;MOV     DI,DS
;     	MOV     AL,[BX+mens]
		
; 		CALL	caracter
;     	INC		BX							;proximo caracter
; 		INC		DL							;avanca a coluna
; 		INC		byte[cor]					;mudar a cor para a seguinte
;     	LOOP    l4

; 	Tela de dificuldade


;Nome do jogo
		MOV 	CX,9						;número de caracteres
    	MOV    	BX,0			
    	MOV    	DH,3						;linha 0-29
    	MOV     DL,35						;coluna 0-79
		MOV		byte [cor],verde_claro
l_nome:
		CALL	cursor
		;MOV     DI,DS
    	MOV     AL,[BX+nome_jogo]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
		; INC		byte[cor]					;mudar a cor para a seguinte
    	LOOP    l_nome
		

;Seleciona a dificuldade

		MOV 	CX,23						;número de caracteres
    	MOV    	BX,0			
    	MOV    	DH,5						;linha 0-29
    	MOV     DL,30						;coluna 0-79
		MOV		byte [cor],branco_intenso
l_dificuldade:
		CALL	cursor
		;MOV     DI,DS
    	MOV     AL,[BX+selecao]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
		; INC		byte[cor]				;mudar a cor para a seguinte
    	LOOP    l_dificuldade
		

;Desenvolvido por:

		MOV 	CX,39						;número de caracteres
    	MOV    	BX,0			
    	MOV    	DH,29						;linha 0-29
    	MOV     DL,0						;coluna 0-79
		MOV		byte [cor],branco_intenso
l_desenvolvido:
		CALL	cursor
		;MOV     DI,DS
    	MOV     AL,[BX+desenvolvido]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
		; INC		byte[cor]				;mudar a cor para a seguinte
    	LOOP    l_desenvolvido
		

; 	Tela de dificuldade

; 1 BOTAO
		MOV 	AX, 70
		PUSH 	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	AX, 190
		PUSH	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	byte[cor], verde_claro
		CALL 	line

		MOV 	AX, 70
		PUSH 	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	AX, 70
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], verde_claro
		CALL 	line

		MOV 	AX, 70
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 190
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], verde_claro
		CALL 	line

		MOV 	AX, 190
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 190
		PUSH	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	byte[cor], verde_claro
		CALL 	line

; 2 BOTAO

		MOV 	AX, 260
		PUSH 	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	AX, 380
		PUSH	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	byte[cor], branco
		CALL 	line

		MOV 	AX, 260
		PUSH 	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	AX, 260
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], branco
		CALL 	line

		MOV 	AX, 260
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 380
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], branco
		CALL 	line

		MOV 	AX, 380
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 380
		PUSH	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	byte[cor], branco
		CALL 	line

; 3 BOTAO

		MOV 	AX, 450
		PUSH 	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	AX, 570
		PUSH	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	byte[cor], branco
		CALL 	line

		MOV 	AX, 450
		PUSH 	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	AX, 450
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], branco
		CALL 	line

		MOV 	AX, 450
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 570
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], branco
		CALL 	line

		MOV 	AX, 570
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 570
		PUSH	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	byte[cor], branco
		CALL 	line

	;Facil
		MOV 	CX,5						;número de caracteres
    	MOV    	BX,0			
    	MOV    	DH,15						;linha 0-29
    	MOV     DL,14						;coluna 0-79
		MOV		byte [cor],branco
l_facil:
		CALL	cursor
		;MOV     DI,DS
    	MOV     AL,[BX+facil]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
    	LOOP    l_facil

	;Medio
		MOV 	CX,5						;número de caracteres
    	MOV    	BX,0			
    	MOV    	DH,15						;linha 0-29
    	MOV     DL,38						;coluna 0-79
		MOV		byte [cor],amarelo
l_medio:
		CALL	cursor
		;MOV     DI,DS
    	MOV     AL,[BX+medio]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
    	LOOP    l_medio


	;Dificil
		MOV 	CX,7						;número de caracteres
    	MOV    	BX,0			
    	MOV    	DH,15						;linha 0-29
    	MOV     DL,60						;coluna 0-79
		MOV		byte [cor],vermelho
l_dificil:
		CALL	cursor
		;MOV     DI,DS
    	MOV     AL,[BX+dificil]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
    	LOOP    l_dificil


; Cursor de selecao
		MOV 	AX, 70
		PUSH 	AX
		MOV 	AX, 180
		PUSH 	AX
		MOV 	AX, 190
		PUSH	AX
		MOV 	AX, 180
		PUSH 	AX
		MOV 	byte[cor], verde_claro
		CALL 	line




		MOV    	AH,08h
		INT     21h
	    MOV  	AH,0   						; set video mode
	    MOV  	AL,[modo_anterior]   		; modo anterior
	    INT  	10h
		MOV     AX,4c00h
		INT     21h


segment data

cor		db		branco_intenso

;	I R G B COR
;	0 0 0 0 preto
;	0 0 0 1 azul
;	0 0 1 0 verde
;	0 0 1 1 cyan
;	0 1 0 0 vermelho
;	0 1 0 1 magenta
;	0 1 1 0 marrom
;	0 1 1 1 branco
;	1 0 0 0 cinza
;	1 0 0 1 azul claro
;	1 0 1 0 verde claro
;	1 0 1 1 cyan claro
;	1 1 0 0 rosa
;	1 1 0 1 magenta claro
;	1 1 1 0 amarelo
;	1 1 1 1 branco intenso

preto		    equ		0
azul		    equ		1
verde		    equ		2
cyan		    equ		3
vermelho	    equ		4
magenta		    equ		5
marrom		    equ		6
branco		    equ		7
cinza		    equ		8
azul_claro	    equ		9
verde_claro	    equ		10
cyan_claro	    equ		11
rosa		    equ		12
magenta_claro	equ		13
amarelo		    equ		14
branco_intenso	equ		15

modo_anterior	db		0
linha   	    dw  	0
coluna  	    dw  	0
deltax		    dw		0
deltay		    dw		0
nome_jogo		dw 		'Ping-Pong $'
selecao    	    db  	'Selecione a dificuldade $'
desenvolvido	dw		'Desenvolvido por: esguicho, otoch, tvin $' 
facil           db      'FACIL $'
medio           db      'MEDIO $'
dificil         db      'DIFICIL $'
dificuldade     db      0

;*************************************************************************
segment stack stack
		DW 		512
stacktop:
