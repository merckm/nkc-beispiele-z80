
;
; Beispiel Program aus "Rechner Modular" Seite 150
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;
    .include ../Include/z80grund.asm
    .org $8800

KREISE:
    ld hl,36
    call SCHLEIFE
    ld hl,360
        call SCHLEIFE
            ld hl,3
            call SCHR16TEL
            ld hl,1
            call DREHE
        call ENDSCHLEIFE
        ld hl,"="
        call SCHREITE
        ld hl,10
        call DREHE
    call ENDSCHLEIFE
    ret
    end