CMD:				; Befehl an GDP ausgeben
	call WAIT
	out (GDP),a
	ret

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

INITFIGUR:
	push	hl
	xor	h
	xor	l
	xor	a
	ld	(OLDX),HL
	ld	(OLDY),HL
	ld	(OLDSIZE),A
	ld	(OLDADR),HL
	pop	hl
	ret

FIGUR:				; hl = X Koordinate
				; de = Y Koordinate
				; bc = Addresse der Daten
				; a = Groesse
	push	af
	push	bc
	push	hl
	push	de
	ld	hl,(OLDX)
	ld	de,(OLDY)
	ld	a,(OLDSIZE)
	cp	0		; Ist OLDSIZE 0?
	jr	Z,.DRAWFIG
	call	MOVETO
	ld	HL,(OLDADR)
	ld	b,a
	call	ERAPEN
	call	FIGUR1
.DRAWFIG:
	pop	de
	pop	hl
	call	MOVETO
	ld	(OLDX),hl
	ld	(OLDY),de
	pop	bc		
	pop	af		
	cp	0		; Neue Groesse = 0
	jr	Z,.FIGDONE	; Dann nur löschen
	push	hl
	ld	h,b
	ld	l,c
	ld	b,a
	call	SETPEN
	call	FIGUR1
	ld	a,b
	ld	(OLDSIZE),a
	ld	(OLDADR),hl
	ld	b,h
	ld	c,l		; restore BC with content of HL
	pop 	hl
.FIGDONE:
	ret

FIGUR1:
	ld	A,(HL)		; Ersten Wert laden
	inc	HL		; Zeiger um 1 erhoehen
	cp	08H		; unsichtbar?
	jp	NZ,.A		; Nein, dann jr nach A
	call	.HEB		; Ja dann Stift hoch
	jp	FIGUR		; Zurück
.A:
	cp	09h		; Stift senken?
	jr	NZ,.B		; Ja, dann stift senken
	call	.SENK
	jp	FIGUR		; zurueck
.B:
	cp	0Ah		; Ende?
	ret	Z		; Dann zurück ins Hauptprogr.
	or	B		; Richtung des Vektors
	call	CMD		; GDP Kommando
	jp	FIGUR		; Zurück zu FIGUR
.SENK:
	ld	A,00H		; Schreibfunktion setzen
	call	CMD		; GDP Kommando
	ret
.HEB:
	ld	A,01H		; Löschfunktion setzen
	call	CMD		; GDP Kommando
	ret

OLDX:   	ds 2
OLDY:		ds 2
OLDSIZE:	ds 1
OLDADR:		ds 2
