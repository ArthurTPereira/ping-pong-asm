global bloco

extern line

bloco:
    PUSH 	BP
    MOV	 	BP,SP

;Resgata os valores das coordenadas	previamente definidas antes de chamar a funcao line
    MOV		AX,[bp+10]  ;x1
    MOV		BX,[bp+8]   ;y1 
    MOV		CX,[bp+6]   ;x2 
    MOV		DX,[bp+4]   ;y2

    

    PUSH    AX
    PUSH    BX
    PUSH    AX
    PUSH    DX
    CALL    line

    PUSH    AX
    PUSH    DX
    PUSH    CX
    PUSH    DX
    CALL    line

    PUSH    CX
    PUSH    DX
    PUSH    CX
    PUSH    BX
    CALL    line

    PUSH    CX
    PUSH    BX
    PUSH    AX
    PUSH    BX
    CALL    line

    POP     BP
    RET



    ; MOV 	AX,0
	; PUSH	AX
	; MOV		AX, 5
	; PUSH	AX
	; MOV		AX, 0
	; PUSH	AX
	; MOV 	AX, 90
	; PUSH 	AX
	; CALL 	line

	; MOV 	AX,0
	; PUSH	AX
	; MOV		AX, 90
	; PUSH	AX
	; MOV		AX, 20
	; PUSH	AX
	; MOV 	AX, 90
	; PUSH 	AX
	; CALL 	line

	; MOV 	AX,20
	; PUSH	AX
	; MOV		AX, 90
	; PUSH	AX
	; MOV		AX, 20
	; PUSH	AX
	; MOV 	AX, 5
	; PUSH 	AX
	; CALL 	line

	; MOV 	AX,20
	; PUSH	AX
	; MOV		AX, 5
	; PUSH	AX
	; MOV		AX, 0
	; PUSH	AX
	; MOV 	AX, 5
	; PUSH 	AX
	; CALL 	line

    ; RET
