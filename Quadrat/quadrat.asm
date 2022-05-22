
    .include ../Include/z80grund.asm
    .org $8800

START:
    ; kleines Beispiel
    ld hl,4
    call SCHLEIFE
        ld hl,100
        call SCHREITE
        ld hl,90
        call DREHE
    call ENDSCHLEIFE
    ret
    end