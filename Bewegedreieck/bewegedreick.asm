
;
; Beispiel Program aus "Rechner Modular" Seite 289
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;
    .include ../Include/z80grund.asm
    .org $8800

BEWEGEDREIECK:
    ; kleines Beispiel
    ld hl,150
    call SCHLEIFE
        ld hl,-90
        call DREHE
        ld hl,101
        call SCHREITE
        ld hl,120
        call DREHE
        ld hl,100
        call SCHREITE
        ld hl,120
        call DREHE
        call WAIT
        ld a,$01
        out ($70),a
        ld hl,100
        call SCHREITE
        call WAIT
        ld a,0
        out ($70),a
        ld hl,210
        call DREHE
    call ENDSCHLEIFE
    ret

    end