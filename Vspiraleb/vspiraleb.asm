
;
; Beispiel Program aus "Rechner Modular" Seite 285
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;

    .include ../Include/z80grund.asm
    .org $8800

VSPIRALEB:
    ; Beispiel
    ld hl,5
    ld (&8900),hl
    ld hl,150
    call SCHLEIFE
        ld hl,(&8900)
        call SCHREITE
   	    ld hl,101
        call DREHE
        ld hl,(&8900)
        ld de,3
        add hl,de
	    ld (&8900),hl
	call ENDSCHLEIFE
    ret
