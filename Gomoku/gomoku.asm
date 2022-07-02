;****************
;***  Gamaku  ***
;****************
;
; - Gomoku greift auf Routinene im
;   Grundprogramm zurück, kann also
;   nur mit Grundprogramm-EPROM
;   gespielt werden.
;
	.include  ../Include/z80grund.asm
;
; Variable
MODE	=	87D7H		;Merker für Betriebsart
     				;01=S, 10=W
ZW	=	87C6H		;Zwischenspeicher
ST2	=	87C5H		;Register für Spielebene
M1	=	87C3H		;Register, Merker
M0	=	87C2H		;Register, Merker
KOR	=	87C0H		;Register für Position
P1	=	87BEH		;Register für Wert
P2	=	87BCH		;Register für Wert
M2	=	87BBH		;Register, Merker
KOR1	=	87B9H		;Register
X	=	87B7H		;X Cursor
Y	=	87B5H		;Y Cursor
PHI	=	87B3H		;Cursor Winkel
ZAE1	=	87B2H		;Zähler für Schritte
ZAE2	=	879CH		;Spielstand
AB	=	87F0H		;Zwischenspeicher
AC	=	87F2H		;Zwischenspeicher
AD	=	87F4H		;Zwischenspeicher
;
;
	ORG	8800H
GOMOKU:
RUN:
	LD	HL,COR		;Die Speicher werden
	LD	DE,871CH	;vorbelegt
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
	LD	(8059H),HL	; Turtle: tur1x
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
	BIT	4,L		; Halfbit
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
	CALL	POS0		; Richtung 180 Grad
	LD	A,(ZW)
	AND	0FH
	CP	04H		; 4 Steine ?
	JR	C,L8
	LD	A,(ST2)
	OR	A
	JR	NZ,L9		; JR wenn nicht null
	LD	(IY+00H),L	; Set Position
	INC	IY
	LD	A,(MODE)	; Set Mode
	LD	(IY+00h),A	
	INC	IY
	JR	L10		; ret
L9:	LD	DE,0FFFFH	; größter Wert
	JR	L10
L8:	LD	A,(ZW)
	AND	0F0H
	JR	Z,L11
	LD	A,(ZW)
	AND	0FH
	CP	03H		; 3 in einer Reihe
	JR	NZ,L12
	LD	A,D
	ADD	A,20h
	LD	D,A
	LD	A,(ZW)
	BIT	5,A
	JR	Z,L11
	SET	4,D
	JR	L11
L12:	CP	02H		; 2 in einer Reihe
	JR	NZ,L13
	LD	A,D
	ADD	A,02h
	LD	D,A
	LD	A,(ZW)
	BIT	5,A
	JR	Z,L11
	SET	0,D
	JR	L11
L13:	CP	01H		; Einer?
	JR	NZ,L11
	LD	A,E
	ADD	A,20h
	LD	E,A
	LD	A,(ZW)
	BIT	5,A
	JR	Z,L11
	SET	0,E
L11:	DJNZ	L14
L10:	POP	BC
	POP	IX
	RET
;
POS2:
	DB	0FDH,07DH
	LD	(M2),A
	LD	A,00H
	LD	(M0),A
	NOP
	NOP
	NOP
L15:
	INC	HL		; neue Position
	LD	A,H
	CP	087H
	RET	Z		; ret wenn alle
				; Positionen gecheckt
	LD	A,(HL)		; get Platz
	OR	A
	JR	NZ,L15		; JR wenn nicht null
	CALL	POS1
	LD	A,D
	OR	E
	JR	Z,L15
	DB	0FDH,07DH
	NOP
	LD	C,A
	LD	A,(M2)
	CP	C
	JR	NZ,L15		; Wenn 4 in einer Reihe
	PUSH	HL		; nur noch alle Positionen
	LD	HL,(P1)		; auf neue 4. Reie checken
	XOR	A
	SBC	HL,DE
	POP	HL
	JR	NC,L16		; JR wenn neuer Wert kleiner
	LD	(P1),DE		; P1 ist neuer Wert
	LD	A,01H
	LD	(M0),A		;größerer Wert wurde gegunden
	LD	A,00H
	LD	(M1),A		; clear weil 2. Ebene noch
				; nicht gecheckt
	LD	A,(ST2)
	OR	A
	JR	NZ,L15		; JR wenn nicht null
	LD	(KOR),HL	; Position nur abspeichern
				; wenn Stufe 0
	JR	L15
L16:	SCF
	RET	Z		; Ret wenn beide Werte
				; gleich und in zweiter
				; Ebene geprüft werden muß.
	JR	L15
;
CH1:				; für zweite Ebene
	PUSH	HL		; rette akt. Position
	LD	A,(MODE)
	LD	(HL),A		; Position besetzen
	LD	A,01H
	LD	(ST2),A		; zweite Ebene
	LD	HL,(P1)
	PUSH	HL		; rette P1
	LD	HL,(P2)
	LD	(P1),HL
	LD	HL,085FFH	; set Anfang
L17:	CALL	POS2
	JR	C,L17		; JR wenn gleicher Wert
				; gefunden^
	POP	HL
	LD	(P1),HL		; get old P1
	POP	HL		; clear
	LD	A,00H		; reset Position
	LD	(HL),A
	RET
;
POS3:
	LD	A,00H
	LD	(M1),A
	LD	HL,085FFH
L19:	CALL	POS2
	RET	NC		; Ret wenn alle Positionen
				; gecheckt
	LD	A,(M1)
	OR	A
	JR	NZ,L18		; JR wenn Wert schon mal
				; getestet
	LD	A,01H		; jetzt testen
	LD	(M1),A
	PUSH	HL
	LD	HL,0000H
	LD	(P2),HL		; P2 ist Null
	LD	HL,(KOR)	; für Position besetzen
	CALL	CH1
	POP	HL
L18:	CALL	CH1		; Test 2. Wert
	LD	A,00H
	LD	(ST2),A
	LD	A,(M0)
	OR	A
	JR	Z,L19
	LD	(KOR),HL	; wenn zweiter Wert größer
	JR	L19		; bis alle Pos. gecheckt
				; erster Wert zählt
;
CHWS:				; bei Carry ok
	LD	HL,0001H
	LD	(P1),HL
	LD	HL,(KOR1)
	INC 	HL
	LD	(KOR),HL	; definiere Koordinaten
				; für ersten ZUg
	PUSH	IY
	CALL	POS3		; für Computer
	DB	0FDH,07DH	; LD A,IYL Befehel nicht definiert 
				; aber möglich
	POP	BC
	CP	C
	RET	NZ		; wenn 4 in einer Reihe
				; gewonnen
	LD	HL,(KOR)
	PUSH	HL
	LD	A,(MODE)
	LD	(HL),A		; eigene Position setzen
				; damit Vergleich korrekt
	RRCA			; 01 = 10 und 10 = 01
	RRCA
	RRCA
	RRCA
	LD	(MODE),A	; Mode vom Gegner
	LD	HL,(P1)
	PUSH	HL
	PUSH	IY
	CALL	POS3		; für Gegner
	POP	IX
	POP	HL
	POP	BC
	LD	A,00H
	LD	(BC),A		; Position wieder löschen
	LD	A,(MODE)
	RRCA
	RRCA
	RRCA
	RRCA
	LD	(MODE),A	; Mode vom Gegner
	DB	0FDH,07DH	; LD A,IYL
	DB	0DDH,05DH	; LD E,IXL 
	CP	E
	RET	NZ		; wenn 4 in einer Reihe
	LD	DE,(P1)
	BIT	4,D		; Dreierfolge?
	JR	NZ,L20
	BIT	4,H		; Dreierfolge vom Computer?
	JR	NZ,L21
	BIT	0,D		; Zweierfolge beim Gegner?
	JR	Z,L21
	LD	A,D
	AND	0FH
	CP	04H
	JR	NC,L20
L21:	LD	(KOR),BC	; ok Position vom Computer
L20:	SCF
	RET
;
ZUGGEN:				; wenn Carry Spiel zu Ende
				; in Mode steht der Gewinner
	CALL	CHWS
	DB	0FDH,07DH	; LD A,IYL
	OR	A
	RET	Z		; Ret wenn kein Wert da
	LD	IX,8700H	; Anfang der Werte
L24:	DB	0DDH,07DH	; LD A,IXL
	DB	0FDH,045H	; LD B,IYL
	CP	B
	RET	Z
	LD	L,(IX+00H)	; Get Wert Position
	INC	IX
	LD	B,(IX+00H)	; Get Wert (Mode))
	INC	IX
	LD	H,86H
	LD	A,(HL)
	OR	A
	JR	Z,L22		; wenn Platz = 0 dann L22
	CP	B
	JR	NZ,L23		; JR wenn Platz = Mode
	LD	A,B
	LD	(MODE),A
	SCF			; Gegner gewonnen
	RET
L23:	DEC	IY
	DEC	IY
	PUSH	IX
	POP	HL
	NOP
	DEC	IX
	DEC	IX
	DB	0DDH,054H	; LD D,IXH
	DB	0DDH,05DH	; LD E,IXL
	LD	BC,SET
	LDIR			; lösche Wert
	JR	L24		; bis alle Werte gecheckt
L22:	LD	A,(MODE)
	CP	B
	JR	Z,L25
	LD	(KOR),HL	; def. Kor
	JR	L24		; bis alle Werte gecheckt
L25:	LD	(HL),A
	SCF			; Computer hat gewonnen
	RET
; wenn Carry; Spiel zu Ende, d.h. 5 in einer Reihe
; in Kor Position für den errechneten Zug
; wenn Spiel zu Ende steht die Steinfarbe in Mode
; (weiß oder schwarz) des Gewinners
KOREIN:
	LD	A,00H
	LD	(8048H),A
	JR	L26		; am Anfang kein Flip
L35:	LD	HL,(X)
	LD	DE,(Y)
	LD	BC,(PHI)
	CALL	SET		; mit Flip
L26:	CALL	CI		; Bewegung nach oben
	CP	77H		; 'w'
	JR	NZ,L27
	LD	A,(KOR1)
	SUB	A,10H
	LD	(KOR1),A
	LD	HL,005AH	; 90 Grad
	LD	(PHI),HL
	LD	A,00H
L27:	CP	79H		; Bewegung nach unten 'y'
	JR	NZ,L28
	LD	A,(KOR1)
	ADD	A,10H
	LD	(KOR1),A
	LD	HL,0FFA6H	; -90 Grad
	LD	(PHI),HL
	LD	A,00H
L28:	CP	73H		; Bewegung nach rechts 's'
	JR	NZ,L29
	LD	A,(KOR1)
	ADD	A,01H
	LD	(KOR1),A
	LD	HL,0000H	; 0 Grad
	LD	(PHI),HL
	LD	A,00H
L29:	CP	61H		; Bewegung nach links 'a'
	JR	NZ,L30
	LD	A,(KOR1)
	SUB	A,01H
	LD	(KOR1),A
	LD	HL,00B4H	; 180 Grad
	LD	(PHI),HL
	LD	A,00H
L30:	PUSH	AF
	LD	HL,01DDH	; Y=477
	LD	(Y),HL
	LD	HL,003DH	; X=61
	LD	(X),HL
	LD	A,(KOR1)
	AND	0FH
	JR	Z,L31		; wenn Null sonst Error
	NOP
	LD	H,00H
	LD	L,A
	CALL	SCHLEIFE
	LD	DE,001AH	; DE=26
	LD	HL,(X)		; bestimmt x
	ADD	HL,DE
	LD	(X),HL
	CALL	ENDSCHLEIFE
L31:	LD	A,(KOR1)
	SRL	A
	SRL	A
	SRL	A
	SRL	A
	JR	Z,L32		; wenn Null sonst Error 
	LD	H,00H
	LD	L,A
	CALL	SCHLEIFE
	LD	DE,0FFE6H	; DE=-26
	LD	HL,(Y)		; bestimmt x
	ADD	HL,DE
	LD	(Y),HL
	CALL	ENDSCHLEIFE
L32:	POP	AF
	PUSH	AF
	CP	66H		; Flip? = 'f'
	JR	NZ,L33
	LD	A,00H
	CALL	WAIT
	OUT	(060H),A
L34:	IN	A,(68H)		; Lese von Tastatur
	CALL	CSTS
	CP	0FFH
	JR	NZ,L34
L33:	IN	A,(68H)
	POP	AF
	CP	0DH		; Carriage Return? Ret?
	JP	NZ,L35
	LD	HL,(KOR1)
	LD	A,(HL)
	OR	A
	JP	NZ,L35
	LD	A,(MODE)
	RRCA			; Get upper nibbel
	RRCA
	RRCA
	RRCA
	LD	(HL),A
	LD	A,00H
	CALL	WAIT
	OUT	(060H),A	; Setze Seite 0,0
	CALL	AUSWS
	RET
; mit w.y..s steuert man den Cursor
; das Bild flimmert dann
;
ZAEHLER:			; zählt Schritte
	LD	HL,ZAE1
	LD	A,(HL)
	INC	A		; +1
	DAA			; Dezimalzahl
	LD	(HL),A
	LD	A,30H
	RLD
	LD	(87ADH),A	; Zehner
	RLD
	LD	(87AEH),A	; Einer
	RLD			; ok
	LD	HL,0879EH
	CALL	WRITE		; Ausgabe Zählerstand
	RET
;
PLAY:				; Spiel gegen Computer
	LD	HL,00F3H	; HL = 243
	LD	(X),HL		; definiere x
	LD	HL,0127H	; HL = 295
	LD	(Y),HL		; definiere y
	LD	HL,8677H
	LD	(KOR1),HL	; definiere Anfang
	LD	HL,8600H
	LD 	DE,8601H
	LD	BC,0100H	; 256 Mal
	LD	A,00H
	LD	(8600H),A
	LD	(ZAE1),A	; Reset Zähler
	LDIR			; Clear Feld 
				; BC mal LD (DE),(HL); IND DE, INC HL, DEC BC
	CALL	FELD		; Print Feld
	LD	IX,8700H
	LD	A,(MODE)
	CP	10H		; weiß fängt an
	JR	Z,L36
L38:	CALL	KOREIN		; Eingabe durch Gegner
	CALL	ZAEHLER
L36:	LD	HL,0010H	; HL= 16
	LD	DE,0028H	; DE= 40
	CALL	MOVETO		; Position Zeichen
	LD	A,0BH		; GDP Befehl 4x4 Block
	CALL	WAIT
	OUT	(70H),A		; Zeichen markieren
	CALL	ZUGGEN
	PUSH	AF
	CALL	0221H		; clear Mode
	LD	HL,0010H	; HL= 16
	LD	DE,0028H	; DE= 40
	CALL	MOVETO
	LD	A,0BH		; GDP Befehl 4x4 Block
	CALL	WAIT
	OUT	(70H),A		; Zeichen löschen
	CALL	021DH		; zurücksetzen clear Mode
	POP	AF
	PUSH	AF
	JR	C,L37
	LD	HL,(KOR)
	LD	A,(MODE)
	LD	(HL),A		; set Position
L37:	CALL	AUSWS
	POP	AF
	JP	NC,L38:		; Carry ?
	RET			; wann dann Ende
;
; Weiß fängt an. Wenn der Computer rechnet erscheint
; links unten ein wei0er Punkt. Ist der Computer fer-
; tig wird der Punkt gelöscht. Wird eine der Tasten
; a,s,w oder y gedrückt so erscheint ein Pfeil. Drückt
; man dann "CR" so wird auf die Position in der sich 
; der Pfeil befindet ein Stein gesetzt.
;
;
STATUS: 			; zählt Spielstand
	OR	A
	JR	Z,L39		; JR wenn Punkt für
				; Computer
	LD	HL,ZAE2+1	; 
	LD	A,(HL)
	INC	A		; +1
	DAA
	LD	(HL),A
	LD	A,30H		; Ascii '0'
	RLD
	LD	(8798H),A	; Zehner
	RLD
	LD	(8799H),A	; Einer
	RLD			; Ok
	RET
;
L39:	LD	HL,ZAE2		; 879CH
	LD	A,(HL)
	INC	A		; +1
	DAA
	LD	(HL),A
	LD	A,30H		; Ascii '0'
	RLD
	LD	(8795H),A	; Zehner
	RLD
	LD	(8796H),A	; Einer
	RLD			; Ok
	RET
;
RUN1:
	LD	HL,COR
	CALL	WRITE
	LD	HL,0004H	; 12288 Mal, Delay
	CALL	SCHLEIFE
	CALL	ENDSCHLEIFE
	LD	HL,9999H
	LD	(ZAE2),HL
	LD	A,01H
	CALL	STATUS
	LD	A,00H
	CALL	STATUS
L43:	CALL	CLPG
	CALL	021DH
	LD	HL,0074H	; CSize
	LD	(8780H),HL
	LD	HL,00B4H	; HL= 180 (Y)
	LD	(877EH),HL
	LD	HL,0064H	; HL= 100 (X)
	LD	(877CH),HL
	LD	HL,0877CH
	CALL	WRITE		; Print Gomoku
	LD	HL,ANW
	CALL	WRITE		; Print Anweisung
	LD	A,01H
	LD	(MODE),A
	CALL	CI
	CP	073H		; schwarz oder weiß? 73H = 's'
	JR	NZ,L40
	LD	A,10H
	LD	(MODE),A
L40:	LD	HL,002BH	; X=43
	LD	(877CH),HL
	LD	HL,003AH	; Y=58
	LD	(877EH),HL	; definiere Pos + Form
	LD	HL,0853H	; Tilted Character, CSize = 5x3
	LD	(877EH),HL
	CALL	CLPG
	CALL	021DH
	LD	HL,877CH
	CALL	WRITE
	LD	HL,878BH
	CALL	WRITE		; Print Spielstand
	LD	A,(MODE)
	PUSH	AF
	CALL	PLAY
	POP	AF
	LD	B,A
	LD	A,(MODE)
	SUB	B
	PUSH	AF
	CALL	STATUS
	LD	HL,878BH
	CALL	WRITE
	POP	AF
	JR	Z,L41		; gewonnen oderverloren?
	LD	HL,WIN
	CALL	WRITE
	JR	L42
L41:	LD	HL,LOSE
	CALL	WRITE
L42:	CALL	CI
	CP	6EH		; Nochmal? 'n'
	JP	Z,L43
	RET			; Ende

COR:				; Copyright
	DW	046H,78H
	DB	33H,00H
	DB	'(C) Frederik Siegmund',00H
WIN:
	DW	0190H,10H
	DB	21H,00H
	DB	'WIN',00H
LOSE:
	DW	0190H,10H
	DB	21H,00H
	DB	'LOSE',00H
ANW:
	DW	32H,64H
	DB	22H,00H
	DB	'S=schwarz W=weiss N=nochmal',00H
GOMOKU1:
	DW	2BH,3AH
	DB	53H,08H
	DB	'Gomoku',00			
STAND:
	DW	100H,10AH
	DB	21H,00H
	DB	'C/S:00|01',00			
OUT1:
	DW	10H,10AH
	DB	21H,00H
	DB	'Schritte:17',00			
TAB:
	DB	00H,01H,01H,00H,00H,11H,11H,00H,00H,10H,10H,00H
	DB	10H,01H,01H,10H
