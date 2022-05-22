
;
; Beispiel Program aus "Rechner Modular" Seite 151
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;
    .include ../Include/z80grund.asm
    .org $8800

START:
    jp ZAHNRAD

ZACKE:
    ld hl,-60
    call DREHE
    ld hl,10
    call SCHREITE
    ld hl,120
    call DREHE
    ld hl,10
    call SCHREITE
    ld hl,-60
    call DREHE
    ret

ZAHNRAD:
    ld hl,72
    call SCHLEIFE
        call ZACKE
        ld hl,5
        call DREHE
    call ENDSCHLEIFE
    ret
    end