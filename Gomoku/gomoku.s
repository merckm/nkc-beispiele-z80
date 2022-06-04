;****************
;***  Gamaku  ***
;****************
;
; - Gomoku greift auf Routinene im
;   Grundprogramm zurück, kann also
;   nur mit Grundprogramm-EPROM
;   gespielt werden.
;
include ../grundprogramm.asm
;
Variable
MODE	EQU	8707H         ;Merker für Betriebsart
      ;01=S, 10=W
ZW	EQU	87C6H		;Zwischenspeicher
ST2	EQU	87C5H		;Register für Spielebene
M1	EQU	87C3H		;Register, Merker
M0	EQU	87C2H		;Register, Merker
KOR	EQU	87C0H		;Register für Position
P1	EQU	87BEH		;Register für Wert
P2	EQU	87BCH		;Register für Wert
M2	EQU	87BBH		;Register, Merker
KOR1	EQU	87B9H		;Register
X	EQU	87B7H		;X Cursor
Y	EQU	87B5H		;Y Cursor
PHI	EQU	87B3H		;Cursor Winkel
ZAE1	EQU	87B2H		;Zähler für Schritte
ZAE2	EQU	879CH		;Spielstand
AB	EQU	87F0H		;Zwischenspeicher
AC	EQU	87F2H		;Zwischenspeicher
AD	EQU	87F4H		;Zwischenspeicher
;
;
	ORG	8800H
GOMOKU:
RUN:
	LD	HL,CDR		;Die Speicher werden
	LD	DE,871FH	;vorbelegt
	LD	BC,0089H
	LDIR
	LD	HL,864CH
	LD	(KOR1),HL
	LD	HL,863CH
	LD	(KOR),HL
	LD	A,00H
	LD	(M2),A
	LD	(P2),A
	LD	(MODE),A
	LD	(M1),A
	LD	(M0),A
	LD	(ZW),A
	LD	(ST2),A
	LD	(PHI),A
	JP	RUN1
;
SET1:
	PUSH	DE		;setzen des
	RR	D		;Steins
	RR	E
	CALL	MOVETO
	POP	DE
	CALL	04F3H
	LD	(8059H),	; Turtle: tur1x
	EX	DE,HL
	CALL	04F3H		;
	LD	(805BH),HL	; Turtel: tur1y
	LD	L,C
	LD	H,B
	CALL	0280H		;
	LD	(805DH),HL	; Turtel: tur1phi
	XOR	A		; Clear A
	LD	(805BH),A	; Turtel: tur1y
	LD	A,00H
	LD	(804BH),A	; vzstor (aus sin/cos)
	RET
FELD:
	LD	HL,CLR		;Bewegen
	LD	DE,01D0H	;im		(464)
	LD	BC,0000H	;Feld
	CALL	SET1
	LD	HL,0010H	; 16 Felder
	CALL	SCHLEIFE
	LD	HL,0010H	; 16 Felder
	CALL	SCHLEIFE
	LD	HL,0004H	; Quadrat 4 Seiten
	CALL	SCHLEIFE
	LD	HL,001AH	;26
	CALL	SCHREITE
	LD	HL,005AH	;90
	CALL	DREHE
	CALL	ENDSCHLEIFE
	LD	HL,001AH	;26
	CALL	SCHREITE
	CALL	ENDSCHLEIFE
	LD	HL,0FE60H	;-416
	CALL	SCHREITE	
	LD	HL,0FFA6H	;-90
	CALL	DREHE
	CALL	HEBE
	LD	HL,001AH	; 26
	CALL 	SCHREITE
	CALL	SENKE
	LD	HL,005AH	;90
	CALL	DREHE
	CALL	ENDSCHLEIFE
	RET
;
AUSWS:
	LD	HL,8600H	;Feld zeichnen
	LD	(AD),HL
	LD	HL,0035H	;53
	LD	(AB),HL
	LD	HL,00EBH	;235
	LD	(AC),HL
	LD	A,042H
	CALL	0243H
	LD	HL,0010H	; 16 Felder
	CALL	SCHLEIFE
	LD	HL,0010H	; 16 Felder
	CALL	SCHLEIFE
	LD	HL,(AD)
	LD	A,(HL)
	INC	HL
	LD	(AD),HL
	CP	01H
	JP	NZ,L1
	LD	HL,(AC)
	ADD	HL,HL
	EX	DE,HL
	LD	HL,(AB)
	LD	BC,0000H
	CALL	SET1
	LD	HL,0004H
	CALL	SCHLEIFE
	LD	HL,SCHLEIFE	; 16???
	CALL	SCHREITE
	LD	HL,005AH	; 90
	CALL	DREHE
	CALL	ENDSCHLEIFE
	JP	L2
L1:
	CP	10H
	JP	NZ,L2
	LD	HL,(AB)
	LD	DE,(AC)
	CALL	MOVETO
	LD	A,0BH		; Command Draw: 4x4 Block
	CALL	WAIT
	OUT	(70H),A		; GDP 
L2:
	LD	HL,(AB)
	LD	DE,001AH	; 26
	ADD	HL,DE		; Increase HL to next x field
	LD	(AB),HL		; Store in AB	
	CALL	ENDSCHLEIFE
	LD	HL,(AC)
	LD	DE,0FFF3H	; -13
	ADD	HL,DE		; Decrease HL to next y field
	LD	(AC),HL		; Store in AB	
	LD	HL,0035H	; Load first x (53) into AB
	LD	(AB),HL		; Store in AB	
	CALL	ENDSCHLEIFE
	RET
;
;
CHECK:
	PUSH	HL
	PUSH	AF		; Register retten
	POP	HL
	BIT	4,L1		; Halfbit
	JR	Z,L3		; wenn Null dann L3
	SCF			; Set carry flag
L3:
	POP	HL
	RET
;
POS0:
	PUSH	HL		; Register
	PUSH	DE		; retten
	PUSH	BC
	LD	B,04H		; 4 mal
	LD	D,(IX+00H)	; get Wert für Richtung
	INC	IX
	LD	E,(IX+00H)
	INC	IX
L50:
	LD	A,L
	SUB	D		; subtrahieren
	CALL	CHECK		; an den Rand gekommen
	JR	C,L4
	ADD	A,E		; addieren
	CALL	CHECK		; an den Rand gekommen
	JR	C,L4
	LD	L,A		; in HL Position
				; von neuem Platz
	LD	A,(HL)
	OR	A
	JR	NZ,L5		; JR if not zero
	LD	A,010H		; leerer Platz
L7:	LD	B,01H		; Ende
	JR	L6
L4:	LD	A,00H		; 0 Punkt
	JR	L7
L5:	LD	C,A
	LD	A,(MODE)
	CP	C
	JR	NZ,L4		; JR wenn Stein vom
				; Gegner
	LD	A,01H		; eigener Stein
L6:	LD	C,A
	LD	A,(ZW)
	ADD	A,C		; Summieren
	LD	(ZW),A
	DJNZ	L50		; 4 mal
	POP	BC
	POP	DE		; get Register
	POP	HL
	RET
;
POS1:	PUSH	IX		; Register retten
	PUSH	BC
	LD	DE,0000H
	LD	B,04H
	LD 	IX,TAB		; Set Anfang Tab.
L14:	LD	A,00H
	LD	(ZW),A		; Clear ZW
	CALL	POS0		; 1. Richtung
			