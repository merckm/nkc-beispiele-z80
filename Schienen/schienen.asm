
;
; Beispiel Program aus "Rechner Modular" Seite 288
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;

    .include ../Include/z80grund.asm
    .org $8800

SCHIENEN:
    ld hl,2
    call SCHLEIFE
        ld hl,72
	    call SCHLEIFE
			ld hl,8
			call SCHREITE
			ld hl,-8
			call SCHREITE
			ld hl,-90
			call DREHE
			ld hl,20
			call SCHREITE
			ld hl,90
			call DREHE
			ld hl,11
			call SCHREITE
			ld hl,90
			call DREHE
			call HEBE
			ld hl,20
			call SCHREITE
			ld hl,-90
			call DREHE
			ld hl,-3
			call SCHREITE
			call SENKE
			ld hl,5
			call DREHE
	   	call ENDSCHLEIFE
		ld hl,90
		call DREHE
		ld hl,-20
		call SCHREITE
		ld hl,90
		call DREHE
	call ENDSCHLEIFE
    ret
