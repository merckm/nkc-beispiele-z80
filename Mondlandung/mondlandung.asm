;*********************************
; MONDLANDEPROGRAMM VERSION 1.0  ;
; Version für Z80 VPM 02.07.2022 ;
; Basierend auf 68K Version 1.0  ;
; vom 13.12.1983		 ;
; Aus Klein: Die Prozessoren	 ;
; 68000 und 68008, Seite: 131ff  ;
; Author Z80: Dr. Martin Merck   ;
; Steuerung üner Tasten stat IOE ;
; Rauf   = 'w'                   ;
; Links  = 'a'                   ;
; Rechts = 's'			 ;
; Runter = 'y'		         ;
;*********************************
;
	.include ../Include/z80grund.asm
;
GDP  = 70H
PAGE = 60H
KEYD = 68h
KEYS = 69h

	org 8F00H		; RAM Speicher für Vatiablen von 8700 bis 87FF
X:		ds 2
Y:		ds 2
DX:		ds 1
DY:		ds 1
TREIBS:		ds 2
SYNSTATE:	ds 2
OLDX:		ds 2
OLDY:		ds 2

	ORG	8800H

START:
	ld	a,00000000b	; SETPAGE 0,0
	call	WAIT
	and	0F0h		; wwrr0000
	out	(PAGE),a	; w= write r=read
	call	MONDFLAECHE
	ld	hl,100
	ld	(X),hl
	ld	(OLDX),hl
	ld	hl,200
	ld	(Y),hl
	ld	(OLDY),hl
	ld	hl,3
	ld	(DX),hl
	ld	hl,0
	ld	(DY),hl
	ld	hl,300
	ld	(TREIBS),hl
.WDH1:
	ld 	HL,(OLDX)
	ld 	DE,(OLDY)
	call	MOVETO
	call	ERAPEN
	ld 	b,%11111000	; DX = 3 bits 5&6 DY = 3 bits b4 & b3
	ld	HL,FAEHRE
	call	FIGUR
	ld 	HL,(X)
	ld 	DE,(Y)
	call	MOVETO
	ld	(OLDX),HL
	ld	(OLDY),DE
	call	SETPEN
	ld 	b,%11111000	; DX = 3 bits 5&6 DY = 3 bits b4 & b3
	ld	HL,FAEHRE
	call	FIGUR
	ld	HL,(TREIBS)	; Prüfe ob Treibstpff leer
	inc	H		; H = 0;
	dec	H
	jr	nz,.TASTTST
	inc	l		; L = 0;
	dec	l
	jr	z,.NOTST	; Keine Steuerbefehle mehr möglich
.TASTTST:
	call 	CSTS
	jr 	z,.NOTST	; bis Taste gedrückt
	CALL	CI2		; Bewegung nach rechts 's'
	CP	's'
	JR	NZ,.LEFTTST
	LD	a,(DX)
	ADD	3
	LD	(DX),A
	JR	.NOTST
.LEFTTST:
	CP	'a'		; Bewegung nach links 'a'
	JR	NZ,.UPTST
	LD	A,(DX)
	sub	3
	LD	(DX),A
	JR	.NOTST
.UPTST:
	CP	'w'		; Bewegung nach roben 'w'
	JR	NZ,.DOWNTST
	LD	A,(DY)
	sub	3
	LD	(DY),A
	JR	.NOTST
.DOWNTST:
	CP	'y'		; Bewegung nach roben 'y'
	JR	NZ,.NOTST
	LD	A,(DY)
	add	3
	LD	(DY),A
.NOTST:
	LD	A,(DY)		; Gravitation
	ADD	1
	LD	(DY),A
	LD	HL,(X)		; X = X+DX
	LD	A,(DX)
	call	ADDHL
	LD	(X),HL
	LD	HL,(Y)		; Y = Y+DY
	LD	A,(DY)
	call	SUBHL
	LD	(Y),HL
	LD	HL,(TREIBS)	; Treibstoff verringern
	LD	A,1
	call	SUBHL
	LD	(TREIBS),HL
	call	WARTE100MSEC

	LD	HL,(Y)		; Teste Höhe über der Oberfläche
	ld	a,h
	cp	0
	jp	M,LAND
	INC	H
	DEC	H
	jp	nz,.WDH1
	ld	a,l
	cp	5
	jp	nc,.WDH1

LAND:
	ld 	HL,(X)
	ld 	DE,(Y)
	call	MOVETO
	ld 	b,%11111000	; DX = 3 bits 5&6 DY = 3 bits b4 & b3
	ld	HL,FAEHRE
	call	FIGUR

	LD	A,(DX)		; Teste DX Geschwindigkeit
	cp	0
	jr	nc,.FF1
	neg
.FF1:
	cp	2
	jr	nc,BRUCH

	LD	A,(DY)		; Teste DX Geschwindigkeit
	cp	0
	jr	nc,.FF1
	neg
.FF2:
	cp	4
	jr	nc,BRUCH
	ld	hl,ERFOLGTEXT
	jr	ENDE

BRUCH:
	LD	HL,BRUCHTEXT
ENDE:
	CALL	WRITE
	call	WARTE100MSEC
	call	WARTE100MSEC
	call	WARTE100MSEC

	; call 	CSTS
	; jr 	z,.NOTST	; bis Taste gedrückt

	; CALL	CI2
	; CP	'm'		;Zurück zum Menu mit 'm'
	; JR	Z,.FIN
	; CP	'M'		;Zurück zum Menu mit 'M'
	; JR	Z,.FIN
	; CALL	CLR
	; JP	START
.FIN
	ret

ADDHL:
	add	a,l		; A = A+L
	ld	l,a		; L = A+L
	adc	a,h		; A = A+L+H+carry
	sub	l
	ld	h,a
	ret

SUBHL:
	neg
	jp	z, SKIP
	dec	h
	; Now add the low byte as usual
	; Two's complement takes care of
	; ensuring the result is correct
	add	a, l
	ld	l, a
	adc	a, h
	sub	l
	ld	h, a
SKIP:
	ret


CI2:			
	in a,(KEYD)
	bit 7,a
	jr nz,CI2
	push af
	in a,(KEYS) 		;loeschen status
	pop af
	ret  			;bit 7=0 per definition

;	.include figur.asm
SETPEN:
	call WAIT
	ld a,00000011b
	out (GDP+1),a
	ret

ERAPEN:
	call WAIT
	ld a,00000001b
	out (GDP+1),a
	ret

FIGUR:
	ld	A,(HL)		; Ersten Wert laden
	inc	HL		; Zeiger um 1 erhoehen
	cp	08H		; unsichtbar?
	jp	NZ,.A		; Nein, dann jr nach A
	call	HEB		; Ja dann Stift hoch
	jp	FIGUR		; Zurück
.A:
	cp	09h		; Stift senken?
	jr	NZ,.B		; Ja, dann stift senken
	call	SENK
	jp	FIGUR		; zurueck
.B:
	cp	0Ah		; Ende?
	ret	Z		; Dann zurück ins Hauptprogr.
	or	B		; Richtung des Vektors
	call	WAIT		; GDP fertig?
	out	(GDP),A		; Ausgabe an GDP
	jp	FIGUR		; Zurück zu FIGUR
SENK:
	ld	A,00H		; Schreibfunktion setzen
	call	WAIT		; GDP fertig?
	out	(GDP),A		; Ausgabe an GDP
	ret
HEB:
	ld	A,01H		; Löschfunktion setzen
	call	WAIT		; GDP fertig?
	out	(GDP),A		; Ausgabe an GDP
	ret

MONDFLAECHE:
	ld	HL,0
	ld	DE,0
	ld	BC,0
	call	SET
	ld	b,0		; Anzahl Krater
.MFL1:
	ld	a,26
	cp	b
	jp	z, .MFL2 
	call	KRATER
	inc	b
	jp	.MFL1
.MFL2:
	ret

KRATER:
	ld 	hl,45
	call	DREHE
	ld	hl,10
	call	SCHREITE
	ld 	hl,-45
	call	DREHE
	ld	hl,6
	call	SCHREITE
	ld 	hl,-45
	call	DREHE
	ld	hl,10
	call	SCHREITE
	ld 	hl,45
	call	DREHE
	ret

SYNC:				; warten auf vb
	in a,(GDP)
	and 2
	jr z,.SYNC1
	ld a,(SYNSTATE)
	or a
	scf			; set carry flag
	ret nz			; <>0 dann carry
	inc a
	ld (SYNSTATE),a
	xor a
	ret
.SYNC1:
	xor a
	ld (SYNSTATE),a
	scf
	ret

WARTESYNC:
	call SYNC
	jr c,WARTESYNC
	ret

WARTE100MSEC:
	push bc
	ld b,5
.WARTE:
	call WARTESYNC
	djnz .WARTE
	pop bc
	ret

; Statische Daten
FAEHRE:
	DB	1,2,2,0,0,0,4,4,5,3,6,6,6
	DB	0AH

ERFOLGTEXT:
	defw 0,130		; x,y
	defb 33h,0
	defb 'Gut gelandet'
	defb 0	

BRUCHTEXT:
	defw 0,130		; x,y
	defb 33h,0
	defb 'Bruchlandung'
	defb 0	

