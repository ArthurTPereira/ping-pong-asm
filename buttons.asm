
global desenha_botoes, desenha_botoes_sim_nao
extern line

; 1 botao
desenha_botoes:
		MOV 	AX, 70
		PUSH 	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	AX, 190
		PUSH	AX
		MOV 	AX, 280
		PUSH 	AX
		CALL 	line

		MOV 	AX, 70
		PUSH 	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	AX, 70
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		CALL 	line

		MOV 	AX, 70
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 190
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		CALL 	line

		MOV 	AX, 190
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 190
		PUSH	AX
		MOV 	AX, 280
		PUSH 	AX
		CALL 	line


; 2 botao
		MOV 	AX, 260
		PUSH 	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	AX, 380
		PUSH	AX
		MOV 	AX, 280
		PUSH 	AX
		CALL 	line

		MOV 	AX, 260
		PUSH 	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	AX, 260
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		CALL 	line

		MOV 	AX, 260
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 380
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		CALL 	line

		MOV 	AX, 380
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 380
		PUSH	AX
		MOV 	AX, 280
		PUSH 	AX
		CALL 	line

		MOV 	AX, 450
		PUSH 	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	AX, 570
		PUSH	AX
		MOV 	AX, 280
		PUSH 	AX
		CALL 	line

		MOV 	AX, 450
		PUSH 	AX
		MOV 	AX, 280
		PUSH 	AX
		MOV 	AX, 450
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		CALL 	line

		MOV 	AX, 450
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 570
		PUSH	AX
		MOV 	AX, 200
		PUSH 	AX
		CALL 	line

		MOV 	AX, 570
		PUSH 	AX
		MOV 	AX, 200
		PUSH 	AX
		MOV 	AX, 570
		PUSH	AX
		MOV 	AX, 280
		PUSH 	AX
		CALL 	line

		RET


desenha_botoes_sim_nao:
		MOV 	AX, 170
		PUSH 	AX
		MOV 	AX, 260
		PUSH 	AX
		MOV 	AX, 250
		PUSH	AX
		MOV 	AX, 260
		PUSH 	AX
		CALL 	line

		MOV 	AX, 250
		PUSH 	AX
		MOV 	AX, 260
		PUSH 	AX
		MOV 	AX, 250
		PUSH	AX
		MOV 	AX, 210
		PUSH 	AX
		CALL 	line

		MOV 	AX, 170
		PUSH 	AX
		MOV 	AX, 210
		PUSH 	AX
		MOV 	AX, 250
		PUSH	AX
		MOV 	AX, 210
		PUSH 	AX
		CALL 	line

		
		MOV 	AX, 170
		PUSH 	AX
		MOV 	AX, 210
		PUSH 	AX
		MOV 	AX, 170
		PUSH	AX
		MOV 	AX, 260
		PUSH 	AX
		CALL 	line



; nao

		MOV 	AX, 360
		PUSH 	AX
		MOV 	AX, 260
		PUSH 	AX
		MOV 	AX, 450
		PUSH	AX
		MOV 	AX, 260
		PUSH 	AX
		CALL 	line

		MOV 	AX, 450
		PUSH 	AX
		MOV 	AX, 260
		PUSH 	AX
		MOV 	AX, 450
		PUSH	AX
		MOV 	AX, 210
		PUSH 	AX
		CALL 	line

		MOV 	AX, 360
		PUSH 	AX
		MOV 	AX, 210
		PUSH 	AX
		MOV 	AX, 450
		PUSH	AX
		MOV 	AX, 210
		PUSH 	AX
		CALL 	line

		
		MOV 	AX, 360
		PUSH 	AX
		MOV 	AX, 210
		PUSH 	AX
		MOV 	AX, 360
		PUSH	AX
		MOV 	AX, 260
		PUSH 	AX
		CALL 	line


		RET