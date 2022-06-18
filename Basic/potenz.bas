100 REM Programm zur Berechnung einer Tabell#End Region
101 REM von positivien ud negativen Potenzen der Zahl 2
110 FOR N=1 TO 12
120 GOSUB 210
130 PRINT X,N,1.0/X
140 NEXT N
150 END

210 REM Unterprogramm zur berechnung von 2**n
220 X = 1
230 FOR I=1 TO N
240 X = 2 * X
250 NEXT I
260 RETURN