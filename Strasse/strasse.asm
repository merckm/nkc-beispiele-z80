;
; Beispiel Program aus "Rechner Modular" Seite 140
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;
    .include ../Include/z80grund.asm
    .org $8800

STRASSE:
    ld hl,90
    call DREHE
    ld hl,20
    call SCHREITE
    ld hl,-90
    call DREHE
    ld hl,200
    call SCHREITE
    ld hl,-90
    call DREHE
    ld hl,20
    call SCHREITE
    ld hl,-90
    call DREHE
    ld hl,40
    call SCHREITE
    call HEBE
    ld hl,40
    call SCHREITE
    call SENKE
    ld hl,40
    call SCHREITE
    call HEBE
    ld hl,40
    call SCHREITE
    call SENKE
    ld hl,40
    call SCHREITE
    ld hl,90
    call DREHE
    ld hl,20
    call SCHREITE
    ld hl,90
    call DREHE
    ld hl,200
    call SCHREITE
    ld hl,90
    call DREHE
    ld hl,20
    call SCHREITE

    ret
    end