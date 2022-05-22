;
; Beispiel Program aus "Rechner Modular" Seite 287
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;
    .include ../Include/z80grund.asm
    .org $8800

MEHRKREISE:

    ld hl,300
    ld ($8900),HL
    ld hl,120   
    call SCHLEIFE
        ld hl,36
        call SCHLEIFE
            ld hl,(&8900)
            call SCHR16TEL
            ld hl,10
            call DREHE
        call ENDSCHLEIFE
        ld hl,(&8900)
        ld de,-5
        add hl,de
        ld ($8900),HL
     call ENDSCHLEIFE
    ret
    end