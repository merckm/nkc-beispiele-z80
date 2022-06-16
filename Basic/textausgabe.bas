10 CLEAR 100: CLRS
20 GDP=HEX("70")
30 INPUT "TEXT:";A$
40 INPUT "SCHRIFTGROESSE:";X
50 PAGE 0,0
60 OUT GDP+3,X+X*16:            REM Port 73 = Vergroesserung
70 MOVETO 0,0:                  REM Linke untere Ecke
80 FOR I = 1 TO LEN(A$)
85 OUT GDP,ASC(MID$(A$,I,1)):   REM Ausgabe der ASCII-Werte PORT 70
90 WAIT GDP,4,0:                REM Warteschleife bis GDP fertig
100 NEXT I
110 OUT GDP+3,1+16:             REM alte Schriftgroesse 
120 POKE HEX("87C5"),0:         REM Curor aus 
130 INPUT"Nochmal";X$
140 IF X$ = "J" THEN 10
150 END