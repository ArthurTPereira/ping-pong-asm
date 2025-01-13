; versão de 18/10/2022
; Uso de diretivas extern e global 
; Professor Camilo Diaz

extern line, full_circle, circle, cursor, caracter, plot_xy, desenha_botoes, bloco
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
		MOV 	byte[cor], branco
		CALL 	desenha_botoes

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


		; Cursor de selecao inicial
		CALL 	paint_cursor_1_selected
		MOV 	byte[dificuldade], 0

selection_loop:
		CALL    check_key
		CMP     AL, 0
		JE      selection_loop
		JMP    handle_key


check_key:
		MOV    AH, 01h
		INT    16h
		JZ     no_key
		MOV    AH, 00h
		INT    16h
		RET


no_key:
		MOV    AL, 0
		RET

handle_key:
		CMP    AL, 61h
		JE     selection_left
		CMP    AL, 64h
		JE     selection_right

		CMP	   AL, 1Bh
		JE	   selection_quit

		CMP    AL, 0Dh
		JE    selection_enter
		JMP     selection_loop

selection_left:
		CMP    byte[dificuldade], 0
		JE     selection_loop
		
		DEC    byte[dificuldade]
		JMP   erase_cursor

selection_right:
		CMP    byte[dificuldade], 2
		JE     selection_loop
		
		INC    byte[dificuldade]
		JMP   erase_cursor

selection_enter:
		CALL	reset_tela
		JMP		cria_campo
	    

selection_quit:
		MOV  	AH,0   						; set video mode
	    MOV  	AL,[modo_anterior]   		; modo anterior
	    INT  	10h
		MOV     AX,4c00h
		INT     21h


erase_cursor:
		CMP    byte[dificuldade], 0
		JE     paint_cursor_1_selected
		CMP    byte[dificuldade], 1
		JE     paint_cursor_2_selected
		CMP    byte[dificuldade], 2
		JE     paint_cursor_3_selected
		JMP    selection_loop


paint_cursor_1_selected:
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
		CALL 	paint_cursor_2_NOT_selected
		CALL 	paint_cursor_3_NOT_selected
		JMP    selection_loop

paint_cursor_2_selected:
		MOV 	AX, 260
		PUSH 	AX
		MOV 	AX, 180
		PUSH 	AX
		MOV 	AX, 380
		PUSH	AX
		MOV 	AX, 180
		PUSH 	AX
		MOV 	byte[cor], verde_claro
		CALL 	line
		CALL 	paint_cursor_1_NOT_selected
		CALL 	paint_cursor_3_NOT_selected
		JMP    selection_loop

paint_cursor_3_selected:
		MOV 	AX, 450
		PUSH 	AX
		MOV 	AX, 180
		PUSH 	AX
		MOV 	AX, 570
		PUSH	AX
		MOV 	AX, 180
		PUSH 	AX
		MOV 	byte[cor], verde_claro
		CALL 	line
		CALL 	paint_cursor_1_NOT_selected
		CALL 	paint_cursor_2_NOT_selected
		JMP    selection_loop

paint_cursor_1_NOT_selected:
		MOV 	AX, 70
		PUSH 	AX
		MOV 	AX, 180
		PUSH 	AX
		MOV 	AX, 190
		PUSH	AX
		MOV 	AX, 180
		PUSH 	AX
		MOV 	byte[cor], preto
		CALL 	line
		RET

paint_cursor_2_NOT_selected:
		MOV 	AX, 260
		PUSH 	AX
		MOV 	AX, 180
		PUSH 	AX
		MOV 	AX, 380
		PUSH	AX
		MOV 	AX, 180
		PUSH 	AX
		MOV 	byte[cor], preto
		CALL 	line
		RET

paint_cursor_3_NOT_selected:
		MOV 	AX, 450
		PUSH 	AX
		MOV 	AX, 180
		PUSH 	AX
		MOV 	AX, 570
		PUSH	AX
		MOV 	AX, 180
		PUSH 	AX
		MOV 	byte[cor], preto
		CALL 	line
		RET

reset_tela:
    ; Carrega o segmento de vídeo para modo 12h (0xA000)
    mov     ax, 0A000h
    mov     es, ax
    ; DI = 0 (início do segmento de vídeo)
    xor     di, di
    ; Precisamos escrever 76.800 words (cada word = 2 bytes = 4 pixels)
    mov     cx, 76800
    ; AX = 0 → cor preta em cada word
    xor     ax, ax
    ; Preenche (repete) CX vezes o valor de AX (0) em ES:[DI]
    rep     stosw

	call 	paint_cursor_1_NOT_selected
	call	paint_cursor_2_NOT_selected
	call	paint_cursor_3_NOT_selected

	
	MOV 	CX,39						;número de caracteres
    MOV    	BX,0			
    MOV    	DH,29						;linha 0-29
    MOV     DL,0						;coluna 0-79
	MOV		byte [cor],preto

apaga_desenvolvido:
	CALL	cursor
		;MOV     DI,DS
    MOV     AL,[BX+desenvolvido]
		
	CALL	caracter
    INC		BX							;proximo caracter
	INC		DL							;avanca a coluna

    LOOP    apaga_desenvolvido

    ret

cria_campo:
; Limites superiores e inferiores
	MOV		AX,42
	PUSH	AX
	MOV		AX, 5
	PUSH	AX
	MOV		AX,598
	PUSH	AX
	MOV		AX, 5
	PUSH	AX
	MOV 	byte[cor], branco_intenso
	CALL	line

	MOV		AX,42
	PUSH	AX
	MOV		AX, 475
	PUSH	AX
	MOV		AX,598
	PUSH	AX
	MOV		AX, 475
	PUSH	AX
	MOV 	byte[cor], branco_intenso
	CALL	line

; Blocos dos gols

	MOV 	AX,0
	PUSH	AX
	MOV		AX, 5
	PUSH	AX
	MOV		AX,20
	PUSH	AX
	MOV		AX, 90
	PUSH	AX
	MOV 	byte[cor], azul
	CALL 	bloco

	MOV 	AX,0
	PUSH	AX
	MOV		AX, 95
	PUSH	AX
	MOV		AX,20
	PUSH	AX
	MOV		AX, 185
	PUSH	AX
	MOV 	byte[cor], azul_claro
	CALL 	bloco

	MOV 	AX,0
	PUSH	AX
	MOV		AX, 190
	PUSH	AX
	MOV		AX,20
	PUSH	AX
	MOV		AX, 280
	PUSH	AX
	MOV 	byte[cor], verde
	CALL 	bloco

	MOV 	AX,0
	PUSH	AX
	MOV		AX, 285
	PUSH	AX
	MOV		AX,20
	PUSH	AX
	MOV		AX, 375
	PUSH	AX
	MOV 	byte[cor], amarelo
	CALL 	bloco

	MOV 	AX,0
	PUSH	AX
	MOV		AX, 380
	PUSH	AX
	MOV		AX,20
	PUSH	AX
	MOV		AX, 470
	PUSH	AX
	MOV 	byte[cor], vermelho
	CALL 	bloco

	MOV 	AX,620
	PUSH	AX
	MOV		AX, 5
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 90
	PUSH	AX
	MOV 	byte[cor], azul
	CALL 	bloco

	MOV 	AX,620
	PUSH	AX
	MOV		AX, 95
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 185
	PUSH	AX
	MOV 	byte[cor], azul_claro
	CALL 	bloco

	MOV 	AX,620
	PUSH	AX
	MOV		AX, 190
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 280
	PUSH	AX
	MOV 	byte[cor], verde
	CALL    bloco

	MOV 	AX,620
	PUSH	AX
	MOV		AX, 285
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 375
	PUSH	AX
	MOV 	byte[cor], amarelo
	CALL 	bloco

	MOV 	AX,620
	PUSH	AX
	MOV		AX, 380
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 470
	PUSH	AX
	MOV 	byte[cor], vermelho
	CALL 	bloco

	; Raquete esquerda
	MOV  AX, WORD[paddle_left_top_x]
	PUSH AX
	MOV  AX, WORD[paddle_left_top_y]
	PUSH AX
	MOV  AX, WORD[paddle_left_bottom_x]
	PUSH AX
	MOV  AX, WORD[paddle_left_bottom_y]
	PUSH AX
	MOV  byte[cor], branco_intenso
	CALL bloco

	; Raquete direita
	MOV  AX, WORD[paddle_right_top_x]
	PUSH AX
	MOV  AX, WORD[paddle_right_top_y]
	PUSH AX
	MOV  AX, WORD[paddle_right_bottom_x]
	PUSH AX
	MOV  AX, WORD[paddle_right_bottom_y]
	PUSH AX
	MOV  byte[cor], branco_intenso
	CALL bloco

	;Parametros da bola inicialmente
	MOV word[deltax], passo_bola
	MOV word[deltay], passo_bola
	MOV word[bola_x], 320
	MOV word[bola_y], 26
	MOV word[raio], 20

	JMP loop_jogo


desenha_raquete_esquerda:
	MOV  AX, WORD[paddle_left_top_x]
	PUSH AX
	MOV  AX, WORD[paddle_left_top_y]
	PUSH AX
	MOV  AX, WORD[paddle_left_bottom_x]
	PUSH AX
	MOV  AX, WORD[paddle_left_bottom_y]
	PUSH AX
	MOV  byte[cor], branco_intenso
	CALL bloco
	RET

apaga_raquete_esquerda:
	MOV  AX, WORD[paddle_left_top_x]
	PUSH AX
	MOV  AX, WORD[paddle_left_top_y]
	PUSH AX
	MOV  AX, WORD[paddle_left_bottom_x]
	PUSH AX
	MOV  AX, WORD[paddle_left_bottom_y]
	PUSH AX
	MOV  byte[cor], preto
	CALL bloco
	RET



atualiza_raquete_esquerda_cima:
	CMP  WORD[paddle_left_top_y], 360
	JG  near continuacao_raquete

	CALL  apaga_raquete_esquerda
	
	; Desenha nova raquete
	ADD  WORD[paddle_left_top_y], 5
	ADD  WORD[paddle_left_bottom_y], 5
	CALL desenha_raquete_esquerda
	JMP near continuacao_raquete


atualiza_raquete_esquerda_baixo:
	CMP  WORD[paddle_left_top_y], 25
	JL  near continuacao_raquete

	CALL  apaga_raquete_esquerda
	
	; Desenha nova raquete
	SUB  WORD[paddle_left_top_y], 5
	SUB  WORD[paddle_left_bottom_y], 5
	CALL desenha_raquete_esquerda
	JMP near continuacao_raquete

desenha_raquete_direita:
	MOV  AX, WORD[paddle_right_top_x]
	PUSH AX
	MOV  AX, WORD[paddle_right_top_y]
	PUSH AX
	MOV  AX, WORD[paddle_right_bottom_x]
	PUSH AX
	MOV  AX, WORD[paddle_right_bottom_y]
	PUSH AX
	MOV  byte[cor], branco_intenso
	CALL bloco
	RET


apaga_raquete_direita:
	MOV  AX, WORD[paddle_right_top_x]
	PUSH AX
	MOV  AX, WORD[paddle_right_top_y]
	PUSH AX
	MOV  AX, WORD[paddle_right_bottom_x]
	PUSH AX
	MOV  AX, WORD[paddle_right_bottom_y]
	PUSH AX
	MOV  byte[cor], preto
	CALL bloco
	RET

atualiza_raquete_direita_cima:
	CMP  WORD[paddle_right_top_y], 360
	JG  continuacao_raquete

	CALL  apaga_raquete_direita
	
	; Desenha nova raquete
	ADD  WORD[paddle_right_top_y], 5
	ADD  WORD[paddle_right_bottom_y], 5
	CALL desenha_raquete_direita
	JMP continuacao_raquete

atualiza_raquete_direita_baixo:
	CMP  WORD[paddle_right_top_y], 25
	JL  continuacao_raquete

	CALL  apaga_raquete_direita
	
	; Desenha nova raquete
	SUB  WORD[paddle_right_top_y], 5
	SUB  WORD[paddle_right_bottom_y], 5
	CALL desenha_raquete_direita
	JMP continuacao_raquete

check_key_jogo:
		MOV    AH, 01h
		INT    16h
		JZ     continuacao_raquete
		MOV    AH, 00h
		INT    16h
		RET

handle_key_jogo:
	CMP	   AL, 77h
	JE 	   near atualiza_raquete_esquerda_cima
	CMP    AL, 73h
	JE 	   near atualiza_raquete_esquerda_baixo
	CMP    AL, 6Fh
	JE     atualiza_raquete_direita_cima
	CMP    AL, 6Ch
	JE	   atualiza_raquete_direita_baixo
	
	CMP    AL, 71h
	JE     sair

	JMP    continuacao_raquete

sair:
	MOV  	AH,0   						; set video mode
	MOV  	AL,[modo_anterior]   		; modo anterior
	INT  	10h
	MOV     AX,4c00h
	INT     21h

loop_jogo:

	CALL    check_key_jogo
	CMP     AL, 0
	JE      continuacao_raquete
	JMP     handle_key_jogo

continuacao_raquete:

; verifica se a bola bateu na parede
	CMP 	WORD[bola_x], 40
	JL		bateu_na_parede_esquerda
	CMP 	WORD[bola_x], 600
	JG		bateu_na_parede_direita
	CMP 	WORD[bola_y], 26
	JL		bateu_na_parede_inferior
	CMP 	WORD[bola_y], 454
	JG		bateu_na_parede_superior

; verifica se a bola bateu na raquete
	


passo1:
	;; apaga a bola
	MOV 	AX, WORD[bola_x]
	PUSH	AX
	MOV		AX, WORD[bola_y]
	PUSH	AX
	MOV		AX, WORD[raio]
	PUSH	AX
	MOV     byte[cor], preto
	CALL 	full_circle

	;; atualiza a posição da bola
	MOV 	AX, WORD[deltax]
	ADD 	WORD[bola_x], AX

	MOV 	AX, WORD[deltay]
	ADD 	WORD[bola_y], AX


	;; desenha a bola
	MOV 	AX, WORD[bola_x]
	PUSH	AX
	MOV		AX, WORD[bola_y]
	PUSH	AX
	MOV		AX, WORD[raio]
	PUSH	AX
	MOV     byte[cor], vermelho
	CALL 	full_circle

	JMP 	loop_jogo

bateu_na_parede_esquerda:
	MOV 	WORD[deltax], passo_bola
	JMP 	passo1

bateu_na_parede_direita:
	MOV 	WORD[deltax], -passo_bola
	JMP 	passo1

bateu_na_parede_inferior:
	MOV 	WORD[deltay], passo_bola
	JMP 	passo1

bateu_na_parede_superior:
	MOV 	WORD[deltay], -passo_bola
	JMP 	passo1


	JMP selection_loop


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
raio            dw      0
bola_x 		dw      0
bola_y 		dw      0
passo_bola EQU 4

; Posição da raquete esquerda
paddle_left_top_x    dw 40     ; coordenada X do canto superior
paddle_left_top_y    dw 200    ; coordenada Y do canto superior
paddle_left_bottom_x dw 50     ; coordenada X do canto inferior
paddle_left_bottom_y dw 300   ; coordenada Y do canto inferior

; Posição da raquete direita
paddle_right_top_x    dw 590     ; coordenada X do canto superior
paddle_right_top_y    dw 200    ; coordenada Y do canto superior
paddle_right_bottom_x dw 600     ; coordenada X do canto inferior
paddle_right_bottom_y dw 300    ; coordenada Y do canto inferior


;*************************************************************************
segment stack stack
		DW 		512
stacktop:
