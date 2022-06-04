;	 TITLE   FIGURE ROUTINE
;	************************
;
	ORG	8800H
;
;
WAIT = 003BH			; Warte bis
				; GDP fertig
				;
START:
	LD	HL,TABELLE
	CALL	FIGUR
	RET
FIGUR:
	LD	A,(HL)		; Ersten Wert laden
	INC	HL		; Zeiger um 1 erhoehen
	CP	08H		; unsichtbar?
	JP	NZ,.A		; Nein, dann JR nach A
	CALL	HEB		; Ja dann Stift hoch
	JP	FIGUR		; Zurück
.A:
	CP	09h		; Stift senken?
	JR	NZ,.B		; Ja, dann stift senken
	JP	FIGUR		; zurueck
.B:
	CP	0Ah		; Ende?
	RET	Z		; Dann zurück ins Hauptprogr.
	OR	0F8H		; Richtung des Vektors
	CALL	WAIT		; GDP fertig?
	OUT	(070H),A	; Ausgabe an GDP
	JP	FIGUR		; Zurück zu FIGUR
SENK:
	LD	A,00H		; Schreibfunktion setzen
	CALL	WAIT		; GDP fertig?
	OUT	(070H),A	; Ausgabe an GDP
	RET
HEB:
	LD	A,01H		; Löschfunktion setzen
	CALL	WAIT		; GDP fertig?
	OUT	(070H),A	; Ausgabe an GDP
	RET
TABELLE:
	DB	0,0,0,02,02,02,03
	DB	07,04,04,04,0,0,0
	DB	08
	DB	04,04,04,06,06
	DB	09
	DB	05,07,03,01
	DB	0AH
