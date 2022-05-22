
;
; Beispiel Program aus "Rechner Modular" Seite 286
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;

    .include ../Include/z80grund.asm
    .org $8800

VIELLEITER:
    ld hl,36
    call SCHLEIFE
        ld hl,8
	    call SCHLEIFE
			ld hl,4
			call SCHLEIFE
				ld hl,20
				call SCHREITE
				ld hl,90
				call DREHE
	    	call ENDSCHLEIFE
			ld hl,20
			call SCHREITE
    	call ENDSCHLEIFE
		ld hl,-160
		call SCHREITE
		ld hl,10
		call DREHE
	call ENDSCHLEIFE
    ret
