
;
; Beispiel Program aus "Rechner Modular" Seite 285
; Author Rolf-Dieter Klein
; VASM Assembler code von Dr. Martin Merck
;
    .include ../Include/z80grund.asm
    .org $8800

TEXT:
    .word 160
    .word 130
    .byte $33
    .byte 0
    .byte "HALLO"
    .byte 0

TEXT1:
    .word 300
    .word 130
    .byte $33
    .byte 0
    .byte "HALLO"
    .byte 0

HALLOTXT:
    ld hl,TEXT1
    call WRITE
    ld hl,60
    call SCHLEIFE
        ld hl,120
        call SCHREITE
   	    ld hl,90
        call DREHE
        ld hl,1
        call SCHREITE
   	    ld hl,90
        call DREHE
        ld hl,120
        call SCHREITE
   	    ld hl,-90
        call DREHE
        ld hl,1
        call SCHREITE
   	    ld hl,-90
        call DREHE
	call ENDSCHLEIFE
    call WAIT
    ld a,$01
    out ($70),a
    ld hl,TEXT
    call WRITE
    ret
