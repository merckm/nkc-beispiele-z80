;**********************************
;* Oscilloscpü-Programm Rev 1.0   *
;* (C) 1084 Rolf-Dieter Klein     *
;* Damit ist es moeglich          *
;* Abgeliche, etc. mot Z80+GDP    *
;* durchzufuehren. Es wird das    *
;* Z80-Grundprogramm benoetigt    *
;* Dieses Programm auf Adr 8800   *
;* gelegt.                        *
;**********************************

IOE = $30     ; IO-Karte Basis

    .include ../Include/z80grund.asm

    org 8400h       ; RAM Speicher vpn 8400 bis 87FF

synstate:   ds 1
merker:     ds 1
bcd1:       ds 2
bcd2:       ds 2
buffer:     ds 80
data:       ds 256+256  ; Datenspeicher fuer Kanaele

stack = $87FF

PAGE = $60
GDP  = $70

    org 8800h       ; RAM Speicher vpn 8400 bis 87FF
    jp start

; Unterprogramme
wait:
    push af
wait1:
    in a,(GDP)
    and 4
    jr z,wait1
    pop af
    ret

cmd:                ; Befehl an GDP ausgeben
    call wait
    out (GDP),a
    ret

setpage:            ; Seite in Akku
    call wait
    and 0F0h        ; wwrr0000
    out (PAGE),a    ; w= write r=read
    ret

setpen:
    call wait
    ld a,00000011b
    out (GDP+1),a
    ret

eraspen:
    call wait
    ld a,00000001b
    out (GDP+1),a
    ret

sync:               ; warten auf vb
    in a,(GDP)
    and 2
    jr z,sync1
    ld a,(synstate)
    or a
    scf             ; set carry flag
    ret nz          ; <>0 dann carry
    inc a
    ld (synstate),a
    xor a
    ret
sync1:
    xor a
    ld (synstate),a
    scf
    ret

gitter:             ; Seite = 3 Gitteraufbau
                    ; 256 = 5V
                    ; 10 Teile
    call setpen
    ld a,11111000b  ; screin,lese = 3
    call setpage    ; wait incl.
    ld a,00000001b  ; dotted line
    out (GDP+2),a
    ld de,0         ; Start
    ld hl,11        ; 11 Linien (10 Unterteilungen)
.L1:
    push hl         ; Linienzaehler
    ld hl,0
    call moveto     ; noveto de*25, 0
    ld hl,510
    push de
    call drawto     ; drawto de*25, 510
    pop de
    ld hl,25        ; inc de by 25
    add hl,de
    ex de,hl
    pop hl
    dec hl          ; dec. Schleifenzaehler
    ld a,h
    or l
    jp nz,.L1       ; end schleife
                    ;
    ld hl,0
    ld de,11
.L2:
    push de         ; Linienzaehler
    ld de,0
    call moveto     ; noveto 0, hl*51
    ld de,250
    push hl
    call drawto     ; drawto 250, hl*51
    pop hl
    ld de,51        ; inc hl by 51
    add hl,de
    pop de
    dec hl          ; dec. Schleifenzaehler
    ld a,d
    or e
    jp nz,.L2       ; end schleife
                    ;
    call wait
    ld a,0
    out (GDP+2),a   ; reset linestype

    ; Mittel-Linien
    ld hl,0
    ld de,5*25
    call moveto
    ld hl,510
    ld de,5*25
    call drawto
    ld hl,5*51
    ld de,0
    call moveto
    ld hl,5*51
    ld de,250
    call drawto
    ret

getframe:           ; einen Datenblock laden
                    ; Bit 0 = Messport A + Trigger
                    ; Bit 1 = Messport B
get1:
    in a,(IOE)      ; einlesen für trigger
    rrca
    jr c,get1
get2:
    in a,(IOE)
    rrca            ; 4 T-states
    jr nc,get2      ;   -----_____-----_____-----Trigger start
                    ; 7 T-states condition not met
    ld hl,data      ; 10 T-States
    ld b,0          ; 7 T-States
    ld c, IOE       ; 7 T-States
    inir            ; lade 2*256 Bytes von IOE in HL
    inir            ; 21T-Zyklen=5.25us pro Abtastpunkt bei 4MHz
    ret
                    ; vom Trigger bis INIR ca. 35T Zyklen = 8,75us          

abgleich1: 
    ret

abgleich2:
    ret
help:
    ret

drawto:
moveto:
clearall:
textaus:
menuein:
    ret

; Hauptprogramm
;
start:
    ld sp, stack
    xor a
    call clearall
    ld a,0
    call setpage
    ld hl,meld1
    call textaus
    ld hl,meld2
    call textaus
    ld hl,meld3
    call textaus
    ld hl,meld4
    call textaus

    call menuein

    cp '1'          ; if a='1'
    jp nz,menu2
    call abgleich1
    jp start
menu2:
    cp '2'          ; if a='2'
    jp nz,menu3
    call abgleich2
    jp start
menu3:
    cp '3'          ; if a='3'
    jp nz,menu4
    call help
    jp start
menu4:
    cp '4'          ; if a='4'
    jp nz,start
                    ; fuer Erweiterungen
    jp start


meld1:
    defw 40,220     ; x,y
    defb 44h,0
    defb 'RDK-Digital-Scop'
    defb 0    
meld2:
    defw 50,160     ; x,y
    defb 22h,0
    defb '1 = Periodendauer,     1-Kanal'
    defb 0    
meld3:
    defw 50,130     ; x,y
    defb 22h,0
    defb '2 = Vergleichsmessung, 2-Kanal'
    defb 0    
meld4:
    defw 50,100     ; x,y
    defb 22h,0
    defb '3 = Kurzerklaerung'
    defb 0    

    end