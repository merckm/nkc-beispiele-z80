
;
; Beispiel Program aus "Rechner Modular" Seite 139
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;
    .include ../Include/z80grund.asm
    .org $8800

EINS:
    ld hl,-90
    call DREHE
    ld hl,20
    call SCHREITE
    ld hl,-10
    call SCHREITE
    ld hl,90
    call DREHE
    ld hl,100
    call SCHREITE
    ld hl,135
    call DREHE
    ld hl,20
    call SCHREITE
    ret
    end