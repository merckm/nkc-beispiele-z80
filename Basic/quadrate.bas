  1 REM GITTERNETZ 25*25 FELDER
  5 CLRS
 10 PAGE 0,0
 20 FOR I = 0 TO 500 STEP 20
 30 MOVETO I,0
 40 DRAWTO I,250
 50 NEXT
 60 FOR I = 0 TO 500 STEP 10
 70 MOVETO 0,I
 80 DRAWTO 500,I
 90 NEXT
100 GOTO 100