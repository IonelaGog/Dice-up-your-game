
_display:

;zaruri.c,21 :: 		void display(char n)
;zaruri.c,23 :: 		DDRD = 0b11111111;
	LDI        R27, 255
	OUT        DDRD+0, R27
;zaruri.c,24 :: 		PORTD &= 0b00000000;
	IN         R16, PORTD+0
	ANDI       R16, 0
	OUT        PORTD+0, R16
;zaruri.c,26 :: 		switch(n)
	JMP        L_display0
;zaruri.c,28 :: 		case 0:PORTD|=0b00111111;break;               //codifica reprezentarea cifrei 0
L_display2:
	IN         R16, PORTD+0
	ORI        R16, 63
	OUT        PORTD+0, R16
	JMP        L_display1
;zaruri.c,29 :: 		case 1:PORTD|=0b00000110;break;               //codifica reprezentarea cifrei 1
L_display3:
	IN         R16, PORTD+0
	ORI        R16, 6
	OUT        PORTD+0, R16
	JMP        L_display1
;zaruri.c,30 :: 		case 2:PORTD|=0b01011011;break;               //codifica reprezentarea cifrei 2
L_display4:
	IN         R16, PORTD+0
	ORI        R16, 91
	OUT        PORTD+0, R16
	JMP        L_display1
;zaruri.c,31 :: 		case 3:PORTD|=0b01001111;break;               //codifica reprezentarea cifrei 3
L_display5:
	IN         R16, PORTD+0
	ORI        R16, 79
	OUT        PORTD+0, R16
	JMP        L_display1
;zaruri.c,32 :: 		case 4:PORTD|=0b01100110;break;               //codifica reprezentarea cifrei 4
L_display6:
	IN         R16, PORTD+0
	ORI        R16, 102
	OUT        PORTD+0, R16
	JMP        L_display1
;zaruri.c,33 :: 		case 5:PORTD|=0b01101101;break;               //codifica reprezentarea cifrei 5
L_display7:
	IN         R16, PORTD+0
	ORI        R16, 109
	OUT        PORTD+0, R16
	JMP        L_display1
;zaruri.c,34 :: 		case 6:PORTD|=0b01111101;break;               //codifica reprezentarea cifrei 6
L_display8:
	IN         R16, PORTD+0
	ORI        R16, 125
	OUT        PORTD+0, R16
	JMP        L_display1
;zaruri.c,35 :: 		}
L_display0:
	LDI        R27, 0
	CP         R2, R27
	BRNE       L__display94
	JMP        L_display2
L__display94:
	LDI        R27, 1
	CP         R2, R27
	BRNE       L__display95
	JMP        L_display3
L__display95:
	LDI        R27, 2
	CP         R2, R27
	BRNE       L__display96
	JMP        L_display4
L__display96:
	LDI        R27, 3
	CP         R2, R27
	BRNE       L__display97
	JMP        L_display5
L__display97:
	LDI        R27, 4
	CP         R2, R27
	BRNE       L__display98
	JMP        L_display6
L__display98:
	LDI        R27, 5
	CP         R2, R27
	BRNE       L__display99
	JMP        L_display7
L__display99:
	LDI        R27, 6
	CP         R2, R27
	BRNE       L__display100
	JMP        L_display8
L__display100:
L_display1:
;zaruri.c,36 :: 		}
L_end_display:
	RET
; end of _display

_init_adc:

;zaruri.c,38 :: 		void init_adc()
;zaruri.c,40 :: 		ADMUX = 0b01000000;            //Referinta - AVCC
	LDI        R27, 64
	OUT        ADMUX+0, R27
;zaruri.c,41 :: 		ADCSRA = 0b10000111;           //Activare ADC; Prescaler = 128;
	LDI        R27, 135
	OUT        ADCSRA+0, R27
;zaruri.c,42 :: 		}
L_end_init_adc:
	RET
; end of _init_adc

_readADC:

;zaruri.c,45 :: 		int readADC (char ch){
;zaruri.c,46 :: 		ADMUX &= 0b11100000;             //Reseteazã canalul de conversie
	IN         R16, ADMUX+0
	ANDI       R16, 224
	OUT        ADMUX+0, R16
;zaruri.c,47 :: 		ADMUX |= ch;                     //Seteazã canalul conversiei
	OR         R16, R2
	OUT        ADMUX+0, R16
;zaruri.c,48 :: 		ADCSRA |= (1<<6);                //Începe conversia
	IN         R27, ADCSRA+0
	SBR        R27, 64
	OUT        ADCSRA+0, R27
;zaruri.c,49 :: 		while(ADCSRA & (1<<6));             //Asteaptã finalizarea conversiei
L_readADC9:
	IN         R16, ADCSRA+0
	SBRS       R16, 6
	JMP        L_readADC10
	JMP        L_readADC9
L_readADC10:
;zaruri.c,50 :: 		adc_l = ADCL;
	IN         R16, ADCL+0
	STS        _adc_l+0, R16
;zaruri.c,51 :: 		adc_h = ADCH;
	IN         R16, ADCH+0
	STS        _adc_h+0, R16
;zaruri.c,52 :: 		return ((adc_h << 8) | adc_l);
	LDS        R16, _adc_h+0
	MOV        R19, R16
	CLR        R18
	LDS        R16, _adc_l+0
	LDI        R17, 0
	OR         R16, R18
	OR         R17, R19
;zaruri.c,53 :: 		}
L_end_readADC:
	RET
; end of _readADC

_init_timer:

;zaruri.c,56 :: 		void init_timer()
;zaruri.c,58 :: 		SREG = 1<<7;                  //Global Interrupt Enable
	LDI        R27, 128
	OUT        SREG+0, R27
;zaruri.c,59 :: 		TCCR0 = 0b00001011;           //CTC(Clear Timer on Compare Match)-3,6
	LDI        R27, 11
	OUT        TCCR0+0, R27
;zaruri.c,60 :: 		TCNT0 = 0;                    //se reseteaza la 0 registrul de numarare
	LDI        R27, 0
	OUT        TCNT0+0, R27
;zaruri.c,61 :: 		OCR0 = 125;                   //valoarea la care se reseteaza TCNT0 la egalitatea dintre TCNT0 si OCR0
	LDI        R27, 125
	OUT        OCR0+0, R27
;zaruri.c,62 :: 		TIMSK |= 0b00000010;          //daca TCNT0=OCR0, se genereaza o intrerupere
	IN         R27, TIMSK+0
	SBR        R27, 2
	OUT        TIMSK+0, R27
;zaruri.c,63 :: 		}
L_end_init_timer:
	RET
; end of _init_timer

_Timer0_OC_ISR:
	PUSH       R30
	PUSH       R31
	PUSH       R27
	IN         R27, SREG+0
	PUSH       R27

;zaruri.c,67 :: 		void Timer0_OC_ISR() iv IVT_ADDR_TIMER0_COMP {
;zaruri.c,68 :: 		if (ms == pot)
	PUSH       R2
	LDS        R18, _ms+0
	LDS        R19, _ms+1
	LDS        R16, _pot+0
	LDS        R17, _pot+1
	CP         R18, R16
	CPC        R19, R17
	BREQ       L__Timer0_OC_ISR105
	JMP        L_Timer0_OC_ISR11
L__Timer0_OC_ISR105:
;zaruri.c,70 :: 		n++;
	LDS        R16, _n+0
	LDS        R17, _n+1
	SUBI       R16, 255
	SBCI       R17, 255
	STS        _n+0, R16
	STS        _n+1, R17
;zaruri.c,71 :: 		switch(n){
	JMP        L_Timer0_OC_ISR12
;zaruri.c,72 :: 		case 1:{ PORTA=0b00010000;
L_Timer0_OC_ISR14:
	LDI        R27, 16
	OUT        PORTA+0, R27
;zaruri.c,73 :: 		pot=readADC(6)/4;
	LDI        R27, 6
	MOV        R2, R27
	CALL       _readADC+0
	LDI        R20, 4
	LDI        R21, 0
	CALL       _Div_16x16_S+0
	MOVW       R16, R22
	STS        _pot+0, R16
	STS        _pot+1, R17
;zaruri.c,74 :: 		break;
	JMP        L_Timer0_OC_ISR13
;zaruri.c,76 :: 		case 2:{ PORTA=0b00100000;
L_Timer0_OC_ISR15:
	LDI        R27, 32
	OUT        PORTA+0, R27
;zaruri.c,77 :: 		pot=readADC(6)/4;
	LDI        R27, 6
	MOV        R2, R27
	CALL       _readADC+0
	LDI        R20, 4
	LDI        R21, 0
	CALL       _Div_16x16_S+0
	MOVW       R16, R22
	STS        _pot+0, R16
	STS        _pot+1, R17
;zaruri.c,78 :: 		break;
	JMP        L_Timer0_OC_ISR13
;zaruri.c,80 :: 		case 3:{ PORTA=0b00001000;
L_Timer0_OC_ISR16:
	LDI        R27, 8
	OUT        PORTA+0, R27
;zaruri.c,81 :: 		pot=readADC(6)/4;
	LDI        R27, 6
	MOV        R2, R27
	CALL       _readADC+0
	LDI        R20, 4
	LDI        R21, 0
	CALL       _Div_16x16_S+0
	MOVW       R16, R22
	STS        _pot+0, R16
	STS        _pot+1, R17
;zaruri.c,82 :: 		break;
	JMP        L_Timer0_OC_ISR13
;zaruri.c,84 :: 		case 4:{ PORTA=0b10000000;
L_Timer0_OC_ISR17:
	LDI        R27, 128
	OUT        PORTA+0, R27
;zaruri.c,85 :: 		pot=readADC(6)/4;
	LDI        R27, 6
	MOV        R2, R27
	CALL       _readADC+0
	LDI        R20, 4
	LDI        R21, 0
	CALL       _Div_16x16_S+0
	MOVW       R16, R22
	STS        _pot+0, R16
	STS        _pot+1, R17
;zaruri.c,86 :: 		n=0;
	LDI        R27, 0
	STS        _n+0, R27
	STS        _n+1, R27
;zaruri.c,87 :: 		break;
	JMP        L_Timer0_OC_ISR13
;zaruri.c,89 :: 		}
L_Timer0_OC_ISR12:
	LDS        R16, _n+0
	LDS        R17, _n+1
	CPI        R17, 0
	BRNE       L__Timer0_OC_ISR106
	CPI        R16, 1
L__Timer0_OC_ISR106:
	BRNE       L__Timer0_OC_ISR107
	JMP        L_Timer0_OC_ISR14
L__Timer0_OC_ISR107:
	LDS        R16, _n+0
	LDS        R17, _n+1
	CPI        R17, 0
	BRNE       L__Timer0_OC_ISR108
	CPI        R16, 2
L__Timer0_OC_ISR108:
	BRNE       L__Timer0_OC_ISR109
	JMP        L_Timer0_OC_ISR15
L__Timer0_OC_ISR109:
	LDS        R16, _n+0
	LDS        R17, _n+1
	CPI        R17, 0
	BRNE       L__Timer0_OC_ISR110
	CPI        R16, 3
L__Timer0_OC_ISR110:
	BRNE       L__Timer0_OC_ISR111
	JMP        L_Timer0_OC_ISR16
L__Timer0_OC_ISR111:
	LDS        R16, _n+0
	LDS        R17, _n+1
	CPI        R17, 0
	BRNE       L__Timer0_OC_ISR112
	CPI        R16, 4
L__Timer0_OC_ISR112:
	BRNE       L__Timer0_OC_ISR113
	JMP        L_Timer0_OC_ISR17
L__Timer0_OC_ISR113:
L_Timer0_OC_ISR13:
;zaruri.c,90 :: 		ms = 0;
	LDI        R27, 0
	STS        _ms+0, R27
	STS        _ms+1, R27
;zaruri.c,91 :: 		}
	JMP        L_Timer0_OC_ISR18
L_Timer0_OC_ISR11:
;zaruri.c,92 :: 		else ms++;
	LDS        R16, _ms+0
	LDS        R17, _ms+1
	SUBI       R16, 255
	SBCI       R17, 255
	STS        _ms+0, R16
	STS        _ms+1, R17
L_Timer0_OC_ISR18:
;zaruri.c,93 :: 		}
L_end_Timer0_OC_ISR:
	POP        R2
	POP        R27
	OUT        SREG+0, R27
	POP        R27
	POP        R31
	POP        R30
	RETI
; end of _Timer0_OC_ISR

_LCD0:

;zaruri.c,96 :: 		void LCD0()
;zaruri.c,97 :: 		{      int   i=0;
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
;zaruri.c,98 :: 		Lcd_Init();                        // Initializeaza LCD
	CALL       _Lcd_Init+0
;zaruri.c,99 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,100 :: 		Lcd_Cmd(_LCD_BLINK_CURSOR_ON);
	LDI        R27, 15
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,101 :: 		Lcd_Out(1,1,"Joc de") ;
	LDI        R27, #lo_addr(?lstr1_zaruri+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr1_zaruri+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;zaruri.c,102 :: 		Lcd_Out(2,5,"zaruri") ;
	LDI        R27, #lo_addr(?lstr2_zaruri+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr2_zaruri+0)
	MOV        R5, R27
	LDI        R27, 5
	MOV        R3, R27
	LDI        R27, 2
	MOV        R2, R27
	CALL       _Lcd_Out+0
;zaruri.c,104 :: 		for (i=0;i<=4;i++)
; i start address is: 18 (R18)
	LDI        R18, 0
	LDI        R19, 0
; i end address is: 18 (R18)
L_LCD019:
; i start address is: 18 (R18)
	LDI        R16, 4
	LDI        R17, 0
	CP         R16, R18
	CPC        R17, R19
	BRGE       L__LCD0115
	JMP        L_LCD020
L__LCD0115:
;zaruri.c,106 :: 		Lcd_Cmd(_LCD_MOVE_CURSOR_RIGHT);
	PUSH       R19
	PUSH       R18
	LDI        R27, 20
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,107 :: 		Delay_ms(100);
	LDI        R18, 5
	LDI        R17, 15
	LDI        R16, 242
L_LCD022:
	DEC        R16
	BRNE       L_LCD022
	DEC        R17
	BRNE       L_LCD022
	DEC        R18
	BRNE       L_LCD022
	POP        R18
	POP        R19
;zaruri.c,104 :: 		for (i=0;i<=4;i++)
	MOVW       R16, R18
	SUBI       R16, 255
	SBCI       R17, 255
	MOVW       R18, R16
;zaruri.c,108 :: 		}
; i end address is: 18 (R18)
	JMP        L_LCD019
L_LCD020:
;zaruri.c,109 :: 		Delay_ms(300);
	LDI        R18, 13
	LDI        R17, 45
	LDI        R16, 216
L_LCD024:
	DEC        R16
	BRNE       L_LCD024
	DEC        R17
	BRNE       L_LCD024
	DEC        R18
	BRNE       L_LCD024
	NOP
	NOP
;zaruri.c,110 :: 		Lcd_Cmd(_LCD_CLEAR);
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,111 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	LDI        R27, 12
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,113 :: 		for (i=0;i<=24;i++)
; i start address is: 18 (R18)
	LDI        R18, 0
	LDI        R19, 0
; i end address is: 18 (R18)
L_LCD026:
; i start address is: 18 (R18)
	LDI        R16, 24
	LDI        R17, 0
	CP         R16, R18
	CPC        R17, R19
	BRGE       L__LCD0116
	JMP        L_LCD027
L__LCD0116:
;zaruri.c,115 :: 		Lcd_Out(1,4,"Pe locuri,fiti gata...");
	PUSH       R19
	PUSH       R18
	LDI        R27, #lo_addr(?lstr3_zaruri+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr3_zaruri+0)
	MOV        R5, R27
	LDI        R27, 4
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;zaruri.c,116 :: 		Lcd_Cmd(_LCD_SHIFT_LEFT);
	LDI        R27, 24
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
	POP        R18
	POP        R19
;zaruri.c,117 :: 		Delay_ms(7);
	LDI        R17, 73
	LDI        R16, 185
L_LCD029:
	DEC        R16
	BRNE       L_LCD029
	DEC        R17
	BRNE       L_LCD029
	NOP
	NOP
;zaruri.c,113 :: 		for (i=0;i<=24;i++)
	MOVW       R16, R18
	SUBI       R16, 255
	SBCI       R17, 255
	MOVW       R18, R16
;zaruri.c,118 :: 		}
; i end address is: 18 (R18)
	JMP        L_LCD026
L_LCD027:
;zaruri.c,119 :: 		Lcd_Cmd(_LCD_CLEAR);
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,120 :: 		Lcd_Out(2,5,"Start!!") ;
	LDI        R27, #lo_addr(?lstr4_zaruri+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr4_zaruri+0)
	MOV        R5, R27
	LDI        R27, 5
	MOV        R3, R27
	LDI        R27, 2
	MOV        R2, R27
	CALL       _Lcd_Out+0
;zaruri.c,121 :: 		Delay_ms(300);
	LDI        R18, 13
	LDI        R17, 45
	LDI        R16, 216
L_LCD031:
	DEC        R16
	BRNE       L_LCD031
	DEC        R17
	BRNE       L_LCD031
	DEC        R18
	BRNE       L_LCD031
	NOP
	NOP
;zaruri.c,122 :: 		Lcd_Cmd(_LCD_CLEAR);
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,123 :: 		}
L_end_LCD0:
	POP        R5
	POP        R4
	POP        R3
	POP        R2
	RET
; end of _LCD0

_LCD1:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 4
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;zaruri.c,125 :: 		void LCD1(int crt,int nr1)
;zaruri.c,128 :: 		txt[0] = nr1 / 10 % 10 + '0';
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	MOVW       R16, R28
	STD        Y+2, R16
	STD        Y+3, R17
	PUSH       R5
	PUSH       R4
	PUSH       R3
	PUSH       R2
	LDI        R20, 10
	LDI        R21, 0
	MOVW       R16, R4
	CALL       _Div_16x16_S+0
	MOVW       R16, R22
	LDI        R20, 10
	LDI        R21, 0
	CALL       _Div_16x16_S+0
	MOVW       R16, R24
	POP        R2
	POP        R3
	POP        R4
	POP        R5
	MOV        R18, R16
	SUBI       R18, 208
	LDD        R16, Y+2
	LDD        R17, Y+3
	MOVW       R30, R16
	ST         Z, R18
;zaruri.c,129 :: 		txt[1] = nr1 % 10 + '0';
	MOVW       R16, R28
	SUBI       R16, 255
	SBCI       R17, 255
	STD        Y+2, R16
	STD        Y+3, R17
	PUSH       R3
	PUSH       R2
	LDI        R20, 10
	LDI        R21, 0
	MOVW       R16, R4
	CALL       _Div_16x16_S+0
	MOVW       R16, R24
	POP        R2
	POP        R3
	MOV        R18, R16
	SUBI       R18, 208
	LDD        R16, Y+2
	LDD        R17, Y+3
	MOVW       R30, R16
	ST         Z, R18
;zaruri.c,130 :: 		txt[2] = '\0';
	MOVW       R16, R28
	MOVW       R30, R16
	ADIW       R30, 2
	LDI        R27, 0
	ST         Z, R27
;zaruri.c,131 :: 		if (crt == 1){
	LDI        R27, 0
	CP         R3, R27
	BRNE       L__LCD1118
	LDI        R27, 1
	CP         R2, R27
L__LCD1118:
	BREQ       L__LCD1119
	JMP        L_LCD133
L__LCD1119:
;zaruri.c,132 :: 		Lcd_Cmd(_LCD_CLEAR);
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,134 :: 		Lcd_Out(1,1,"Jucatorul #1");
	LDI        R27, #lo_addr(?lstr5_zaruri+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr5_zaruri+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;zaruri.c,135 :: 		Delay_ms(150);
	LDI        R18, 7
	LDI        R17, 23
	LDI        R16, 107
L_LCD134:
	DEC        R16
	BRNE       L_LCD134
	DEC        R17
	BRNE       L_LCD134
	DEC        R18
	BRNE       L_LCD134
	NOP
;zaruri.c,136 :: 		Lcd_Cmd(_LCD_CLEAR);
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,137 :: 		Lcd_Out(1,1,"Punctaj #1: ");
	LDI        R27, #lo_addr(?lstr6_zaruri+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr6_zaruri+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;zaruri.c,138 :: 		Lcd_Out(2,9,txt);
	MOVW       R16, R28
	MOVW       R4, R16
	LDI        R27, 9
	MOV        R3, R27
	LDI        R27, 2
	MOV        R2, R27
	CALL       _Lcd_Out+0
;zaruri.c,139 :: 		Delay_ms(300);
	LDI        R18, 13
	LDI        R17, 45
	LDI        R16, 216
L_LCD136:
	DEC        R16
	BRNE       L_LCD136
	DEC        R17
	BRNE       L_LCD136
	DEC        R18
	BRNE       L_LCD136
	NOP
	NOP
;zaruri.c,140 :: 		}
	JMP        L_LCD138
L_LCD133:
;zaruri.c,141 :: 		else if (crt == 2){
	LDI        R27, 0
	CP         R3, R27
	BRNE       L__LCD1120
	LDI        R27, 2
	CP         R2, R27
L__LCD1120:
	BREQ       L__LCD1121
	JMP        L_LCD139
L__LCD1121:
;zaruri.c,142 :: 		Lcd_Cmd(_LCD_CLEAR);
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,144 :: 		Lcd_Out(1,1,"Jucatorul #2");
	LDI        R27, #lo_addr(?lstr7_zaruri+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr7_zaruri+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;zaruri.c,145 :: 		Delay_ms(150);
	LDI        R18, 7
	LDI        R17, 23
	LDI        R16, 107
L_LCD140:
	DEC        R16
	BRNE       L_LCD140
	DEC        R17
	BRNE       L_LCD140
	DEC        R18
	BRNE       L_LCD140
	NOP
;zaruri.c,146 :: 		Lcd_Cmd(_LCD_CLEAR);
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,147 :: 		Lcd_Out(1,1,"Punctaj #2: ");
	LDI        R27, #lo_addr(?lstr8_zaruri+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr8_zaruri+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;zaruri.c,148 :: 		Lcd_Out(2,9,txt);
	MOVW       R16, R28
	MOVW       R4, R16
	LDI        R27, 9
	MOV        R3, R27
	LDI        R27, 2
	MOV        R2, R27
	CALL       _Lcd_Out+0
;zaruri.c,149 :: 		Delay_ms(300);
	LDI        R18, 13
	LDI        R17, 45
	LDI        R16, 216
L_LCD142:
	DEC        R16
	BRNE       L_LCD142
	DEC        R17
	BRNE       L_LCD142
	DEC        R18
	BRNE       L_LCD142
	NOP
	NOP
;zaruri.c,150 :: 		}
L_LCD139:
L_LCD138:
;zaruri.c,151 :: 		}
L_end_LCD1:
	POP        R5
	POP        R4
	POP        R3
	POP        R2
	ADIW       R28, 3
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _LCD1

_LCD2:

;zaruri.c,153 :: 		void LCD2(int numar){
;zaruri.c,154 :: 		if (numar == 1)
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	LDI        R27, 0
	CP         R3, R27
	BRNE       L__LCD2123
	LDI        R27, 1
	CP         R2, R27
L__LCD2123:
	BREQ       L__LCD2124
	JMP        L_LCD244
L__LCD2124:
;zaruri.c,156 :: 		Lcd_Cmd(_LCD_CLEAR);
	PUSH       R3
	PUSH       R2
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,157 :: 		Lcd_Out(1,1,"A castigat #1");
	LDI        R27, #lo_addr(?lstr9_zaruri+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr9_zaruri+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
	POP        R2
	POP        R3
;zaruri.c,158 :: 		Delay_ms(300);
	LDI        R18, 13
	LDI        R17, 45
	LDI        R16, 216
L_LCD245:
	DEC        R16
	BRNE       L_LCD245
	DEC        R17
	BRNE       L_LCD245
	DEC        R18
	BRNE       L_LCD245
	NOP
	NOP
;zaruri.c,159 :: 		}
L_LCD244:
;zaruri.c,160 :: 		if (numar == 2)
	LDI        R27, 0
	CP         R3, R27
	BRNE       L__LCD2125
	LDI        R27, 2
	CP         R2, R27
L__LCD2125:
	BREQ       L__LCD2126
	JMP        L_LCD247
L__LCD2126:
;zaruri.c,162 :: 		Lcd_Cmd(_LCD_CLEAR);
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,163 :: 		Lcd_Out(1,1,"A castigat #2");
	LDI        R27, #lo_addr(?lstr10_zaruri+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr10_zaruri+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;zaruri.c,164 :: 		Delay_ms(300);
	LDI        R18, 13
	LDI        R17, 45
	LDI        R16, 216
L_LCD248:
	DEC        R16
	BRNE       L_LCD248
	DEC        R17
	BRNE       L_LCD248
	DEC        R18
	BRNE       L_LCD248
	NOP
	NOP
;zaruri.c,165 :: 		}
L_LCD247:
;zaruri.c,166 :: 		}
L_end_LCD2:
	POP        R5
	POP        R4
	POP        R3
	POP        R2
	RET
; end of _LCD2

_arunc:

;zaruri.c,168 :: 		int arunc(int numar)
;zaruri.c,170 :: 		int zar=0;
;zaruri.c,171 :: 		int ms = 0;
;zaruri.c,172 :: 		zar = (rand()% 6) + 1;          //calculeaza numarul 'la intamplare'  cuprins intre [1,6]
	CALL       _rand+0
	PUSH       R3
	PUSH       R2
	LDI        R20, 6
	LDI        R21, 0
	CALL       _Div_16x16_S+0
	MOVW       R16, R24
	POP        R2
	POP        R3
	MOVW       R18, R16
	SUBI       R18, 255
	SBCI       R19, 255
; zar start address is: 20 (R20)
	MOVW       R20, R18
;zaruri.c,173 :: 		numar = numar+zar;
	MOVW       R16, R18
	ADD        R16, R2
	ADC        R17, R3
	MOVW       R2, R16
;zaruri.c,174 :: 		display(zar);
	PUSH       R3
	PUSH       R2
	MOV        R2, R18
	CALL       _display+0
	POP        R2
	POP        R3
;zaruri.c,175 :: 		if (zar == 6) {
	CPI        R21, 0
	BRNE       L__arunc128
	CPI        R20, 6
L__arunc128:
	BREQ       L__arunc129
	JMP        L_arunc50
L__arunc129:
; zar end address is: 20 (R20)
;zaruri.c,178 :: 		init_timer();
	CALL       _init_timer+0
;zaruri.c,179 :: 		init_adc();
	CALL       _init_adc+0
;zaruri.c,180 :: 		DDRA = 0b10111000;
	LDI        R27, 184
	OUT        DDRA+0, R27
;zaruri.c,181 :: 		SREG |= 1<<7;
	IN         R27, SREG+0
	SBR        R27, 128
	OUT        SREG+0, R27
;zaruri.c,182 :: 		}
L_arunc50:
;zaruri.c,183 :: 		return(numar);
	MOVW       R16, R2
;zaruri.c,184 :: 		}
L_end_arunc:
	RET
; end of _arunc

_main:
	LDI        R27, 255
	OUT        SPL+0, R27
	LDI        R27, 0
	OUT        SPL+1, R27
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 6
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;zaruri.c,191 :: 		void main()
;zaruri.c,193 :: 		int starePB0=0;
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	LDI        R27, 0
	STD        Y+0, R27
	STD        Y+1, R27
	LDI        R27, 0
	STD        Y+2, R27
	STD        Y+3, R27
	LDI        R27, 0
	STD        Y+4, R27
	STD        Y+5, R27
;zaruri.c,194 :: 		int starePB1=0;
;zaruri.c,195 :: 		int starePB2=0;
;zaruri.c,196 :: 		int submit = 0;
;zaruri.c,198 :: 		DDRC = 0b11111111;    //seteazã pinii de iesire
	LDI        R27, 255
	OUT        DDRC+0, R27
;zaruri.c,199 :: 		DDRB = 0b11110000;    //seteazã pinii de iesire
	LDI        R27, 240
	OUT        DDRB+0, R27
;zaruri.c,200 :: 		PORTB = 0b00000000;   //seteaza nivelul logic al pinilor PB0-PB2 cu rezistente de pull-up
	LDI        R27, 0
	OUT        PORTB+0, R27
;zaruri.c,202 :: 		display(0);
	CLR        R2
	CALL       _display+0
;zaruri.c,203 :: 		LCD0();
	CALL       _LCD0+0
;zaruri.c,204 :: 		delay_ms(90);
	LDI        R18, 4
	LDI        R17, 168
	LDI        R16, 12
L_main51:
	DEC        R16
	BRNE       L_main51
	DEC        R17
	BRNE       L_main51
	DEC        R18
	BRNE       L_main51
	NOP
	NOP
;zaruri.c,206 :: 		for(;;)
L_main53:
;zaruri.c,208 :: 		if  ((nr1 < MAX) && (nr2 < MAX))
	LDS        R18, _nr1+0
	LDS        R19, _nr1+1
	LDI        R16, 16
	LDI        R17, 0
	CP         R18, R16
	CPC        R19, R17
	BRLT       L__main131
	JMP        L__main86
L__main131:
	LDS        R18, _nr2+0
	LDS        R19, _nr2+1
	LDI        R16, 16
	LDI        R17, 0
	CP         R18, R16
	CPC        R19, R17
	BRLT       L__main132
	JMP        L__main85
L__main132:
L__main84:
;zaruri.c,210 :: 		if (PINB & (1<<2))
	IN         R16, PINB+0
	SBRS       R16, 2
	JMP        L_main59
;zaruri.c,212 :: 		if (PINB & (1<<1))
	IN         R16, PINB+0
	SBRS       R16, 1
	JMP        L_main60
;zaruri.c,214 :: 		if (starePB1==0)
	LDD        R16, Y+2
	LDD        R17, Y+3
	CPI        R17, 0
	BRNE       L__main133
	CPI        R16, 0
L__main133:
	BREQ       L__main134
	JMP        L_main61
L__main134:
;zaruri.c,216 :: 		starePB1=1;
	LDI        R27, 1
	STD        Y+2, R27
	LDI        R27, 0
	STD        Y+3, R27
;zaruri.c,217 :: 		PORTB ^= (1<<7);
	IN         R16, PORTB+0
	LDI        R27, 128
	EOR        R16, R27
	OUT        PORTB+0, R16
;zaruri.c,218 :: 		nr1=arunc(nr1);
	LDS        R2, _nr1+0
	LDS        R3, _nr1+1
	CALL       _arunc+0
	STS        _nr1+0, R16
	STS        _nr1+1, R17
;zaruri.c,219 :: 		LCD1(1,nr1);
	MOVW       R4, R16
	LDI        R27, 1
	MOV        R2, R27
	LDI        R27, 0
	MOV        R3, R27
	CALL       _LCD1+0
;zaruri.c,220 :: 		}
L_main61:
;zaruri.c,221 :: 		}else
	JMP        L_main62
L_main60:
;zaruri.c,222 :: 		starePB1 = 0;
	LDI        R27, 0
	STD        Y+2, R27
	STD        Y+3, R27
L_main62:
;zaruri.c,224 :: 		if (starePB2 == 0)
	LDD        R16, Y+4
	LDD        R17, Y+5
	CPI        R17, 0
	BRNE       L__main135
	CPI        R16, 0
L__main135:
	BREQ       L__main136
	JMP        L_main63
L__main136:
;zaruri.c,226 :: 		starePB2 = 1;
	LDI        R27, 1
	STD        Y+4, R27
	LDI        R27, 0
	STD        Y+5, R27
;zaruri.c,227 :: 		PORTB ^= (1<<7);
	IN         R16, PORTB+0
	LDI        R27, 128
	EOR        R16, R27
	OUT        PORTB+0, R16
;zaruri.c,229 :: 		}
L_main63:
;zaruri.c,230 :: 		}
	JMP        L_main64
L_main59:
;zaruri.c,233 :: 		starePB2=0;
	LDI        R27, 0
	STD        Y+4, R27
	STD        Y+5, R27
;zaruri.c,234 :: 		}
L_main64:
;zaruri.c,237 :: 		if (PINB & (1<<2))
	IN         R16, PINB+0
	SBRS       R16, 2
	JMP        L_main65
;zaruri.c,239 :: 		if (PINB & (1<<0))
	IN         R16, PINB+0
	SBRS       R16, 0
	JMP        L_main66
;zaruri.c,241 :: 		if (starePB0 == 0)
	LDD        R16, Y+0
	LDD        R17, Y+1
	CPI        R17, 0
	BRNE       L__main137
	CPI        R16, 0
L__main137:
	BREQ       L__main138
	JMP        L_main67
L__main138:
;zaruri.c,243 :: 		starePB0 = 1;
	LDI        R27, 1
	STD        Y+0, R27
	LDI        R27, 0
	STD        Y+1, R27
;zaruri.c,244 :: 		PORTB |= (1<<7);
	IN         R27, PORTB+0
	SBR        R27, 128
	OUT        PORTB+0, R27
;zaruri.c,245 :: 		nr2 = arunc(nr2);
	LDS        R2, _nr2+0
	LDS        R3, _nr2+1
	CALL       _arunc+0
	STS        _nr2+0, R16
	STS        _nr2+1, R17
;zaruri.c,246 :: 		LCD1(2,nr2);
	MOVW       R4, R16
	LDI        R27, 2
	MOV        R2, R27
	LDI        R27, 0
	MOV        R3, R27
	CALL       _LCD1+0
;zaruri.c,247 :: 		}
L_main67:
;zaruri.c,248 :: 		}
	JMP        L_main68
L_main66:
;zaruri.c,249 :: 		else starePB0 = 0;
	LDI        R27, 0
	STD        Y+0, R27
	STD        Y+1, R27
L_main68:
;zaruri.c,251 :: 		if (starePB2 == 0)
	LDD        R16, Y+4
	LDD        R17, Y+5
	CPI        R17, 0
	BRNE       L__main139
	CPI        R16, 0
L__main139:
	BREQ       L__main140
	JMP        L_main69
L__main140:
;zaruri.c,253 :: 		starePB2 = 1;
	LDI        R27, 1
	STD        Y+4, R27
	LDI        R27, 0
	STD        Y+5, R27
;zaruri.c,254 :: 		PORTB ^= (1<<7);
	IN         R16, PORTB+0
	LDI        R27, 128
	EOR        R16, R27
	OUT        PORTB+0, R16
;zaruri.c,256 :: 		}
L_main69:
;zaruri.c,257 :: 		}
	JMP        L_main70
L_main65:
;zaruri.c,260 :: 		starePB2=0;
	LDI        R27, 0
	STD        Y+4, R27
	STD        Y+5, R27
;zaruri.c,261 :: 		PORTB &= (1<<2);
	IN         R16, PORTB+0
	ANDI       R16, 4
	OUT        PORTB+0, R16
;zaruri.c,262 :: 		}
L_main70:
;zaruri.c,263 :: 		}
	JMP        L_main71
;zaruri.c,208 :: 		if  ((nr1 < MAX) && (nr2 < MAX))
L__main86:
L__main85:
;zaruri.c,266 :: 		if ((nr1 == MAX) && (nr2 != MAX))
	LDS        R16, _nr1+0
	LDS        R17, _nr1+1
	CPI        R17, 0
	BRNE       L__main141
	CPI        R16, 16
L__main141:
	BREQ       L__main142
	JMP        L__main88
L__main142:
	LDS        R16, _nr2+0
	LDS        R17, _nr2+1
	CPI        R17, 0
	BRNE       L__main143
	CPI        R16, 16
L__main143:
	BRNE       L__main144
	JMP        L__main87
L__main144:
L__main83:
;zaruri.c,267 :: 		LCD2(1);
	LDI        R27, 1
	MOV        R2, R27
	LDI        R27, 0
	MOV        R3, R27
	CALL       _LCD2+0
;zaruri.c,266 :: 		if ((nr1 == MAX) && (nr2 != MAX))
L__main88:
L__main87:
;zaruri.c,268 :: 		if ((nr1 != MAX) && (nr2 == MAX))
	LDS        R16, _nr1+0
	LDS        R17, _nr1+1
	CPI        R17, 0
	BRNE       L__main145
	CPI        R16, 16
L__main145:
	BRNE       L__main146
	JMP        L__main90
L__main146:
	LDS        R16, _nr2+0
	LDS        R17, _nr2+1
	CPI        R17, 0
	BRNE       L__main147
	CPI        R16, 16
L__main147:
	BREQ       L__main148
	JMP        L__main89
L__main148:
L__main82:
;zaruri.c,269 :: 		LCD2(2);
	LDI        R27, 2
	MOV        R2, R27
	LDI        R27, 0
	MOV        R3, R27
	CALL       _LCD2+0
;zaruri.c,268 :: 		if ((nr1 != MAX) && (nr2 == MAX))
L__main90:
L__main89:
;zaruri.c,270 :: 		if ((nr1 == MAX) && (nr2 == MAX))
	LDS        R16, _nr1+0
	LDS        R17, _nr1+1
	CPI        R17, 0
	BRNE       L__main149
	CPI        R16, 16
L__main149:
	BREQ       L__main150
	JMP        L__main92
L__main150:
	LDS        R16, _nr2+0
	LDS        R17, _nr2+1
	CPI        R17, 0
	BRNE       L__main151
	CPI        R16, 16
L__main151:
	BREQ       L__main152
	JMP        L__main91
L__main152:
L__main81:
;zaruri.c,272 :: 		Lcd_Cmd(_LCD_CLEAR);
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;zaruri.c,273 :: 		Lcd_Out(1,1,"Egalitate!");
	LDI        R27, #lo_addr(?lstr11_zaruri+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr11_zaruri+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;zaruri.c,270 :: 		if ((nr1 == MAX) && (nr2 == MAX))
L__main92:
L__main91:
;zaruri.c,275 :: 		}
L_main71:
;zaruri.c,276 :: 		}
	JMP        L_main53
;zaruri.c,278 :: 		}
L_end_main:
	POP        R5
	POP        R4
	POP        R3
	POP        R2
L__main_end_loop:
	JMP        L__main_end_loop
; end of _main
