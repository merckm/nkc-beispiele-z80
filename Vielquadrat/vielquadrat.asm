;
; Beispiel Program aus "Microcomputer selbst gebaut und programmiert" Seite 344
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;
    .include ../Include/z80grund.asm
    .org $8800

START:
    jp VIELQUADRAT

SEITE:
    ld hl,$50
    call SCHREITE
    ld hl,90
    call DREHE
    ret

QUADRAT:
    ld hl,4   
    call SCHLEIFE
        call SEITE
    call ENDSCHLEIFE
    ret

VIELQUADRAT:
    ld hl,36   
    call SCHLEIFE
        call QUADRAT
        ld hl,!0
        call DREHE
    call ENDSCHLEIFE
    ret

    end