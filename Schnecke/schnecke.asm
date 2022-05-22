;
; Beispiel Program aus "Microcomputer selbst gebaut und programmiert" Seite 348
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;
    .include ../Include/z80grund.asm
    .org $8800
MERKER: .equ $8900

START:
    jp SCHNECKE

QCIRC:
    ld hl,9
    call SCHLEIFE
        ld hl,(MERKER)
        call SCHR16TEL
        ld hl,10
        call DREHE
    call ENDSCHLEIFE
    ret

SCHNECKE:
    ld hl,1
    ld (MERKER),hl
    ld hl,$100
    call SCHLEIFE
        call QCIRC
        ld hl,(MERKER)
        ld de, 5
        add hl,de
        ld (MERKER),hl
    call ENDSCHLEIFE
    ret

    end