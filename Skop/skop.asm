;************************************
;* Oscilloscop-Programm   Rev 1.0   *
;* (C) 1084 Rolf-Dieter Klein       *
;* Damit ist es moeglich            *
;* Abgeliche, etc. mot Z80+GDP      *
;* durchzufuehren. Es wird das      *
;* Z80-Grundprogramm benoetigt      *
;* Dieses Programm auf Adr 8800     *
;* gelegt.                          *
;************************************

IOE = 30h     			; IO-Karte Basis

    .include ../Include/z80grund.asm

    org 8400h			; RAM Speicher vpn 8400 bis 87FF

synstate:   ds 1
merker:     ds 1
bcd0:       ds 2
bcd1:       ds 2
buffer:     ds 80
data:       ds 256+256  	; Datenspeicher fuer Kanaele

stack = $87FF

PAGE = $60
GDP  = $70

    org 8800h			; RAM Speicher vpn 8400 bis 87FF
    jp start

; Unterprogramme
wait:
    push af
wait1:
    in a,(GDP)
    and 4
    jr z,wait1
    pop af
    ret

cmd:                		; Befehl an GDP ausgeben
    call wait
    out (GDP),a
    ret

setpage:            		; Seite in Akku
    call wait
    and 0F0h        		; wwrr0000
    out (PAGE),a   		; w= write r=read
    ret

setpen:
    call wait
    ld a,00000011b
    out (GDP+1),a
    ret

erapen:
    call wait
    ld a,00000001b
    out (GDP+1),a
    ret

sync:               		; warten auf vb
    in a,(GDP)
    and 2
    jr z,sync1
    ld a,(synstate)
    or a
    scf             		; set carry flag
    ret nz          		; <>0 dann carry
    inc a
    ld (synstate),a
    xor a
    ret
sync1:
    xor a
    ld (synstate),a
    scf
    ret

gitter:             		; Seite = 3 Gitteraufbau
                    		; 256 = 5V
                    		; 10 Teile
    call setpen
    ld a,11111000b  		; screin,lese = 3
    call setpage    		; wait incl.
    ld a,00000001b  		; dotted line
    out (GDP+2),a
    ld de,0         		; Start
    ld hl,11        		; 11 Linien (10 Unterteilungen)
.L1:
    push hl         		; Linienzaehler
    ld hl,0
    call MOVETO     		; noveto de*25, 0
    ld hl,510
    push de
    call DRAWTO     		; DRAWTO de*25, 510
    pop de
    ld hl,25        		; inc de by 25
    add hl,de
    ex de,hl
    pop hl
    dec hl          		; dec. Schleifenzaehler
    ld a,h
    or l
    jp nz,.L1       		; end schleife
                    		;
    ld hl,0
    ld de,11
.L2:
    push de         		; Linienzaehler
    ld de,0
    call MOVETO     		; MOVETO 0, hl*51
    ld de,250
    push hl
    call DRAWTO     		; DRAWTO 250, hl*51
    pop hl
    ld de,51        		; inc hl by 51
    add hl,de
    pop de
    dec hl          		; dec. Schleifenzaehler
    ld a,d
    or e
    jp nz,.L2       		; end schleife
                    		;
    call wait
    ld a,0
    out (GDP+2),a   		; reset linestype

    ; Mittel-Linien
    ld hl,0
    ld de,5*25
    call MOVETO
    ld hl,510
    ld de,5*25
    call DRAWTO
    ld hl,5*51
    ld de,0
    call MOVETO
    ld hl,5*51
    ld de,250
    call DRAWTO
    ret

getframe:           		; einen Datenblock laden
                    		; Bit 0 = Messport A + Trigger
                    		; Bit 1 = Messport B
get1:
    in a,(IOE)      		; einlesen für trigger
    rrca
    jr c,get1
get2:
    in a,(IOE)
    rrca            		; 4 T-states
    jr nc,get2     		;   -----_____-----_____-----Trigger start
                    		; 7 T-states condition not met
    ld hl,data      		; 10 T-States
    ld b,0          		; 7 T-States
    ld c, IOE       		; 7 T-States
    inir            		; lade 2*256 Bytes von IOE in HL
    inir            		; 21T-Zyklen=5.25us pro Abtastpunkt bei 4MHz
    ret
                    		;
                    		; vom Trigger bis INIR ca. 35T Zyklen = 8,75us          

put1frame:          		; Kanal 1 zeichnen
    call setpen
    ld ix,data      		; datenquelle
    ld hl,1         		; x=0 ist start
    ld bc,509      		; 
.L3
    ld de,130       		; y-Wert für 0-Pegel
    ld a,(ix+0)     		; teste bit 0
    and 1           		; Bit 0 ist signal
    jp z,.L4
    ld de,180       		; y-Wert für 1-Pegel
.L4
    call MOVETO
    ld a,80H        		; GDP commando set dot
    call cmd
    inc hl
    inc ix
    dec bc
    ld a,b
    or c            		; Teste ob irgend ein bit in bc gesetzt (!=0)
    jp nz,.L3       		; Zurück zue Schleife
    ret

put2frame:          		; Kanal 2 zeichnen
    call setpen
    ld ix,data      		; datenquelle
    ld hl,1         		; x=0 ist start
    ld bc,509
.L5
    ld de,60       		; y-Wert für 0-Pegel
    ld a,(ix+0)     		; teste bit 0
    and 2           		; Bit 1 ist signal
    jp z,.L6
    ld de,110      		; y-Wert für 1-Pegel
.L6
    call MOVETO
    ld a,80H        		; GDP commando set dot
    call cmd
    inc hl
    inc ix
    dec bc
    ld a,b
    or c            		; Teste ob irgend ein bit in bc gesetzt (!=0)
    jp nz,.L5       		; Zurück zue Schleife
    ret

clr1frame:          		; da nur 2 Linien ist
                    		; löschen einfach
    call erapen
    ld hl,1
    ld de,130
    call MOVETO
    ld hl,510
    ld de,130
    call DRAWTO
    ld hl,1
    ld de,180
    call MOVETO
    ld hl,510
    ld de,180
    call DRAWTO
    call setpen
    ret

clr2frame:         		; da nur 2 Linien ist
                		; löschen einfach
    call erapen
    ld hl,1
    ld de,60
    call MOVETO
    ld hl,510
    ld de,60
    call DRAWTO
    ld hl,1
    ld de,110
    call MOVETO
    ld hl,510
    ld de,110
    call DRAWTO
    call setpen
    ret

count:              		; ix -> bcdspeicher, um b erhoehen
    ld a,(ix+0)     		; lsb
    add a,b
    daa
    ld (ix+0),a
    ret nc
    ld a,(ix+1)     		; Übertrag
    add a,1
    daa
    ld (ix+1),a
    ret

cnt525:             		; 5 1/4 Zaehler mit merker
    push bc         		; Register retten
    ld b,5
    call count
    ld a,(merker)
    add a,1			; 0,1,2,3 erlaubt
    ld (merker),a
    cp 4
    jp nz,.L7
    xor a
    ld (merker),a
    ld b,1
    call count
.L7
    pop bc
    ret

messper:            		; Messen ersten Wechsel ----____----
				; nur Kanal 1
				; eine Periode in us. Dezimal
				; Kanal 1 und 2   (bit 0,1)
	xor a
	ld (merker),a		; 1/4 Zaehler rueksetzen
	ld hl,11		; ca. 11us sind am Anzang mit Trigger vergangen
	ld (bcd0),hl
	ld hl,data
	ld ix,bcd0		; Erste Zahl
	ld bc,512		; MAX Suchvorgang
	push hl
	ld hl,.L8
	ex (sp),hl
.L9:
	ld a,(hl)		; Datenwert Bit 0
	and 1			; pruefen
	jp nz,.L10
	push hl
	ld hl,.L11
	ex (sp),hl
.L12:
	ld a,(hl)		; Ende Periodendauer
	and 1
	ret nz
	call cnt525
	inc hl
	dec bc
	ld a,c
	or b
	jp nz,.L13
	ld a,0ffh
	ld (ix+0),a
	ld (ix+1),a
	ret
.L13:
	jp .L12
.L11:
	ret
.L10:
	call cnt525
	inc hl
	dec bc
	ld a,C
	or B
	jp nz,.L14
	ld a,0ffh
	ld (ix+0),a
	ld (ix+1),a
	ret
.L14:
	jp .L9
.L8:
	ret

mess0time:			; Messen ersten Wechsel ----____----
				; eine Periode in us. Dezimal
				; Kanal 1 und 2   (bit 0,1)
	xor a
	ld (merker),a		; 1/4 Zaehler rueksetzen
	ld hl,0			; ca. 11us sind am Anzang mit Trigger vergangen
	ld (bcd0),hl
	ld hl,data
	ld ix,bcd0		; Erste Zahl
	ld bc,512		; MAX Suchvorgang
	push hl
	ld hl,.L15
	ex (sp),hl
.L16:
	ld a,(hl)		; Datenwert Bit 0
	and 1			; pruefen
	jp nz,.L17
	push hl
	ld hl,.L18
	ex (sp),hl
.L19:
	ld a,(hl)		; Ende Periodendauer
	and 1
	ret nz
	call cnt525
	inc hl
	dec bc
	ld a,c
	or b
	jp nz,.L20
	ld a,0ffh
	ld (ix+0),a
	ld (ix+1),a
	ret
.L20:
	jp .L19
.L18:
	ret
.L17:
	inc hl
	dec bc
	ld a,C
	or B
	jp nz,.L21
	ld a,0ffh
	ld (ix+0),a
	ld (ix+1),a
	ret
.L21:
	jp .L16
.L15:
	ret

bcdaus:				; ix -> bcdstand
				; hl ->Zielbuffer
	ld a,(ix+1)		; MSB first
	rrca			; erste Ziffer
	rrca
	rrca
	rrca
	and 0fH
	call dezaus
	ld a,(ix+1)		; zweite Ziffer
	and 0fH
	call dezaus
	ld a,(ix+0)		; LSB dann
	rrca			; erste Ziffer
	rrca
	rrca
	rrca
	and 0fH
	call dezaus
	ld a,(ix+0)		; zweite Ziffer
	and 0fH
	call dezaus
	ld (hl),0		; 0=Ende String
	ret

dezaus:
	or '0'
	ld (hl),a
	inc hl
	ret

ausperiode:
	call messper		; Messwert nach bcd0
	ld ix,txt2		; Text ausgabe
	call txtprint
	ld ix,bcd0		; Daten
	call bcdaus 		; Ausgabe in BCD
	ld hl,buffer
	call WRITE		; Ausgabe auf den Bildschirm
	ret

auslow:
	call mess0time
	ld ix,txt3
	call txtprint
	ld ix,bcd0		; 0-Zeitdauer
	call bcdaus 		; Ausgabe in BCD
	ld hl,buffer
	call WRITE		; Ausgabe auf den Bildschirm
	ret

txt2:
	defw 140+10*12,90
	defb 22h,0
	defb 0

txt1:
	defw 140,90
	defb 22h,0
	defb 'Periode = ???? ys',0

txt3:				; fuer Dauer
	defw 70+17*12,210
	defb 22h,0
	defb 0

txt4:				; fuer Dauer
	defw 70,210
	defb 22h,0
	defb '0-Signal-Dauer = ???? ys',0

txtprint:			; ix -> Text
	ld hl,buffer
	ld b,6			; 6 Byte Ausgebe-Header
.lp1:
	ld a,(ix+0)
	ld (hl),a
	inc ix
	inc hl
	djnz .lp1		; dec b, jrnz

.lp:				; nun Text bis 0
	ld a,(ix+0)
	ld (hl),a
	or a
	ret z			; 0 = Ende hl bleibt auf Ziel
	inc ix
	inc hl
	jr .lp

wartesync:
	call sync
	jr c,wartesync
	ret

ab1txt:				; Text fuer beide Bildseiten Abgleich 1
	ld ix,txt1		; Sowie Bildausgabe
	call txtprint		; In buffer Textblock aufbauen
	ld hl,buffer
	call WRITE		; Ausgabe mit Write
	ld ix,txta1		; Menue-Befehle
	call txtprint		; In buffer Textblock aufbauen
	ld hl,buffer
	call WRITE		; Ausgabe mit Write
	call wait
	ld a,00000001b
	out (GDP+2),a		; dotted line setzen in GDP CTRL Register 2
	ld hl,0			; Rahmen
	ld de,120
	call MOVETO
	ld hl,511
	call DRAWTO
	ld hl,511
	ld de,190
	call DRAWTO
	ld hl,0
	ld de,190
	call DRAWTO
	ld hl,0
	ld de,120
	call DRAWTO		 
	call wait
	ld a,0
	out (GDP+2),a		; continuos line setzen in GDP CTRL Register 2
	ret

txta1:
	defw 0,0
	defb 22h,0
	defb 'S=Speichern W=Weiter M=Menue',0

abgleich1: 			; Skop Kanal 0 darstellen
	call CLR
	ld a,01010000b
	call setpage
	call ab1txt
	ld a,00000000b
	call setpage
	call ab1txt
.abgl1:
	call clr1frame
	call getframe
	call put1frame
	ld a,01000000b		; schreib = 1
	call setpage
	call ausperiode
	call clr1frame
	call getframe
	call put1frame
	ld a,00010000b		; schreib seite 0
	call setpage
	call ausperiode
	call CSTS
	jr z,.abgl1		; bis Taste gedrückt
	call CI			; Taste lesen
	cp 'M'
	ret z			; Menue
	cp 'm'
	ret z
	cp 'S'
	jp z,.L23
	cp 's'
	jp nz,.L22
.L23
.L24
	call CI
	cp 'M'
	ret z			; Menue
	cp 'm'
	ret z
	cp 'W'
	jp z,.L25
	cp 'w'
	jp nz,.L24
.L25
.L22
	jr .abgl1

ab2txt:
	ld ix,txt4		; Sowie Bildausgabe
	call txtprint		; In buffer Textblock aufbauen
	ld hl,buffer
	call WRITE		; Ausgabe mit Write
	ld ix,txta1		; Menue-Befehle
	call txtprint		; In buffer Textblock aufbauen
	ld hl,buffer
	call WRITE		; Ausgabe mit Write
	call wait
	ld a,00000001b
	out (GDP+2),a		; dotted line setzen in GDP CTRL Register 2
	ld hl,0			; Rahmen
	ld de,50
	call MOVETO
	ld hl,511
	call DRAWTO
	ld hl,511
	ld de,190
	call DRAWTO
	ld hl,0
	ld de,190
	call DRAWTO
	ld hl,0
	ld de,50
	call DRAWTO
	ld hl,0			; Mittellinie
	ld de,120
	call MOVETO
	ld hl,511
	ld de,120
	call DRAWTO
	call wait
	ld a,0
	out (GDP+2),a		; continuos line setzen in GDP CTRL Register 2
	ret

abgleich2:
	call CLR
	ld a,01010000b
	call setpage
	call ab2txt
	ld a,00000000b
	call setpage
	call ab2txt
.abgl2:
	call clr1frame
	call clr2frame
	call getframe
	call put1frame
	call put2frame
	ld a,01000000b		; schreib = 1
	call setpage
	call auslow
	call clr1frame
	call clr2frame
	call getframe
	call put1frame
	call put2frame
	ld a,00010000b		; schreib seite 0
	call setpage
	call auslow
	call CSTS
	jr z,.abgl2		; bis Taste gedrückt
	call CI			; Taste lesen
	cp 'M'
	ret z			; Menue
	cp 'm'
	ret z
	cp 'S'
	jp z,.L27
	cp 's'
	jp nz,.L26
.L27
.L28
	call CI
	cp 'M'
	ret z			; Menue
	cp 'm'
	ret z
	cp 'W'
	jp z,.L29
	cp 'w'
	jp nz,.L28
.L29
.L26
	jr .abgl2

menuein:
.L30:
.L31:
	ld hl,50		; Position 50,10
	ld (buffer),hl
	ld hl,10
	ld (buffer+2),hl
	ld a,33h		; CSize 3X, 3Y
	ld (buffer+4),a
	ld a,0			; Gerader Text
	ld (buffer+5),a
	ld a,2			; 2 Zeichenfelder
	ld (buffer+6),a
	ld a,0
	ld (buffer+7),a
	ld c,1
	ld hl,buffer
	call READ	
	ld a,(buffer+7)
	cp 1
	jp nz,.L31
	ld a,(buffer+8)
	cp '4'+1
	jp nc,.L30
	cp '1'+0
	jp c,.L30
.L32
	ret

help:
	call CLR
	ld ix,htxt1
	ld de,255-10*2
	push hl
	ld hl,.L33
	ex (sp),hl		; Return Address auf Stack
.L34:
	ld hl,0
	ld (buffer),hl		; X=0
	ex de,hl
	ld (buffer+2),hl	; Y=255-20
	ex de,hl
	ld a,22h		; CSize = 2X 2Y
	ld (buffer+4),a		; Y=255-20
	ld a,0
	ld (buffer+5),a		; X=0
	ld hl,buffer+6
	ld a,(ix+0)
.L35:
	cp 0ah
	jp z,.L36
	or A
	ret Z
	ld (hl),A		; Text kopieren
	inc hl
	inc ix
	ld a,(ix+0)
	jp .L35
.L36:
	inc ix
	ld (hl),0
	ld hl,buffer
	push de
	push ix
	call WRITE	
	pop	ix
	pop de
	ld hl,10*2
	ex de,hl
	xor a
	sbc hl,de
	ex de,hl
	jp .L34
.L33:
.L37:
	call CI
	cp 'M'
	jp z,.L38		; Menue
	cp 'm'
	jp nz,.L37
.L38:
    ret

htxt1:
    defb '          *** Rev 1.0 *** ',0ah
    defb '1. IOE-Karte  auf Adresse 30h legen.',0ah
    defb '2. I/O 0-Port Bit 0 = Kanal 1.',0ah
    defb '3. I/O 0-Port Bit 1 = Kanal 2.',0ah
    defb '4. Kanal 1 ist auch Triggereingang.',0ah
    defb '5. Das Signal erscheint erst',0ah
    defb '   nachdem ein Signalwechsel',0ah
    defb '   am Triggereingang von 0 auf 1',0ah
    defb '   erfolgt.',0ah
    defb '6. Die Messungen erfolgen auf ca. ',0ah
    defb '   5ys bis 6ys genau.',0ah
    defb '                      M=Menue',0ah
    defb 0

; Hauptprogramm
;
start:
    ld sp, stack
    xor a
	ld (synstate),a
    call CLR
    ld a,0
    call setpage
    ld hl,.meld1
    call WRITE	
    ld hl,.meld2
    call WRITE	
    ld hl,.meld3
    call WRITE	
    ld hl,.meld4
    call WRITE
    call menuein

    cp '1'			; if a='1'
    jp nz,.menu2
    call abgleich1
    jp start
.menu2:
    cp '2'			; if a='2'
    jp nz,.menu3
    call abgleich2
    jp start
.menu3:
    cp '3'			; if a='3'
    jp nz,.menu4
    call help
    jp start
.menu4:
    cp '4'			; if a='4'
    jp nz,.L43
        			; fuer Erweiterungen
.L43
.L40
    jp start


.meld1:
    defw 40,220			; x,y
    defb 44h,0
    defb 'RDK-Digital-Scop'
    defb 0    
.meld2:
    defw 50,160			; x,y
    defb 22h,0
    defb '1 = Periodendauer,     1-Kanal'
    defb 0    
.meld3:
    defw 50,130			; x,y
    defb 22h,0
    defb '2 = Vergleichsmessung, 2-Kanal'
    defb 0    
.meld4:
    defw 50,100			; x,y
    defb 22h,0
    defb '3 = Kurzerklaerung'
    defb 0    

    end