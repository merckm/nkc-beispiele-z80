;
; Dragon-Kurve
; Artikel aus Loop 10, Seite 8-11
; von Jens Decker
; VASM Assembler code von Dr. Martin Merck
;
    .include ../Include/z80grund.asm
    .org $8800

MERKER: .equ $87FE

START:
    jp GANZ

RE:
    ld hl,0006H
    call SCHREITE       ; um 6 schreiten
    ld hl,-90
    call DREHE          ; um 90° nach rechts drehen
    ld hl,0006H
    call SCHREITE       ; um 6 schreiten
    ret                 ; Ende rechter Winkel

LI:
    ld hl,0006H
    call SCHREITE       ; um 6 schreiten
    ld hl,90
    call DREHE          ; um 90° nach links drehen
    ld hl,0006H
    call SCHREITE       ; um 6 schreiten
    ret                 ; Ende linker Winkel

RECHTS:
    ld hl,MERKER        ; HL mit Merkeradresse laden
    dec (hl)            ; Merker um eins erniedrigen
    ld a,(MERKER)       ; a aus Merker laden
    cp 01H              ; mit 1 vergleicher
    jr nz,RE1           ; falls ungleich Rekursion
    call RE             ; sonst rechter Winhel
    ld hl,MERKER        ; HL mit Merkeradresse laden
    inc (hl)            ; Merker um eins erhöhen
    ret                 ; Aufstieg in die nächst höhere Ebene
RE1:
    call RECHTS         ; rekursiver Abstieg
    ld hl,-90          
    call DREHE          ; um 90° drehen
    call LINKS          ; rekursiver Abstieg
    ld hl,MERKER        ; HL mit Merkeradresse laden
    inc (hl)            ; Merker um eins erhöhen
    ret                 ; Aufstieg in die nächst höhere Ebene

LINKS:
    ld hl,MERKER        ; HL mit Merkeradresse laden
    dec (hl)            ; Merker um eins erniedrigen
    ld a,(MERKER)       ; a aus Merker laden
    cp 01H              ; mit 1 vergleicher
    jr nz,LI1           ; falls ungleich Rekursion
    call LI             ; sonst rechter Winhel
    ld hl,MERKER        ; HL mit Merkeradresse laden
    inc (hl)            ; Merker um eins erhöhen
    ret                 ; Aufstief in di nächst höhere Ebene
LI1:
    call RECHTS         ; rekursiver Abstieg
    ld hl,90          
    call DREHE          ; um 90° drehen
    call LINKS          ; rekursiver Abstieg
    ld hl,MERKER        ; HL mit Merkeradresse laden
    inc (hl)            ; Merker um eins erhöhen
    ret                 ; Aufstieg in die nächst höhere Ebene

GANZ:  
    ld hl, 0050H
    ld de, 012CH
    ld bc, 005aH
    call SET            ; Turtle passend positionieren
    ld a, 0CH           ; a mit gewünschter Tiefe laden
    ld hl,MERKER        ; HL mit Merkeradresse laden
    ld (hl), a          ; Merker auf die Tiefe setzen
    call RECHTS         ; rechter Winhel als die Superstrukt.
    ret                 ; Ende des Programms

    end