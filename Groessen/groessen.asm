;
; Beispiel Program aus "Rechner Modular" Seite 287
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;
    .include ../Include/z80grund.asm
    .org $8800

START:
    jp GROESSEN

SECHSECK:
    ; kleines Beispiel
    ld hl,6
    call SCHLEIFE
        ld hl,(&8900)
        call SCHREITE
        ld hl,60
        call DREHE
    call ENDSCHLEIFE
    ret

GROESSEN:
    ld hl,140
    ld ($8900),HL
    ld hl,56
    call SCHLEIFE
        call SECHSECK
        ld hl,($8900)
        ld de,-5
        add hl,de
        ld ($8900),HL
    call ENDSCHLEIFE
    ret
    end