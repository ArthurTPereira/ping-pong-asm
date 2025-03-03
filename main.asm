; versão de 18/10/2022
; Uso de diretivas extern e global 
; Professor Camilo Diaz

extern line, full_circle, circle, cursor, caracter, plot_xy, desenha_botoes, bloco, desenha_botoes_sim_nao
global cor

segment code

;org 100h
..start:
        MOV     AX,data			;Inicializa os registradores
    	MOV 	DS,AX
    	MOV 	AX,stack
    	MOV 	SS,AX
    	MOV 	SP,stacktop

		CLI								; Deshabilita INTerrupções por hardware - pin INTR NÃO atende INTerrupções externas	
        XOR     AX, AX					; Limpa o registrador AX, é equivalente a fazer "MOV AX,0"
        MOV     ES, AX					; Inicializa o registrador de Segmento Extra ES para acessar à região de vetores de INTerrupção (posição zero de memoria)
        MOV     AX, [ES:INT9*4]			; Carrega em AX o valor do IP do vector de INTerrupção 9 
        MOV     [offset_dos], AX    	; Salva na variável offset_dos o valor do IP do vector de INTerrupção 9
        MOV     AX, [ES:INT9*4+2]   	; Carrega em AX o valor do CS do vector de INTerrupção 9
        MOV     [cs_dos], AX			; Salva na variável cs_dos o valor do CS do vector de INTerrupção 9     
        MOV     [ES:INT9*4+2], CS		; Atualiza o valor do CS do vector de INTerrupção 9 com o CS do programa atual 
        MOV     WORD [ES:INT9*4],keyINT	; Atualiza o valor do IP do vector de INTerrupção 9 com o offset "keyINT" do programa atual
        STI	

		JMP modo_video


keyINT:									; Este segmento de código só será executado se uma tecla for presionada, ou seja, se a INT 9h for acionada!
        PUSH    AX						; Salva contexto na pilha
        PUSH    BX
        PUSH    DS
 ;       MOV     AX,data					; Carrega em AX o endereço de "data" -> Região do código onde encontra-se o segemeto de dados "Segment data" 			
 ;       MOV     DS,AX					; Atualiza registrador de segmento de dados DS, isso pode ser feito no inicio do programa!
        IN      AL, kb_data				; Le a porta 60h, que é onde está o byte do Make/Break da tecla. Esse valor é fornecido pelo chip "8255 PPI"
        INC     WORD [p_i]				; Incrementa p_i para indicar no loop principal que uma tecla foi acionada!
        AND     WORD [p_i],7			
        MOV     BX,[p_i]				; Carrega p_i em BX
        MOV     [BX+tecla],al			; Transfere o valor Make/Break da tecla armacenado em AL "linha 84" para o segmento de dados com offset DX, na variável "tecla"
        IN      AL, kb_ctl				; Le porta 61h, pois o bit mais significativo "bit 7" 
        OR      AL, 80h					; Faz operação lógica OR com o bit mais significativo do registrador AL (1XXXXXXX) -> Valor lido da porta 61h 
        OUT     kb_ctl, AL				; Seta o bit mais significativo da porta 61h
        AND     AL, 7Fh					; Restablece o valor do bit mais significativo do registrador AL (0XXXXXXX), alterado na linha 90 	
        OUT     kb_ctl, AL				; Reinicia o registrador de dislocamento 74LS322 e Livera a interrupção "CLR do flip-flop 7474". O 8255 - Programmable Peripheral Interface (PPI) fica pronto para recever um outro código da tecla https://es.wikipedia.org/wiki/INTel_8255
        MOV     AL, eoi					; Carrega o AL com a byte de End of Interruption, -> 20h por default
        OUT     pictrl, AL				; Livera o PIC
        
		POP     DS						; Reestablece os registradores salvos na linha 79 
        POP     BX
        POP     AX
        IRET							; Retorna da interrupção

modo_video:
;Salvar modo corrente de video(vendo como esta o modo de video da maquina)
        MOV  	AH,0Fh
    	INT  	10h
    	MOV  	[modo_anterior],AL   

;Alterar modo de video para grafico 640x480 16 cores
    	MOV     AL,12h
   		MOV     AH,0
    	INT     10h

begin_game:
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

		MOV 	CX,58						;número de caracteres
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
        MOV     AX,[p_i]				
		CMP     AX,[p_t]
        JE      selection_loop
		JMP     handle_key

handle_key:
		INC     word[p_t]				; p_t - se atualiza (p_t = p_t + 1) só se p_i foi atualizado, ou seja, se teve tecla pulsada
        AND     word[p_t],7				
        MOV     BX,[p_t]				; Carrega em BX o valor de p_t
        XOR     AX, AX
        MOV     AL, [BX+tecla]			; Carrega em AL o valor da variável tecla (variável atualizada durante a ISR) mais o offset BX, AL <- [BX+tecla]  
        MOV     [tecla_u],AL

		
		CMP    BYTE [tecla_u], 1Eh
		JE     selection_left
		CMP    BYTE [tecla_u], 20h
		JE     selection_right

		CMP	   BYTE [tecla_u], 10h
		JE	   near fechar_jogo

		CMP    BYTE [tecla_u], 1Ch
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
		CMP  	byte[dificuldade], 0
		JE		velocidade_facil
		CMP  	byte[dificuldade], 1
		JE		velocidade_medio
		CMP 	byte[dificuldade], 2
		JE      velocidade_dificil
		
velocidade_facil:
		MOV    word[passo_bola], 5
		JMP 	inicia_jogo
velocidade_medio: 
		MOV    word[passo_bola], 8
		JMP 	inicia_jogo
velocidade_dificil:
		MOV    word[passo_bola], 10
		JMP 	inicia_jogo

inicia_jogo:
		CALL	reset_tela
		JMP		cria_campo
	    


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
		MOV  	AH,0   						; set video mode
	    MOV  	AL,[modo_anterior]   		; modo anterior
	    INT  	10h

		MOV     AL,12h
   		MOV     AH,0
    	INT     10h

		RET

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
	MOV		AX, 95
	PUSH	AX
	MOV 	byte[cor], azul
	CALL 	bloco

	MOV 	AX,0
	PUSH	AX
	MOV		AX, 100
	PUSH	AX
	MOV		AX,20
	PUSH	AX
	MOV		AX, 190
	PUSH	AX
	MOV 	byte[cor], azul_claro
	CALL 	bloco

	MOV 	AX,0
	PUSH	AX
	MOV		AX, 195
	PUSH	AX
	MOV		AX,20
	PUSH	AX
	MOV		AX, 285
	PUSH	AX
	MOV 	byte[cor], verde
	CALL 	bloco

	MOV 	AX,0
	PUSH	AX
	MOV		AX, 290
	PUSH	AX
	MOV		AX,20
	PUSH	AX
	MOV		AX, 380
	PUSH	AX
	MOV 	byte[cor], amarelo
	CALL 	bloco

	MOV 	AX,0
	PUSH	AX
	MOV		AX, 385
	PUSH	AX
	MOV		AX,20
	PUSH	AX
	MOV		AX, 475
	PUSH	AX
	MOV 	byte[cor], vermelho
	CALL 	bloco

	MOV 	AX,620
	PUSH	AX
	MOV		AX, 5
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 95
	PUSH	AX
	MOV 	byte[cor], azul
	CALL 	bloco

	MOV 	AX,620
	PUSH	AX
	MOV		AX, 100
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 190
	PUSH	AX
	MOV 	byte[cor], azul_claro
	CALL 	bloco

	MOV 	AX,620
	PUSH	AX
	MOV		AX, 195
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 285
	PUSH	AX
	MOV 	byte[cor], verde
	CALL    bloco

	MOV 	AX,620
	PUSH	AX
	MOV		AX, 290
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 380
	PUSH	AX
	MOV 	byte[cor], amarelo
	CALL 	bloco

	MOV 	AX,620
	PUSH	AX
	MOV		AX, 385
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 475
	PUSH	AX
	MOV 	byte[cor], vermelho
	CALL 	bloco

	; Raquete esquerda
	MOV  AX, WORD[x1_raquete_esquerda]
	PUSH AX
	MOV  AX, WORD[y1_raquete_esquerda]
	PUSH AX
	MOV  AX, WORD[x2_raquete_esquerda]
	PUSH AX
	MOV  AX, WORD[y2_raquete_esquerda]
	PUSH AX
	MOV  byte[cor], branco_intenso
	CALL bloco

	; Raquete direita
	MOV  AX, WORD[x1_raquete_direita]
	PUSH AX
	MOV  AX, WORD[y1_raquete_direita]
	PUSH AX
	MOV  AX, WORD[x2_raquete_direita]
	PUSH AX
	MOV  AX, WORD[y2_raquete_direita]
	PUSH AX
	MOV  byte[cor], branco_intenso
	CALL bloco

	;Parametros da bola inicialmente
	MOV AX, [passo_bola]
	MOV word[deltax], AX
	MOV AX, [passo_bola]
	MOV word[deltay], AX

	JMP loop_jogo


desenha_raquete_esquerda:
	MOV  AX, WORD[x1_raquete_esquerda]
	PUSH AX
	MOV  AX, WORD[y1_raquete_esquerda]
	PUSH AX
	MOV  AX, WORD[x2_raquete_esquerda]
	PUSH AX
	MOV  AX, WORD[y2_raquete_esquerda]
	PUSH AX
	MOV  byte[cor], branco_intenso
	CALL bloco
	RET

apaga_raquete_esquerda:
	MOV  AX, WORD[x1_raquete_esquerda]
	PUSH AX
	MOV  AX, WORD[y1_raquete_esquerda]
	PUSH AX
	MOV  AX, WORD[x2_raquete_esquerda]
	PUSH AX
	MOV  AX, WORD[y2_raquete_esquerda]
	PUSH AX
	MOV  byte[cor], preto
	CALL bloco
	RET



atualiza_raquete_esquerda_cima:
	CMP  WORD[y2_raquete_esquerda], 450
	JG  near continuacao_raquete

	CALL  apaga_raquete_esquerda
	
	; Desenha nova raquete
	ADD  WORD[y2_raquete_esquerda], passo_raquete
	ADD  WORD[y1_raquete_esquerda], passo_raquete
	CALL desenha_raquete_esquerda
	JMP near continuacao_raquete


atualiza_raquete_esquerda_baixo:
	CMP  WORD[y1_raquete_esquerda], 25
	JL  near continuacao_raquete

	CALL  apaga_raquete_esquerda
	
	; Desenha nova raquete
	SUB  WORD[y2_raquete_esquerda], passo_raquete
	SUB  WORD[y1_raquete_esquerda], passo_raquete
	CALL desenha_raquete_esquerda
	JMP near continuacao_raquete

desenha_raquete_direita:
	MOV  AX, WORD[x1_raquete_direita]
	PUSH AX
	MOV  AX, WORD[y1_raquete_direita]
	PUSH AX
	MOV  AX, WORD[x2_raquete_direita]
	PUSH AX
	MOV  AX, WORD[y2_raquete_direita]
	PUSH AX
	MOV  byte[cor], branco_intenso
	CALL bloco
	RET


apaga_raquete_direita:
	MOV  AX, WORD[x1_raquete_direita]
	PUSH AX
	MOV  AX, WORD[y1_raquete_direita]
	PUSH AX
	MOV  AX, WORD[x2_raquete_direita]
	PUSH AX
	MOV  AX, WORD[y2_raquete_direita]
	PUSH AX
	MOV  byte[cor], preto
	CALL bloco
	RET

atualiza_raquete_direita_cima:
	CMP  WORD[y2_raquete_direita], 450
	JG  near continuacao_raquete

	CALL  apaga_raquete_direita
	
	; Desenha nova raquete
	ADD  WORD[y2_raquete_direita], 5
	ADD  WORD[y1_raquete_direita], 5
	CALL desenha_raquete_direita
	JMP continuacao_raquete

atualiza_raquete_direita_baixo:
	CMP  WORD[y1_raquete_direita], 25
	JL  near continuacao_raquete

	CALL  apaga_raquete_direita
	
	; Desenha nova raquete
	SUB  WORD[y2_raquete_direita], 5
	SUB  WORD[y1_raquete_direita], 5
	CALL desenha_raquete_direita
	JMP near continuacao_raquete

handle_key_jogo:
	INC     word[p_t]				; p_t - se atualiza (p_t = p_t + 1) só se p_i foi atualizado, ou seja, se teve tecla pulsada
	AND     word[p_t],7				
	MOV     BX,[p_t]				; Carrega em BX o valor de p_t
	XOR     AX, AX
	MOV     AL, [BX+tecla]			; Carrega em AL o valor da variável tecla (variável atualizada durante a ISR) mais o offset BX, AL <- [BX+tecla]  
	MOV     [tecla_u],AL

	CMP	   byte[tecla_u], 11h
	JE 	   near atualiza_raquete_esquerda_cima
	CMP    byte[tecla_u], 1Fh
	JE 	   near atualiza_raquete_esquerda_baixo
	CMP    byte[tecla_u], 48h
	JE     atualiza_raquete_direita_cima
	CMP    byte[tecla_u], 50h
	JE	   atualiza_raquete_direita_baixo
	
	CMP    AL, 10h
	JE     sair

	CMP	   AL, 19h
	JE 	   key_pause

	JMP    near continuacao_raquete

key_pause:
		MOV 	CX,5						;número de caracteres
    	MOV    	BX,0			
    	MOV    	DH,15						;linha 0-29
    	MOV     DL,35						;coluna 0-79
		MOV		byte [cor],branco_intenso
l_pause:
		CALL	cursor
		;MOV     DI,DS
    	MOV     AL,[BX+pausado]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
		; INC		byte[cor]				;mudar a cor para a seguinte
    	LOOP    l_pause
pausa:
        MOV     AX,[p_i]				
		CMP     AX,[p_t]
        JE      pausa
		JMP     handle_key_pause

handle_key_pause:

	INC     word[p_t]				; p_t - se atualiza (p_t = p_t + 1) só se p_i foi atualizado, ou seja, se teve tecla pulsada
	AND     word[p_t],7				
	MOV     BX,[p_t]				; Carrega em BX o valor de p_t
	XOR     AX, AX
	MOV     AL, [BX+tecla]			; Carrega em AL o valor da variável tecla (variável atualizada durante a ISR) mais o offset BX, AL <- [BX+tecla]  
	MOV     [tecla_u],AL

	CMP	   AL, 19h
	JE 	   resume
	JMP    near pausa

resume:
		MOV 	CX,5						;número de caracteres
    	MOV    	BX,0			
    	MOV    	DH,15						;linha 0-29
    	MOV     DL,35						;coluna 0-79
		MOV		byte [cor],preto
l_resume:
		CALL	cursor
		;MOV     DI,DS
    	MOV     AL,[BX+pausado]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
		; INC		byte[cor]				;mudar a cor para a seguinte
    	LOOP    l_resume
		JMP near continuacao_raquete


sair:
		MOV 	CX,12						;número de caracteres
    	MOV    	BX,0			
    	MOV    	DH,10						;linha 0-29
    	MOV     DL,30						;coluna 0-79
		MOV		byte [cor],branco_intenso
l_sair:
		CALL	cursor
		;MOV     DI,DS
    	MOV     AL,[BX+deseja_sair]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
		; INC		byte[cor]				;mudar a cor para a seguinte
    	LOOP    l_sair

	CALL 	desenha_menu_sim_nao

		MOV 	AX, 170
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 250
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], verde_claro
		CALL 	line

exit_loop:
	MOV     AX,[p_i]				
	CMP     AX,[p_t]
	JE      exit_loop
	JMP     handle_key_exit_loop

handle_key_exit_loop:

	INC     word[p_t]				; p_t - se atualiza (p_t = p_t + 1) só se p_i foi atualizado, ou seja, se teve tecla pulsada
	AND     word[p_t],7				
	MOV     BX,[p_t]				; Carrega em BX o valor de p_t
	XOR     AX, AX
	MOV     AL, [BX+tecla]			; Carrega em AL o valor da variável tecla (variável atualizada durante a ISR) mais o offset BX, AL <- [BX+tecla]  
	MOV     [tecla_u],AL

		CMP    AL, 1Eh
		JE     selection_left_exit_loop
		CMP    AL, 20h
		JE     selection_right_exit_loop

		CMP    AL, 1Ch
		JE    near selection_enter_exit_loop
		JMP     exit_loop

selection_left_exit_loop:
		CMP    byte[select_sair], 0
		JE     exit_loop
		
		DEC    byte[select_sair]
		JMP   erase_cursor_exit_loop

selection_right_exit_loop:
		CMP    byte[select_sair], 1
		JE     exit_loop
		
		INC    byte[select_sair]
		JMP   erase_cursor_exit_loop

erase_cursor_exit_loop:
		CMP    byte[select_sair], 0
		JE     paint_yes_selected_exit_loop
		CMP    byte[select_sair], 1
		JE     paint_no_selected_exit_loop

		JMP    exit_loop

paint_yes_selected_exit_loop:
		MOV 	AX, 170
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 250
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], verde_claro
		CALL 	line

		MOV 	AX, 360
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 450
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], preto
		CALL 	line

		JMP   	exit_loop


paint_no_selected_exit_loop:

		MOV 	AX, 360
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 450
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], verde_claro
		CALL 	line

		MOV 	AX, 170
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 250
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], preto
		CALL 	line
		JMP   	exit_loop

selection_enter_exit_loop:
	CMP	byte[select_sair], 0
	JE 	near fechar_jogo
	CMP	byte[select_sair], 1
	JE  resumir_jogo


resumir_jogo:
	CALL	 apaga_menu_sim_nao
	MOV 	byte[cor], preto

	MOV 	AX, 360
	PUSH 	AX
	MOV 	AX, 200
	PUSH 	AX
	MOV 	AX, 450
	PUSH	AX
	MOV 	AX, 200
	PUSH 	AX
	CALL 	line

	MOV 	AX, 170
	PUSH 	AX
	MOV 	AX, 200
	PUSH 	AX
	MOV 	AX, 250
	PUSH	AX
	MOV 	AX, 200
	PUSH 	AX
	CALL 	line

	MOV 	CX,12						;número de caracteres
	MOV    	BX,0			
	MOV    	DH,10						;linha 0-29
	MOV     DL,30						;coluna 0-79

l_apaga_sair:
	CALL	cursor
	;MOV     DI,DS
	MOV     AL,[BX+deseja_sair]
	
	CALL	caracter
	INC		BX							;proximo caracter
	INC		DL							;avanca a coluna
	; INC		byte[cor]				;mudar a cor para a seguinte
	LOOP    l_apaga_sair

	MOV      byte[select_sair],0

	JMP 	 near continuacao_raquete

fechar_jogo:
	MOV  	AH,0   						; set video mode
	MOV  	AL,[modo_anterior]   		; modo anterior
	INT  	10h

	CLI								; Deshabilita INTerrupções por hardware - pin INTR NÃO atende INTerrupções externas
	XOR     AX, AX					; Limpa o registrador AX, é equivalente a fazer "MOV AX,0"				
	MOV     ES, AX					; Inicializa o registrador de Segmento Extra ES para acessar à região de vetores de INTerrupção (posição zero de memoria)
	MOV     AX, [cs_dos]			; Carrega em AX o valor do CS do vector de INTerrupção 9 que foi salvo na variável cs_dos -> linha 25
	MOV     [ES:INT9*4+2], AX		; Atualiza o valor do CS do vector de INTerrupção 9 que foi salvo na variável cs_dos
	MOV     AX, [offset_dos]		; Carrega em AX o valor do IP do vector de INTerrupção 9 que foi salvo na variável offset_dos -> linha 23
	MOV     [ES:INT9*4], AX 		; Atualiza o valor do IP do vector de INTerrupção 9 que foi salvo na variável offset_dos
	MOV     AH, 4Ch					; Carrega em AH o valor de 4Ch, parametro para INT 21h
	INT     21h						; Chama Interrupção 21h para retornar o controle ao sistema operacional -> sai de forma segura da execução do programa



loop_jogo:
	MOV     AX,[p_i]				
	CMP     AX,[p_t]
	JE      continuacao_raquete
	JMP     handle_key_jogo

continuacao_raquete:

; verifica se a bola bateu na parede
	CMP 	WORD[bola_x], 25
	JL		near bateu_na_parede_esquerda
	CMP 	WORD[bola_x], 630
	JG		near bateu_na_parede_direita
	CMP 	WORD[bola_y], 32
	JL		near bateu_na_parede_inferior
	CMP 	WORD[bola_y], 454
	JG		near bateu_na_parede_superior


	; Verifica se a bola bateu na raquete esquerda
	MOV 	AX, WORD[bola_x]
	SUB 	AX, WORD[raio]
	SUB     AX, 5 ; margem
	CMP 	AX, WORD[x2_raquete_esquerda]
	JG  	verifica_colisao_raquete_direita

	MOV 	AX, WORD[bola_y]
	CMP 	AX, WORD[y1_raquete_esquerda]
	JL  	verifica_colisao_raquete_direita
	CMP     AX, WORD[y2_raquete_esquerda]
	JG      verifica_colisao_raquete_direita

	; Aqui teve colisao
	JMP      bateu_na_parede_esquerda

verifica_colisao_raquete_direita:
; verifica se a bola bateu na raquete direita
	MOV 	AX, WORD[bola_x]
	ADD     AX, WORD[raio]
	ADD     AX, 5 ; margem
	CMP 	AX, WORD[x1_raquete_direita]
	JL 		near verifica_gol_esquerdo

	MOV 	AX, WORD[bola_y]
	CMP 	AX, WORD[y1_raquete_direita]
	JL  	near verifica_gol_esquerdo
	CMP     AX, WORD[y2_raquete_direita]
	JG      near verifica_gol_esquerdo

	JMP		bateu_na_parede_direita

verifica_gol_esquerdo:
	MOV 	AX, WORD[bola_x]
	SUB 	AX, WORD[raio]
	CMP 	AX, 25
	JLE 	verifica_gol_azul_escuro_esquerdo
	JMP 	verifica_gol_direito

verifica_gol_azul_escuro_esquerdo:
	MOV 	AX, word[bola_y]
	CMP		AX,99
	JG		verifica_gol_azul_claro_esquerdo
	MOV		AX, 0
	PUSH	AX
	MOV		AX, 5
	PUSH	AX
	MOV		AX, 20
	PUSH	AX
	MOV		AX, 95
	PUSH	AX
	MOV 	byte[cor], preto
	CALL 	bloco

	CMP    WORD[azul_escuro_esquerdo], 1
	JE     near fim_jogo
	MOV    WORD[azul_escuro_esquerdo], 1
	

	JMP 	bateu_na_parede_esquerda ; inverte a direção da bola apos quebrar o bloco
verifica_gol_azul_claro_esquerdo:	
	MOV 	AX, word[bola_y]	
	CMP		AX,194
	JG		verifica_gol_verde_esquerdo
	MOV		AX, 0
	PUSH	AX
	MOV		AX, 100
	PUSH	AX
	MOV		AX, 20
	PUSH	AX
	MOV		AX, 190
	PUSH	AX
	MOV 	byte[cor], preto
	CALL 	bloco

	CMP    WORD[azul_claro_esquerdo], 1
	JE     near fim_jogo
	MOV    WORD[azul_claro_esquerdo], 1

	JMP 	bateu_na_parede_esquerda
verifica_gol_verde_esquerdo:	
	MOV 	AX, word[bola_y]	
	CMP		AX,289
	JG		verifica_gol_amarelo_esquerdo
	MOV		AX, 0
	PUSH	AX
	MOV		AX, 195
	PUSH	AX
	MOV		AX, 20
	PUSH	AX
	MOV		AX, 285
	PUSH	AX
	MOV 	byte[cor], preto
	CALL 	bloco

	CMP	    WORD[verde_esquerdo], 1
	JE      near fim_jogo
	MOV     WORD[verde_esquerdo], 1

	JMP 	bateu_na_parede_esquerda
verifica_gol_amarelo_esquerdo:
	MOV 	AX, word[bola_y]	
	CMP		AX,384	
	JG		verifica_gol_vermelho_esquerdo
	MOV		AX, 0
	PUSH	AX
	MOV		AX, 290
	PUSH	AX
	MOV		AX, 20
	PUSH	AX
	MOV		AX, 380
	PUSH	AX
	MOV 	byte[cor], preto
	CALL 	bloco

	CMP    WORD[amarelo_esquerdo], 1
	JE     near fim_jogo
	MOV    WORD[amarelo_esquerdo], 1

	JMP 	bateu_na_parede_esquerda
verifica_gol_vermelho_esquerdo:	

	MOV		AX, 0
	PUSH	AX
	MOV		AX, 385
	PUSH	AX
	MOV		AX, 20
	PUSH	AX
	MOV		AX, 475
	PUSH	AX
	MOV 	byte[cor], preto
	CALL    bloco

	CMP    WORD[vermelho_esquerdo], 1
	JE     near fim_jogo
	MOV    WORD[vermelho_esquerdo], 1

	JMP 	bateu_na_parede_esquerda

verifica_gol_direito:
	MOV 	AX, word[bola_x]
	ADD 	AX, WORD[raio]
	CMP 	AX, 610
	JGE 	verifica_gol_azul_escuro_direito
	JMP 	passo1

verifica_gol_azul_escuro_direito:
	MOV     AX, word[bola_y]
	ADD 	AX, WORD[raio]
	CMP     AX, 89
	JG      verifica_gol_azul_claro_direito
	MOV 	AX,620
	PUSH	AX
	MOV		AX, 5
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 95
	PUSH	AX
	MOV 	byte[cor], preto
	CALL 	bloco

	CMP    WORD[azul_escuro_direito], 1
	JE     near fim_jogo
	MOV    WORD[azul_escuro_direito], 1

	JMP     bateu_na_parede_direita

verifica_gol_azul_claro_direito:
	MOV     AX, word[bola_y]
	ADD 	AX, WORD[raio]
	CMP     AX, 184
	JG      verifica_gol_verde_direito
	MOV 	AX,620
	PUSH	AX
	MOV		AX, 100
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 190
	PUSH	AX
	MOV 	byte[cor], preto
	CALL 	bloco

	CMP    WORD[azul_claro_direito], 1
	JE     near fim_jogo
	MOV    WORD[azul_claro_direito], 1

	JMP     bateu_na_parede_direita
	
verifica_gol_verde_direito:	
	MOV 	AX, word[bola_y]	
	CMP		AX,289
	JG		verifica_gol_amarelo_direito
	MOV		AX, 620
	PUSH	AX
	MOV		AX, 195
	PUSH	AX
	MOV		AX, 639
	PUSH	AX
	MOV		AX, 285
	PUSH	AX
	MOV 	byte[cor], preto
	CALL 	bloco

	CMP	    WORD[verde_direito], 1
	JE      near fim_jogo
	MOV     WORD[verde_direito], 1

	JMP 	bateu_na_parede_direita

verifica_gol_amarelo_direito:
	MOV 	AX, word[bola_y]	
	CMP		AX,384	
	JG		verifica_gol_vermelho_direito
	MOV 	AX,620
	PUSH	AX
	MOV		AX, 290
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 380
	PUSH	AX
	MOV 	byte[cor], preto
	CALL 	bloco

	CMP    WORD[amarelo_direito], 1
	JE     near fim_jogo
	MOV    WORD[amarelo_direito], 1

	JMP 	bateu_na_parede_direita

verifica_gol_vermelho_direito:	

	MOV 	AX,620
	PUSH	AX
	MOV		AX, 385
	PUSH	AX
	MOV		AX,639
	PUSH	AX
	MOV		AX, 475
	PUSH	AX
	MOV 	byte[cor], preto
	CALL    bloco

	CMP    WORD[vermelho_direito], 1
	JE     near fim_jogo
	MOV    WORD[vermelho_direito], 1

	JMP 	bateu_na_parede_direita


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

	; desenha as raquetes novamente por que a bola nova pode apagar elas
	CALL    desenha_raquete_esquerda
	CALL    desenha_raquete_direita

	JMP 	loop_jogo

bateu_na_parede_esquerda:
	MOV 	AX, WORD[passo_bola]
	MOV 	WORD[deltax], AX
	JMP 	passo1

bateu_na_parede_direita:
	MOV 	AX, word[passo_bola]
	NEG 	AX  
	MOV 	WORD[deltax], AX
	JMP 	passo1

bateu_na_parede_inferior:
	MOV 	AX, WORD[passo_bola]
	MOV 	WORD[deltay], AX
	JMP 	passo1

bateu_na_parede_superior:
	MOV 	AX, WORD[passo_bola]
	NEG 	AX
	MOV 	WORD[deltay], AX
	JMP 	passo1


fim_jogo:
	CMP 	WORD[bola_x], 15
	JL		rejogar
	CMP 	WORD[bola_x], 625
	JG		rejogar

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

	CMP 	WORD[bola_x], 15
	JL		rejogar
	CMP 	WORD[bola_x], 625
	JG		rejogar

	;; desenha a bola
	MOV 	AX, WORD[bola_x]
	PUSH	AX
	MOV		AX, WORD[bola_y]
	PUSH	AX
	MOV		AX, WORD[raio]
	PUSH	AX
	MOV     byte[cor], vermelho
	CALL 	full_circle

	JMP fim_jogo


rejogar:
		CALL  desenha_menu_sim_nao
		CALL  l_jogar_novamente
		JMP paint_yes_selected

yes_no_loop:
        MOV     AX,[p_i]				
		CMP     AX,[p_t]
        JE      yes_no_loop
		JMP     handle_key_yes_no

handle_key_yes_no:

		INC     word[p_t]				; p_t - se atualiza (p_t = p_t + 1) só se p_i foi atualizado, ou seja, se teve tecla pulsada
        AND     word[p_t],7				
        MOV     BX,[p_t]				; Carrega em BX o valor de p_t
        XOR     AX, AX
        MOV     AL, [BX+tecla]			; Carrega em AL o valor da variável tecla (variável atualizada durante a ISR) mais o offset BX, AL <- [BX+tecla]  
        MOV     [tecla_u],AL

		CMP    byte[tecla_u], 1Eh
		JE     selection_left_yes_no
		CMP    byte[tecla_u], 20h
		JE     selection_right_yes_no

		CMP    byte[tecla_u], 1Ch
		JE    near selection_enter_yes_no
		JMP     yes_no_loop

selection_left_yes_no:
		CMP    byte[select_sim_nao], 0
		JE     yes_no_loop
		
		DEC    byte[select_sim_nao]
		JMP   erase_cursor_yes_no

selection_right_yes_no:
		CMP    byte[select_sim_nao], 1
		JE     yes_no_loop
		
		INC    byte[select_sim_nao]
		JMP   erase_cursor_yes_no

erase_cursor_yes_no:
		CMP    byte[select_sim_nao], 0
		JE     paint_yes_selected
		CMP    byte[select_sim_nao], 1
		JE     paint_no_selected

		JMP    yes_no_loop

paint_yes_selected:
		MOV 	AX, 170
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 250
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], verde_claro
		CALL 	line

MOV 	AX, 360
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 450
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], preto
		CALL 	line

		JMP   	yes_no_loop


paint_no_selected:

		MOV 	AX, 360
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 450
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], verde_claro
		CALL 	line

		MOV 	AX, 170
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 250
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	byte[cor], preto
		CALL 	line
		JMP   	yes_no_loop

selection_enter_yes_no:
	CMP	byte[select_sim_nao], 0
	JE 	recomecar
	CMP	byte[select_sim_nao], 1
	JE 	near fechar_jogo

recomecar:
	MOV word[vermelho_esquerdo], 0
	MOV word[amarelo_esquerdo], 0
	MOV word[verde_esquerdo], 0
	MOV word[azul_claro_esquerdo], 0
	MOV word[azul_escuro_esquerdo], 0

	MOV word[vermelho_direito], 0
	MOV word[amarelo_direito], 0
	MOV word[verde_direito], 0
	MOV word[azul_claro_direito], 0
	MOV word[azul_escuro_direito], 0

	MOV word[x1_raquete_esquerda], 40
	MOV word[y1_raquete_esquerda], 200
	MOV word[x2_raquete_esquerda], 50
	MOV word[y2_raquete_esquerda], 300

	MOV word[x1_raquete_direita], 590
	MOV word[y1_raquete_direita], 200
	MOV word[x2_raquete_direita], 600
	MOV word[y2_raquete_direita], 300

	MOV word[bola_x], 320
	MOV word[bola_y], 26

	MOV byte[dificuldade], 0
	MOV byte[select_sim_nao], 0

	CALL	reset_tela
	JMP 	near begin_game

desenha_menu_sim_nao:
	MOV byte[cor], branco_intenso
	CALL l_sim
	CALL l_nao
	CALL desenha_botoes_sim_nao
	RET

apaga_menu_sim_nao:
	MOV byte[cor], preto
	CALL l_sim
	CALL l_nao
	CALL desenha_botoes_sim_nao
	RET

l_sim:
		MOV 	CX,3						;número de caracteres
    	MOV    	BX,0			
    	MOV    	DH,15						;linha 0-29
    	MOV     DL,25						;coluna 0-79

loop_sim:
		CALL	cursor
		;MOV     DI,DS
    	MOV     AL,[BX+sim]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
		; INC		byte[cor]				;mudar a cor para a seguinte
    	LOOP    loop_sim
		RET

l_nao:
		MOV 	CX,3						;número de caracteres
    	MOV    	BX,0			
    	MOV    	DH,15						;linha 0-29
    	MOV     DL,49						;coluna 0-79

loop_nao:
		CALL	cursor
		;MOV     DI,DS
    	MOV     AL,[BX+nao]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
		; INC		byte[cor]				;mudar a cor para a seguinte
    	LOOP    loop_nao
		RET

l_jogar_novamente:
		MOV 	CX,16						;número de caracteres
    	MOV    	BX,0			
    	MOV    	DH,10						;linha 0-29
    	MOV     DL,30						;coluna 0-79

loop_novamente:
		CALL	cursor
		;MOV     DI,DS
    	MOV     AL,[BX+jogar_novamente]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
		; INC		byte[cor]				;mudar a cor para a seguinte
    	LOOP    loop_novamente
		RET

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
desenvolvido	dw		'Desenvolvido por: Arthur Pereira, Hugo Lima, Estevao Nunes $' 
facil           db      'FACIL $'
medio           db      'MEDIO $'
dificil         db      'DIFICIL $'
sim				db      'SIM $'
nao				db      'NAO $'
pausado         db      'PAUSE $'
jogar_novamente db      'Jogar novamente? $'
deseja_sair     db	    'Deseja sair? $'
dificuldade     db      0
select_sim_nao  db		0
select_sair    db		0
raio            dw      16
bola_x 		dw      320
bola_y 		dw      26
passo_bola  resw 	1
passo_raquete equ 	5

; Posição da raquete esquerda
x1_raquete_esquerda    dw 40     ; x1
y1_raquete_esquerda   dw 200    ; y1
x2_raquete_esquerda dw 50     ; x2
y2_raquete_esquerda dw 300   ; y2

; Variáveis para controle de colisão dos blocos da esquerda
vermelho_esquerdo dw 0
amarelo_esquerdo dw 0
verde_esquerdo dw 0
azul_claro_esquerdo dw 0
azul_escuro_esquerdo dw 0


; Posição da raquete direita
x1_raquete_direita   dw 590     ; coordenada X do canto superior
y1_raquete_direita     dw 200    ; coordenada Y do canto superior
x2_raquete_direita  dw 600     ; coordenada X do canto inferior
y2_raquete_direita  dw 300    ; coordenada Y do canto inferior

vermelho_direito dw 0
amarelo_direito dw 0
verde_direito dw 0
azul_claro_direito dw 0
azul_escuro_direito dw 0

kb_data EQU 60h  				; PORTA DE LEITURA DE TECLADO
kb_ctl  EQU 61h  				; PORTA DE RESET PARA PEDIR NOVA INTERRUPCAO
pictrl  EQU 20h					; PORTA DO PIC DE TECLADO
eoi     EQU 20h					; Byte de final de interrupção PIC - resgistrador
INT9    EQU 9h					; Interrupção por hardware do teclado
cs_dos  DW  1					; Variável de 2 bytes para armacenar o CS da INT 9
offset_dos  DW 1				; Variável de 2 bytes para armacenar o IP da INT 9
tecla_u db 0
tecla   resb  8					; Variável de 8 bytes para armacenar a tecla presionada. Só precisa de 2 bytes!	 
p_i     dw  0   				; Indice p/ Interrupcao (Incrementa na ISR quando pressiona/solta qualquer tecla)  
p_t     dw  0   				; Indice p/ Interrupcao (Incrementa após retornar da ISR quando pressiona/solta qualquer tecla)    
teclasc DB  0,0,13,10,'$'		; Variável tipo char para printar o código Make/Break em hexadecimal


;*************************************************************************
segment stack stack
		DW 		512
stacktop:
