
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * CONFIGURAÇÕES PARA GRAVAÇÃO *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 CONFIG OSC = HS, FCMEN = OFF, IESO = OFF, PWRT = ON, BOREN = OFF, BORV = 0
 CONFIG WDT = OFF, WDTPS = 128, MCLRE = ON, LPT1OSC = OFF, PBADEN = OFF
 CONFIG CCP2MX = PORTC, STVREN = ON, LVP = OFF, DEBUG = OFF, XINST = OFF

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * DEFINIÇÃO DAS VARIÁVEIS *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 CBLOCK 0X00
 TEMPO1
 TEMPO0
 CONT1
 CONT2
 CONT3
 CONT4
 CONT5
 CONT6
 LCD1
 LCD2
 LCD3
 LCD4
 LCD5
 LCD6
STATUS_TEMP
WREG_TEMP
BSR_TEMP
 ENDC


; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * DEFINIÇÃO DAS VARIÁVEIS INTERNAS DO PIC *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <P18F4520.INC>
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * CONSTANTES INTERNAS *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

MAX1 EQU .10 
MAX2 EQU .6
MAX3 EQU .3
MAX4 EQU .4

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * ENTRADAS *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#DEFINE BOTAO_0 PORTB,0
#DEFINE BOTAO_1 PORTB,1
#DEFINE BOTAO_2 PORTB,2
#DEFINE BOTAO_3 PORTB,3
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * SAÍDAS *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#DEFINE DISPLAY LATD
#DEFINE RS LATE,0
#DEFINE ENABLE LATE,1

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * VETOR DE RESET DO MICROCONTROLADOR *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 ORG 0X0000
	GOTO CONFIGURACAO

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * VETOR DA INTERRUPÇÃO
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 ORG 0X0008

	MOVFF	WREG,WREG_TEMP
	MOVFF	STATUS,STATUS_TEMP
	MOVFF	BSR,BSR_TEMP
	GOTO	TRATA_TMR0 

TRATA_TMR0 

		MOVLW	0xC2
		MOVWF	TMR0H 
		MOVLW	0xF7
		MOVWF	TMR0L
		BTG			LATC,0
		GOTO		FIM_INT

FIM_INT

		MOVFF	WREG_TEMP,WREG
		MOVFF 	STATUS_TEMP,STATUS
		MOVFF	BSR_TEMP,BSR
		RCALL 	INCREMENTA
		BCF 	INTCON,TMR0IF

		RETFIE 


; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * INICIALIZANDO                                     *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
INICIALIZANDO

	 MOVLW 0X80
	 RCALL ESCREVE
	 BSF RS

	 MOVLW 'I'
	 RCALL ESCREVE
	 MOVLW 'N'
	 RCALL ESCREVE
	 MOVLW 'I'
	 RCALL ESCREVE
	 MOVLW 'C'
	 RCALL ESCREVE
	 MOVLW 'I'
	 RCALL ESCREVE
	 MOVLW 'A'
	 RCALL ESCREVE
	 MOVLW 'N'
	 RCALL ESCREVE
	 MOVLW 'D'
	 RCALL ESCREVE
	 MOVLW 'O'
	 RCALL ESCREVE
	 MOVLW 'A'
	 RCALL ESCREVE
	 MOVLW 'N'
	 RCALL ESCREVE
     MOVLW 'D'
	 RCALL ESCREVE
	 MOVLW 'O'
	 RCALL ESCREVE
     MOVLW '.'
	 RCALL ESCREVE
     MOVLW '.'
	 RCALL ESCREVE
	 MOVLW '.'
	 RCALL ESCREVE
     BCF RS
	MOVLW .500
 	RCALL DELAY_MS
	MOVLW .500
 	RCALL DELAY_MS
	MOVLW .500
 	RCALL DELAY_MS
	MOVLW .500
 	RCALL DELAY_MS

	GOTO MOSTRA_TELA_PRINCIPAL

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * ROTINA DE DELAY *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
DELAY_MS
 MOVWF TEMPO1
 MOVLW .200
 MOVWF TEMPO0
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 DECFSZ TEMPO0,F
 BRA $-.14

 DECFSZ TEMPO1,F
 BRA $-.22
 RETURN
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * CONFIGURA??ES INICIAIS DO DISPLAY *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
INICIALIZACAO_DISPLAY
 MOVLW .30
 RCALL DELAY_MS
 BCF RS
 MOVLW B'00111000'
 RCALL ESCREVE
 MOVLW B'00001100'
 RCALL ESCREVE

 MOVLW B'00000001'
 RCALL ESCREVE
 MOVLW .1
 RCALL DELAY_MS

 MOVLW B'00000110'
 RCALL ESCREVE

 BSF RS 
 RETURN
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * ROTINA DE ESCRITA DE UM CARACTER NO DISPLAY *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
ESCREVE

	 MOVWF DISPLAY
	 NOP
	 BSF ENABLE
	 NOP
 	 NOP
	 BCF ENABLE
	 MOVLW .1
	 RCALL DELAY_MS
	 RETURN


; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * ROTINA INCREMENTA CONTADOR *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
INCREMENTA
	 INCF CONT6,F
	 MOVLW MAX1
	 XORWF CONT6,W
	 BTFSS STATUS,Z
	 RETURN
	 CLRF CONT6
	
	 INCF CONT5,F
	 MOVLW MAX2
	 XORWF CONT5,W
	 BTFSS STATUS,Z
	 RETURN
	 CLRF CONT6
	 CLRF CONT5

	 INCF CONT4,F
	 MOVLW MAX1
	 XORWF CONT4,W
	 BTFSS STATUS,Z
	 RETURN
	 CLRF CONT6
	 CLRF CONT5
	 CLRF CONT4

	 INCF CONT3,F
	 MOVLW MAX2
	 XORWF CONT3,W
	 BTFSS STATUS,Z
	 RETURN
	 CLRF CONT6
	 CLRF CONT5
	 CLRF CONT4
	 CLRF CONT3

	 INCF CONT2,F
	 MOVLW MAX1
	 XORWF CONT2,W
	 BTFSS STATUS,Z
	 MOVLW MAX4
	 XORWF CONT2,W
	 BTFSS STATUS,Z
	 RETURN
     CLRF CONT6  
	 CLRF CONT5
	 CLRF CONT4
	 CLRF CONT3
	 CLRF CONT2

	 INCF CONT1,F
	 MOVLW MAX3
	 XORWF CONT1,W
	 BTFSS STATUS,Z
	 RETURN
	 CLRF CONT6
	 CLRF CONT5
     CLRF CONT4
	 CLRF CONT3 
	 CLRF CONT2
	 CLRF CONT1

	 RETURN
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * TABELA PARA CONTAGEM *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
TABELA_7S
	 ANDLW B'00001111'
	 RLNCF WREG,W
	 ADDWF PCL,F
	
	 RETLW '0' ; 0h - 0
	 RETLW '1' ; 1h - 1
	 RETLW '2' ; 2h - 2
	 RETLW '3' ; 3h - 3
	 RETLW '4' ; 4h - 4
	 RETLW '5' ; 5h - 5
	 RETLW '6' ; 6h - 6
	 RETLW '7' ; 7h - 7
	 RETLW '8' ; 8h - 8
	 RETLW '9' ; 9h - 9
	 RETURN
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * ROTINA DE ESCRITA DA TELA PRINCIPAL *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MOSTRA_TELA_PRINCIPAL

	 CLRF CONT1
	 CLRF CONT2
	 CLRF CONT3
	 CLRF CONT4
	 CLRF CONT5
	 CLRF CONT6
	 BCF RS
	 MOVLW 0X01
	 RCALL ESCREVE
	 MOVLW .1
	 RCALL DELAY_MS
	
	 MOVLW 0X80
	 RCALL ESCREVE
	 BSF RS

	 MOVLW ' '
	 RCALL ESCREVE

	 
	 MOVLW 0X86
	 RCALL ESCREVE
	 BSF RS

	 MOVLW '"'
	 RCALL ESCREVE
	 MOVLW 'C'
	 RCALL ESCREVE
	 MOVLW 'R'
	 RCALL ESCREVE
	 MOVLW 'O'
	 RCALL ESCREVE
	 MOVLW 'N'
	 RCALL ESCREVE
	 MOVLW 'O'
	 RCALL ESCREVE
	 MOVLW 'M'
	 RCALL ESCREVE
	 MOVLW 'E'
	 RCALL ESCREVE
	 MOVLW 'T'
	 RCALL ESCREVE
	 MOVLW 'R'
	 RCALL ESCREVE
	 MOVLW 'O'
	 RCALL ESCREVE
	 MOVLW '"'
	 RCALL ESCREVE

	 BCF RS
	 MOVLW 0XC0
     RCALL ESCREVE
     BSF RS
	 MOVLW '0'
	 RCALL ESCREVE
	 MOVLW '0'
	 RCALL ESCREVE
	 MOVLW ':'
	 RCALL ESCREVE
	 MOVLW '0'
	 RCALL ESCREVE
	 MOVLW '0'
	 RCALL ESCREVE
	 MOVLW ':'
	 RCALL ESCREVE
	 MOVLW '0'
	 RCALL ESCREVE
	 MOVLW '0'
	 RCALL ESCREVE
		
	 BCF RS
	 MOVLW 0XC8
     RCALL ESCREVE
     BSF RS

	 MOVLW ' '
	 RCALL ESCREVE
	 MOVLW '1'
	 RCALL ESCREVE
	 MOVLW '-'
	 RCALL ESCREVE
	 MOVLW 'S'
	 RCALL ESCREVE
	 MOVLW 'T'
	 RCALL ESCREVE
	 MOVLW 'A'
	 RCALL ESCREVE
	 MOVLW 'R'
	 RCALL ESCREVE
	 MOVLW 'T'
	 RCALL ESCREVE


INICIO

	 BCF	TRISC,0
	 BCF	LATC,0
	 MOVLW	0xC2
	 MOVWF	TMR0H
	 MOVLW	0xF7
	 MOVWF	TMR0L
	 MOVLW	B'10000110'
	 MOVWF  T0CON
	 BSF	INTCON, T0IE
	 BSF	INTCON, GIE


	 GOTO INICIO_CONT

INICIO_CONT

	 BTFSS BOTAO_0
	 GOTO CONF
	 BTFSS PORTB,2
	 GOTO TRATA_BOTAO_2
	 	 
	 
	 GOTO INICIO_CONT

VERIFICA_TURBO

	BTFSS PORTB,3
	GOTO TRATA_BOTAO_3

	
ZERA
	
	 
	 GOTO VERIFICA_TURBO
	 BCF RS
	 MOVLW 0X82
	 RCALL ESCREVE
	 BSF RS

	 MOVLW '1'
	 RCALL ESCREVE
	 MOVLW '-'
	 RCALL ESCREVE
	 MOVLW 'C'
	 RCALL ESCREVE
	 MOVLW 'O'
	 RCALL ESCREVE
	 MOVLW 'N'
	 RCALL ESCREVE
	 MOVLW 'T'
	 RCALL ESCREVE
	 MOVLW 'I'
	 RCALL ESCREVE
	 MOVLW 'N'
	 RCALL ESCREVE
	 MOVLW 'U'
	 RCALL ESCREVE
	 MOVLW 'A'
	 RCALL ESCREVE
	 MOVLW 'R'
	 RCALL ESCREVE
	 MOVLW ' '
	 RCALL ESCREVE
	 MOVLW ' '
	 RCALL ESCREVE
	 MOVLW ' '
	 RCALL ESCREVE
	 MOVLW ' '
	 RCALL ESCREVE
	 MOVLW ' '
	 RCALL ESCREVE
	 MOVLW ' '
	 RCALL ESCREVE
	 MOVLW ' '
	 RCALL ESCREVE

	 BCF RS
	 MOVLW 0XC8
     RCALL ESCREVE
     BSF RS

	 MOVLW ' '
	 RCALL ESCREVE
	 MOVLW '3'
	 RCALL ESCREVE
	 MOVLW '-'
	 RCALL ESCREVE
	 MOVLW 'Z'
	 RCALL ESCREVE
	 MOVLW 'E'
	 RCALL ESCREVE
	 MOVLW 'R'
	 RCALL ESCREVE
	 MOVLW 'A'
	 RCALL ESCREVE
	 MOVLW 'R'
	 RCALL ESCREVE


	GOTO INICIO_CONT


CONF

	 BCF RS
	 MOVLW 0X80
	 RCALL ESCREVE
	 BSF RS

	 MOVLW ' '
	 RCALL ESCREVE

	 
	 MOVLW 0X86
	 RCALL ESCREVE
	 BSF RS

	 MOVLW '"'
	 RCALL ESCREVE
	 MOVLW 'C'
	 RCALL ESCREVE
	 MOVLW 'R'
	 RCALL ESCREVE
	 MOVLW 'O'
	 RCALL ESCREVE
	 MOVLW 'N'
	 RCALL ESCREVE
	 MOVLW 'O'
	 RCALL ESCREVE
	 MOVLW 'M'
	 RCALL ESCREVE
	 MOVLW 'E'
	 RCALL ESCREVE
	 MOVLW 'T'
	 RCALL ESCREVE
	 MOVLW 'R'
	 RCALL ESCREVE
	 MOVLW 'O'
	 RCALL ESCREVE
	 MOVLW '"'
	 RCALL ESCREVE
	 BRA CONTADOR_F


CONTADOR_F

	 BCF RS
	 MOVLW 0XC8
     RCALL ESCREVE
     BSF RS


	 MOVLW ' '
	 RCALL ESCREVE
	 MOVLW '2'
	 RCALL ESCREVE
	 MOVLW '-'
	 RCALL ESCREVE
	 MOVLW 'S'
	 RCALL ESCREVE
	 MOVLW 'T'
	 RCALL ESCREVE
	 MOVLW 'O'
	 RCALL ESCREVE
	 MOVLW 'P'
	 RCALL ESCREVE
	 MOVLW ' '
	 RCALL ESCREVE
	

	 BTFSS BOTAO_1
	 BRA  ZERA
	 BTFSS PORTB,2
	 BRA TRATA_BOTAO_2
	 BTFSS PORTB,3
	 BRA TRATA_BOTAO_3

	 MOVF CONT1,W
	 RCALL TABELA_7S
	 MOVWF LCD1
	 BCF RS
	 MOVLW 0XC0
	 RCALL ESCREVE
     BSF RS
     MOVF LCD1,W
     RCALL ESCREVE
         
	 MOVF CONT2,W
	 RCALL TABELA_7S
	 MOVWF LCD2
	 BCF RS
	 MOVLW 0XC1
	 RCALL ESCREVE
	 BSF RS
	 MOVF LCD2,W
	 RCALL ESCREVE

	 MOVF CONT3,W
	 RCALL TABELA_7S
	 MOVWF LCD3
	 BCF RS
	 MOVLW 0XC3
	 RCALL ESCREVE
	 BSF RS
	 MOVF LCD3,W
	 RCALL ESCREVE

	 MOVF CONT4,W
	 RCALL TABELA_7S
	 MOVWF LCD4
	 BCF RS
	 MOVLW 0XC4
	 RCALL ESCREVE
	 BSF RS
	 MOVF LCD4,W
	 RCALL ESCREVE

	 MOVF CONT5,W
	 CALL TABELA_7S
	 MOVWF LCD5
     BCF RS
	 MOVLW 0XC6
	 RCALL ESCREVE
	 BSF RS
	 MOVF LCD5,W
	 RCALL ESCREVE

	 MOVF CONT6,W
	 CALL TABELA_7S
	 MOVWF LCD6
     BCF RS
	 MOVLW 0XC7
	 RCALL ESCREVE
	 BSF RS
	 MOVF LCD6,W
	 RCALL ESCREVE
		 
	
	 GOTO CONTADOR_F

	 RETURN

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * CONFIGURA??ES INICIAIS DE HARDWARE E SOFTWARE *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
CONFIGURACAO

	 MOVLW B'00001111'
	 MOVWF TRISB
	 MOVLW B'00000000'
	 MOVWF TRISD
	 MOVLW B'00000100'
	 MOVWF TRISE
	
	 CLRF CONT1
	 CLRF CONT2
	 CLRF CONT3
 	 CLRF CONT4
	 CLRF CONT5
 	 CLRF CONT6
	 CLRF LATB
	 CLRF LATD
	 CLRF LATE
	 RCALL INICIALIZACAO_DISPLAY
	 BRA INICIALIZANDO 
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; * TRATAMENTO DOS BOTÕES *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
TRATA_BOTAO_2

	 BRA MOSTRA_TELA_PRINCIPAL
	 CLRF CONT1
	 MOVF CONT1,W
	 CALL TABELA_7S
	 MOVWF LCD1

     BCF RS
	 MOVLW 0XC0
	 RCALL ESCREVE
	 BSF RS
	 MOVF LCD1,W
	 RCALL ESCREVE

     CLRF CONT2
	 MOVF CONT2,W
	 CALL TABELA_7S
	 MOVWF LCD2
     BCF RS
	 MOVLW 0XC1
	 RCALL ESCREVE
	 BSF RS
	 MOVF LCD2,W
	 RCALL ESCREVE

	 CLRF CONT3
	 MOVF CONT3,W
	 CALL TABELA_7S
	 MOVWF LCD3
     BCF RS
	 MOVLW 0XC3
	 RCALL ESCREVE
	 BSF RS
	 MOVF LCD3,W
	 RCALL ESCREVE

	 CLRF CONT4
	 MOVF CONT4,W
	 CALL TABELA_7S
	 MOVWF LCD4
     BCF RS
	 MOVLW 0XC4
	 RCALL ESCREVE
	 BSF RS
	 MOVF LCD4,W
	 RCALL ESCREVE

     CLRF CONT5
	 MOVF CONT5,W
	 CALL TABELA_7S
	 MOVWF LCD5
     BCF RS
	 MOVLW 0XC6
	 RCALL ESCREVE
	 BSF RS
	 MOVF LCD5,W
	 RCALL ESCREVE

	 CLRF CONT6
	 MOVF CONT6,W
	 CALL TABELA_7S
	 MOVWF LCD6
     BCF RS
	 MOVLW 0XC7
	 RCALL ESCREVE
	 BSF RS
	 MOVF LCD6,W
	 RCALL ESCREVE
	 GOTO INICIO_CONT

TRATA_BOTAO_3
	  BCF RS
	 MOVLW 0XC8
     RCALL ESCREVE
     BSF RS


	 MOVLW ' '
	 RCALL ESCREVE
	 MOVLW 'T'
	 RCALL ESCREVE
	 MOVLW 'U'
	 RCALL ESCREVE
	 MOVLW 'R'
	 RCALL ESCREVE
	 MOVLW 'B'
	 RCALL ESCREVE
	 MOVLW 'O'
	 RCALL ESCREVE
	 MOVLW ' '
	 RCALL ESCREVE
	 MOVLW ' '
	 RCALL ESCREVE

	 MOVLW .1
	 RCALL DELAY_MS
	 RCALL INCREMENTA
	 GOTO CONTADOR_F

	 END