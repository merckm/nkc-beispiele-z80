  5 CLRS:PAGE 0,0
 10 X = RND(1)*511
 20 Y = RND(1)*250
 30 MOVETO X,Y
 40 GOSUB 100
 50 GOTO 10
100 REM WUERFEL
110 X = X + 10:GOSUB 200
110 Y = Y + 5:GOSUB 200
110 X = X - 10:GOSUB 200
110 Y = Y - 5
200 DRAWTO X,Y:RETURN
