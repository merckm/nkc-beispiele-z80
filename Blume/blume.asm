
;
; Beispiel Program aus "Rechner Modular" Seite 141ff
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;

    .include ../Include/z80grund.asm
    .org $8800

START:
	jp BLUME

VIERTELKREIS:
    ld hl,90
    call SCHLEIFE
        ld hl,1
		call SCHREITE
		ld hl,1
		call DREHE
  	call ENDSCHLEIFE
    ret

BLATT:
	call VIERTELKREIS
	ld hl,90
	call DREHE
	call VIERTELKREIS
	ld hl,90
	call DREHE
	ret

BLUETE:
	ld hl,5
	call SCHLEIFE
		call BLATT
		ld hl,72
		call DREHE
	call ENDSCHLEIFE
	ret

BLUME:
	call BLUETE
	ld hl,-150
	call SCHREITE
	call BLATT
	ld hl,-10
	call SCHREITE
	ld hl,-90
	call DREHE
	call BLATT
	ld hl,90
	call DREHE
	ld hl,-40
	call SCHREITE
	ret

	end