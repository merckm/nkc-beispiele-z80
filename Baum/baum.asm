;
; Baum aus Rekursives Programmieren - schon mit der SBC2
; Artikel aus Loop 10, Seite 7-8
; von Jens Decker
; VASM Assembler code von Dr. Martin Merck
;
    .include ../Include/z80grund.asm
    .org $8800

MERKER: .equ $87FE

START:
    jp AUFRUF

DIV16:
    ld hl,0000H         ; löschen Akkumulator
    ld b,10H            ; Bitzähler auf 16
.DIV16_1:
    rl c
    rl a                ; Dividend raus-Ergebnis rein
    adc hl,hl           ; links schieben
    sbc hl,de           ; Subtraktion
    jr nc,.DIV16_2      ; möglich?
    add hl,de           ; Akkumulator wieder herstellen
.DIV16_2:
    ccf                 ; Ergebnisbit erzeugen
    djnz .DIV16_1       ; Ende der Schleife
    rl c
    rl a                ; letztes Ergebnis rein
    ret                 ; Ende der Divisionsroutine

NEULANG:
    ld de,0003H         ; Divisot für DIV16
    ld a,b
    ld h,b
    ld l,c              ; bc nach hl
    add hl,hl           ; verdoppeln
    ld a,h
    ld c,l              ; und nach ac (=Dividend)
    call DIV16          ; dividieren
    ld b,a              ; und Ergebnis nach bc
    ret

AESTCHEN:
    push bc
    pop hl              ; bc nach hl
    call SCHREITE       ; Zeichnen des Ästchens
    ld hl,180           ; um 180° drehen
    call DREHE          ; "
    push bc
    pop hl              ; bc nach hl
    call SCHREITE       ; zurück
    ld hl,180           ; in die Ausgangsrichtung drehen
    call DREHE          ; "
    ld hl,MERKER        ; hl mit Merckeradresse laden
    inc (hl)            ; Merker um eins erhöhen und
    ret                 ; eine Ebene höher

BAUM:
    ld hl, MERKER       ; hl mit Merkeradresse laden
    dec (hl)            ; Merker um eins erniedrigen
    ld a, (MERKER)      ; a mit Merker laden
    cp 0                ; mit 0 vergleichen
    jr nz, .BAUM1       ; falls nicht, dann Baum
    call AESTCHEN       ; sonst Ästchen
    ld hl, MERKER       ; hl mit Merkeradresse laden
    inc (hl)            ; Merker um eins erhöhen und
    ret                 ; eine Ebene höher
.BAUM1
    push bc
    pop hl              ; bc nach hl
    call SCHREITE       ; Stamm malen
    ld hl, 30           ; um 30° drehen
    call DREHE          ; "
    push bc             ; bc retten, da abgestiegen wird
    call NEULANG        ; neue Länge
    call BAUM           ;Selbstaufruf = Abstieg
    ld hl, MERKER       ; hl mit Merkeradresse laden
    dec (hl)            ; Merker um eins erniedrigen
    ld hl,-50           ; um 50° nach rechts drehen
    call DREHE
    pop bc              ; bc wieder holen
    push bc             ; und eine Kopie retten
    call NEULANG        ; neue Länge
    call BAUM           ; Selbstaufruf = Abstieg
    ld hl, 200          ; um 200° drehen
    call DREHE
    pop hl              ; Lämge wieder holen
    call SCHREITE       ; zurückgehen
    ld hl, 180          ; um 180° in Ausgangslage
    call DREHE          ; drehen
    ld hl, MERKER       ; hl mit Merkeradresse laden
    inc (hl)            ; Merker um eins erhöhen
    ret                 ; Ende Baum

AUFRUF:
    ld hl, 256
    ld de, 0
    ld bc, 90
    call SET
    ld hl, 15
    ld (MERKER), hl
    ld bc, 160
    call BAUM
    ret

    end