
;
; Beispiel Program aus "Rechner Modular" Seite 285
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;

    .include ../Include/z80grund.asm
    .org $8800

VIELSTAR:
    ; Beispiel
    ld hl,10
    call SCHLEIFE
        ld hl,5
	    call SCHLEIFE
			ld hl,200
	        call SCHREITE
    	    ld hl,144
	        call DREHE
    	call ENDSCHLEIFE
		ld hl,36
		call DREHE
	call ENDSCHLEIFE
    ret
