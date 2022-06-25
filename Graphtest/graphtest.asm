;
; Graphik Beispiel für die Ansteuerung der GDP über einen Arduino
; https://hschuetz.selfhost.eu/forumdrc/index.php?mode=viewthread&forum_id=5&thread=44&z=1&
; Portiert auf den NKC in Z80 Assembler
; Author smed
; VASM Assembler code von Dr. Martin Merck
;
	.include ../Include/z80grund.asm
	.org $8800

GDP = $70
PAGE = $60
WPAGE0 = %00000000
WPAGE1 = %01000000
WPAGE2 = %10000000
WPAGE3 = %11000000
RPAGE0 = %00000000
RPAGE1 = %00010000
RPAGE2 = %00100000
RPAGE3 = %00110000

SOLID  = %00000000
DOTTED = %00000001
DASHED = %00000010
DASHDOTTED = %0000011


START:
	jp TEST

;-----> Generate a random number
; output a=answer 0<=a<=255
; all registers are preserved except: af
RANDOM:
	push hl
	push de
	ld hl,(RANDATA)
	ld a,r
	ld d,a
	ld e,(hl)
	add hl,de
	add a,l
	xor h
	ld (RANDATA),hl
	pop de
	pop hl
	ret

RAND:				; hl= upper-value
				; de= lower-value
	push bc
	sbc hl,de
	ld b,h
	ld c,l
	call RANDOM
	ld l,a
	ld h,0
.MOD_LOOP:
	or a
	sbc hl,bc
	jp p,.MOD_LOOP
	add hl,bc
	add hl,de
	ld a,l
	pop bc
	ret

RAND1:
	call RANDOM
	ld l,a
	ld h,0
	ld bc,170-10
.MOD_LOOP1:
	or a
	sbc hl,bc
	jp p,.MOD_LOOP1
	add hl,bc
	ld bc,10
	add hl,bc
	ld a,l
	ret

RAND2:
	call RANDOM
	ld l,a
	ld h,0
	ld bc,230-150
.MOD_LOOP2:
	or a
	sbc hl,bc
	jp p,.MOD_LOOP2
	add hl,bc
	ld bc,150
	add hl,bc
	ld a,l
	ret

SYNC:		   		; warten auf vb
	in a,(GDP)
	and 2
	jr z,.SYNC1
	ld a,(SYNSTATE)
	or a
	scf			; set carry flag
	ret nz		  	; <>0 dann carry
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

WARTE500MSEC:
	push bc
	ld b,25
.WARTE:
	call WARTESYNC
	djnz .WARTE
	pop bc
	ret

SETPAGE:			; Seite in Akku
	call WAIT
	and 0F0h		; wwrr0000
	out (PAGE),a		; w= write r=read
	ret

CSIZE:
	call WAIT
	out (GDP+3),a
	ret
	
LINESTYLE:
	call WAIT
	out (GDP+2),a
	ret

TEXT:
	ld a,(hl)
	cp 0
	jp z,.TEXTEND
	call WAIT
	out (GDP),a
	inc hl
	jp TEXT
.TEXTEND
	ret

FASTREC:
	call WAIT
	ld a,h
	out (GDP+5),a
	call WAIT
	ld a,l
	out (GDP+7),a
	call WAIT
	ld a,%00010000
	out (GDP),a
	call WAIT
	ld a,%00010010
	out (GDP),a
	call WAIT
	ld a,%00010110
	out (GDP),a
	call WAIT
	ld a,%00010100
	out (GDP),a
	
	ret



TEST:
	call CLR
	ld a, WPAGE0 | RPAGE0	; Page (0,0)
	call SETPAGE
	ld hl,TXT1
	call WRITE
	ld hl,TXT2
	call WRITE

	ld hl,0
	ld de,0
	call MOVETO
	ld hl,511
	ld de,255
	call DRAWTO

	ld hl,200
	ld de,128
	call MOVETO
	ld h, 50
	ld l, 25
	call FASTREC

	; Random Lines
	ld hl,100
	call SCHLEIFE
		ld hl,170
		ld de,10
		call RAND
;		call RAND1
		ld b,a
		ld hl,230
		ld de,150
		call RAND
;		call RAND2
		ld h,0
		ld l,b
		ld d,0
		ld e,a
		call MOVETO
		ld hl,170
		ld de,10
		call RAND
;		call RAND1
		ld b,a
		ld hl,230
		ld de,150
		call RAND
;		call RAND2
		ld h,0
		ld l,b
		ld d,0
		ld e,a
		call DRAWTO
	CALL ENDSCHLEIFE

	; Linetest
	ld a,SOLID
	call LINESTYLE
	ld hl,130
	ld de,50
	call MOVETO
	ld hl,500
	ld de,50
	call DRAWTO
	ld hl,450
	ld de,60
	call MOVETO
	ld hl,450
	ld de,200
	call DRAWTO

	ld a,DOTTED
	call LINESTYLE
	ld hl,130
	ld de,40
	call MOVETO
	ld hl,500
	ld de,40
	call DRAWTO
	ld hl,460
	ld de,60
	call MOVETO
	ld hl,460
	ld de,200
	call DRAWTO

	ld a,DASHED
	call LINESTYLE
	ld hl,130
	ld de,30
	call MOVETO
	ld hl,500
	ld de,30
	call DRAWTO
	ld hl,470
	ld de,60
	call MOVETO
	ld hl,470
	ld de,200
	call DRAWTO

	ld a,DASHDOTTED
	call LINESTYLE
	ld hl,130
	ld de,20
	call MOVETO
	ld hl,500
	ld de,20
	call DRAWTO
	ld hl,480
	ld de,60
	call MOVETO
	ld hl,480
	ld de,200
	call DRAWTO

	ld a, WPAGE0 | RPAGE0	; Page (0,0)
	call SETPAGE	
	ld hl,TXT3
	call WRITE

	call WARTE500MSEC
	call WARTE500MSEC

	ld a, WPAGE1 | RPAGE1	; Page (1,1)
	call SETPAGE	
	ld hl,TXT4
	call WRITE

	ld a, WPAGE2 | RPAGE2	; Page (2,2)
	call SETPAGE	
	ld hl,TXT5
	call WRITE

	ld b,3
.PAGE_LOOP:
		ld a, WPAGE1 | RPAGE1	; Page (1,1)
		call SETPAGE
		call WARTE500MSEC
		ld a, WPAGE2 | RPAGE2	; Page (2,2)
		call SETPAGE	
		call WARTE500MSEC
		djnz .PAGE_LOOP

	ld a, WPAGE1 | RPAGE1		; Page (1,1)
	call SETPAGE	
	ld a, WPAGE0 | RPAGE0		; Page (0,0)
	call SETPAGE	
	call WARTE500MSEC

	ld b,6
	ld c,3
	ld hl,500
	call SCHLEIFE
		ld hl,5
		ld de,1
		call RAND
		cp 1
		jp nz,.CHK1	; RAND = 1; b++
		inc b
.CHK1:		cp 2		; RAND = 2; b--
		jp nz,.CHK2
		dec b
.CHK2:		cp 3		; RAND = 3; c++
		jp nz,.CHK3
		inc c
.CHK3:		cp 4		; RAND = 3; c--
		jp nz,.CHKDONE
		dec c
.CHKDONE:			; if b=0 then b=1
		xor a
		cp b
		jp nz,.CHK4
		ld b,1			
.CHK4:				; if c=0 then x=1
		cp c
		jp nz,.CHK5
		ld c,1
.CHK5:				; if b>= 11 then B=11
		ld a, b
		sub 11
		jp c,.CHK6
		ld b,10
.CHK6:
		ld a, c
		sub 11
		jp c,.DONE
		ld c,10
.DONE:
		ld a,c
		and $0F
		ld c,a
		ld a,b
		RLA
		RLA
		RLA
		RLA
		add c
		call CSIZE
		ld hl,300
		ld de,80
		call MOVETO
		ld hl,TXT6
		call TEXT
		call WARTESYNC
		call WAIT
		ld a,$01
		out (GDP),a	; Löschen
		ld hl,300
		ld de,80
		call MOVETO
		ld hl,TXT6
		call TEXT
		call WAIT
		ld a,0
		out (GDP),a	; Schreiben
	call ENDSCHLEIFE
	
	jp TEST

	ret

TXT1:				; Text 1
	defw 200,130
	defb $21,0
	defb '1984',0

TXT2:				; Text 2
	defw 200,140
	defb $21,0
	defb '2018',0

TXT3:				; Text 2
	defw 200,180
	defb $63,0
	defb 'NKC',0

TXT4:				; Text 2
	defw 50,100
	defb $63,0
	defb 'Hello',0

TXT5:				; Text 2
	defw 270,100
	defb $63,0
	defb 'World',0

TXT6:				; Text 2
	defb 'NKC',0

RANDATA:			; Random Seed
	defb $AA,$55

SYNSTATE:
	defb 0

BUFFER:	ds 80