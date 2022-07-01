10  PAGE 0,0: CLRS: CLEAR 1000
11  PRINT FRE(A$)
20  PRINT
30  DIM C1$(40)
40  GOSUB 1070
50  REM DIM C$(72), I$(72), K$(72), F$(72), S$(72), R$(72), P$(72), Z$(37+25+117)
51  DIM Z$(72)
60  DIM S(37), R(37), N(37)
70 N1 = 37
80 N2 = 14
90 N3 = 117
100  FOR X = 1 TO N1 + N2 + N3
110  READ Z$
120  NEXT X
130  FOR X = 1 TO N1
140  READ S(X), L
150  R(X) = S(X)
160  N(X) = S(X) + L - 1
170  NEXT X
180  PRINT "HI!  I'M ELIZA.  WHAT'S YOUR PROBLEM?"
190  REM
200  REM      ----USER INPUT SECTION----
210  REM
220  INPUT I$
230 I$ = " " + I$ + " "
240  REM  GET RID OF APOSTROPHES
250  FOR L = 1 TO LEN(I$)
260  IF MID$(I$, L, 1) <> "'" THEN 290
270  I$ = MID$(I$, 1, L - 1) + MID$(I$, L + 1, LEN(I$) - L)
280  GOTO 260
290  IF L + 4 >= LEN(I$) THEN 330
300  REM IF UCASE$(MID$(I$, L, 4)) <> "SHUT" THEN 330
301  IF (MID$(I$, L, 4)) <> "SHUT" THEN 330
310  PRINT "IF THAT'S HOW YOU FEEL--GOODBY..."
320  STOP
330  NEXT L
331  PRINT I$,"P: ",P$
340  IF I$ = P$ THEN GOTO 370
350  PRINT "PLEASE DON'T REPEAT YOURSELF!"
360 GOTO 190
370  REM
380  REM   ----FIND KEYWORD IN I$----
390  REM
391 PRINT "Was not equal"
400  RESTORE
410 S = 0
420  FOR K = 1 TO N1
430  READ K$
440  IF S > 0 THEN 510
450  FOR L = 1 TO LEN(I$) - LEN(K$) + 1
460  IF MID$(I$, L, LEN(K$)) <> K$ THEN 500
470  S = K
480  T = L
490  F$ = K$
500  NEXT L
510  NEXT K
520  IF S <= 0 THEN 560
530  K = S
540  L = T
550  GOTO 590
560 K = 37   'WE DIDN'T FIND ANY KEYWORDS
570 GOTO 850
580  REM
590  REM     TAKE RIGHT PART OF STRINGS AND CONJUGATE IT
600  REM     USING THE LIST OF STRINGS TO BE SWAPPED
610  REM
620  RESTORE
630  FOR X = 1 TO N1
640  READ Z$
650  NEXT X
660  IF (LEN(I$) - LEN(F$) - L + 1) > 0 THEN 690
670  L = L - 1
680  GOTO 660
690 C$ = " " + MID$(I$, LEN(F$) + L, LEN(I$) - (LEN(F$) + L - 1))
700  FOR X = 1 TO N2 / 2
710  READ S$, R$
720  FOR L = 1 TO LEN(C$)
730  IF L + LEN(S$) > LEN(C$) THEN 770
740  IF MID$(C$, L, LEN(S$)) <> S$ THEN 770
750 C$ = MID$(C$, 1, L - 1) + R$ + MID$(C$, L + LEN(S$), LEN(C$) - (L + LEN(S$) - 1))
760  GOTO 810
770  IF L + LEN(R$) > LEN(C$) THEN 810
780  IF MID$(C$, L, LEN(R$)) <> R$ THEN 810
790 C$ = MID$(C$, 1, L - 1) + S$ + MID$(C$, L + LEN(R$), LEN(C$) - (L + LEN(R$) - 1))
800 L = L + LEN(S$)
810  NEXT L
820  NEXT X
830  IF MID$(C$, 2, 1) = " " THEN C$ = MID$(C$, 2, LEN(C$) - 1)       'ONLY 1SPACE
840  REM
850  REM   NOW USING THE KEYWORD NUMBER (K) GET REPLY
860  REM
870  RESTORE
880  FOR X = 1 TO N1 + N2
890  READ Z$
900  NEXT X
910  FOR X = 1 TO R(K)   'READ RIGHT REPLY
920  READ F$
930  NEXT X
940 R(K) = R(K) + 1
950 IF R(K) > N(K) THEN R(K) = S(K)
960  IF MID$(F$, LEN(F$), 1) = "*" THEN 1000
970  PRINT F$
980  P$ = I$
990  GOTO 190
1000  PRINT MID$(F$, 1, LEN(F$) - 1); C$
1010 P$ = I$
1020 GOTO 190
1030  REM  PRINT CENTER ROUTINE
1040  PRINT TAB(40 - LEN(C1$) / 2); C1$
1050  PRINT
1060  RETURN
1070 C1$ = "*** ELIZA ***"
1080 GOSUB 1030
1090 C1$ = "IN BASIC"
1100 GOSUB 1030
1110 REM C1$ = "MODIFIED FROM CYBER 175 AT UNIVERSITY OF ILLINOIS AT CHAMPAGNE"
1120 REM GOSUB 1030
1130 REM C1$ = "JOHN SCHUGG"
1140 REM GOSUB 1030
1110 C1$ = "MODIFIED FOR NDR-KLEIN COMPUTER"
1120 GOSUB 1030
1130 REM REM C1$ = "MARTIN MERCK"
1140 REM GOSUB 1030
1150 C1$ = "JANUARY 1985, JULY 2022"
1160 GOSUB 1030
1170 C1$ = "HAVE ANY PROBLEMS ?"
1180 GOSUB 1030
1190 C1$ = "LET ELIZA HELP YOU !"
1200 GOSUB 1030
1210  PRINT
1220 C1$ = "TO STOP ELIZA TYPE 'SHUT UP'"
1230 GOSUB 1030
1240 C1$ = "(THIS VERSION WILL NOT RECORD YOUR CONVERSATIONS)"
1250 GOSUB 1030
1260 C1$ = "(PLEASE SEND SUGGESTIONS FOR IMPROVEMENTS TO JOHN SCHUGG)"
1270 GOSUB 1030
1280 REM PRINT "< PRESS RETURN TO CONTINUE...>"
1320  RETURN
1330  REM
1340  REM   ---PROGRAM DATA FOLLOWS---
1350  REM
1360  REM   KEYWORDS:
1370  REM
1380  DATA  "CAN YOU","CAN I","YOU ARE","YOURE","I DONT","I FEEL"
1390  DATA  "WHY DONT YOU","WHY CANT I","ARE YOU","I CANT","I AM","IM "
1400  DATA  "YOU ","I WANT","WHAT","HOW","WHO","WHERE","WHEN","WHY"
1410  DATA  "NAME","CAUSE","SORRY","DREAM","HELLO","HI ","MAYBE"
1420  DATA  " NO","YOUR","ALWAYS","THINK","ALIKE","YES","FRIEND"
1430  DATA  "COMPUTER","CAR","NOKEYFOUND"
1440  REM
1450  REM  ---STRING DATA FOR CONJUGATIONS---
1460  REM
1470  DATA  " ARE "," AM ","WERE ","WAS "," YOU "," I ","YOUR ","MY "
1480  DATA  " IVE "," YOUVE "," IM "," YOURE "," YOU "," ME "
1490  REM
1500  REM    ----REPLIES----
1510  REM
1520  DATA  "DON'T YOU BELIEVE THAT I CAN*"
1530  DATA  "PERHAPS YOU WOULD LIKE TO BE ABLE TO*"
1540  DATA  "YOU WANT ME TO BE ABLE TO*"
1550  DATA  "PERHAPS YOU DON'T WANT TO*"
1560  DATA  "DO YOU WANT TO BE ABLE TO*"
1570  DATA  "WHAT MAKES YOU THINK I AM*"
1580  DATA  "DOES IT PLEASE YOU TO BELIEVE I AM*"
1590  DATA  "PERHAPS YOU WOULD LIKE TO BE*"
1600  DATA  "DO YOU SOMETIMES WISH YOU WERE*"
1610  DATA  "DON'T YOU REALLY*"
1620  DATA  "WHY DON'T YOU*"
1630  DATA  "DO YOU WISH TO BE ABLE TO*"
1640  DATA  "DOES THAT TROUBLE YOU?"
1650  DATA  "TELL ME MORE ABOUT SUCH FEELINGS."
1660  DATA  "DO YOU OFTEN FEEL*"
1670  DATA  "DO YOU ENJOY FEELING*"
1680  DATA  "DO YOU REALLY BELIEVE I DON'T*"
1690  DATA  "PERHAPS IN GOOD TIME I WILL*"
1700  DATA  "DO YOU WANT ME TO*"
1710  DATA  "DO YOU THINK YOU SHOULD BE ABLE TO*"
1720  DATA  "WHY CAN'T YOU*"
1730  DATA  "WHY ARE YOU INTERESTED IN WHETHER OR NOT I AM*"
1740  DATA  "WOULD YOU PREFER IF I WERE NOT*"
1750  DATA  "PERHAPS IN YOUR FANTASIES I AM*"
1760  DATA  "HOW DO YOU KNOW YOU CAN'T*"
1770  DATA  "HAVE YOU TRIED?"
1780  DATA  "PERHAPS YOU CAN NOW*"
1790  DATA  "DID YOU COME TO ME BECAUSE YOU ARE*"
1800  DATA  "HOW LONG HAVE YOU BEEN*"
1810  DATA  "DO YOU BELIEVE IT IS NORMAL TO BE*"
1820  DATA  "DO YOU ENJOY BEING*"
1830  DATA  "WE WERE DISCUSSING YOU-- NOT ME."
1840  DATA  "OH, I*"
1850  DATA  "YOU'RE NOT REALLY TALKING ABOUT ME, ARE YOU?"
1860  DATA  "WHAT WOULD IT MEAN TO YOU IF YOU GOT*"
1870  DATA  "WHY DO YOU WANT*"
1880  DATA  "SUPPOSE YOU SOON GOT*"
1890  DATA  "WHAT IF YOU NEVER GOT*"
1900  DATA  "I SOMETIMES ALSO WANT*"
1910  DATA  "WHY DO YOU ASK?"
1920  DATA  "DOES THAT QUESTION INTEREST YOU?"
1930  DATA  "WHAT ANSWER WOULD PLEASE YOU THE MOST?"
1940  DATA  "WHAT DO YOU THINK?"
1950  DATA  "ARE SUCH QUESTIONS ON YOUR MIND OFTEN?"
1960  DATA  "WHAT IS IT THAT YOU REALLY WANT TO KNOW?"
1970  DATA  "HAVE YOU ASKED ANYONE ELSE?"
1980  DATA  "HAVE YOU ASKED SUCH QUESTIONS BEFORE?"
1990  DATA  "WHAT ELSE COMES TO MIND WHEN YOU ASK THAT?"
2000  DATA  "NAMES DON'T INTEREST ME."
2010  DATA  "I DON'T CARE ABOUT NAMES-- PLEASE GO ON."
2020  DATA  "IS THAT THE REAL REASON?"
2030  DATA  "DON'T ANY OTHER REASONS COME TO MIND?"
2040  DATA  "DOES THAT REASON EXPLAIN ANY THING ELSE?"
2050  DATA  "WHAT OTHER REASONS MIGHT THERE BE?"
2060  DATA  "PLEASE DON'T APOLOGIZE."
2070  DATA  "APOLOGIES ARE NOT NECESSARY."
2080  DATA  "WHAT FEELINGS DO YOU HAVE WHEN YOU APOLOGIZE?"
2090  DATA  "DON'T BE SO DEFENSIVE!"
2100  DATA  "WHAT DOES THAT DREAM SUGGEST TO YOU?"
2110  DATA  "DO YOU DREAM OFTEN?"
2120  DATA  "WHAT PERSONS APPEAR IN YOUR DREAMS?"
2130  DATA  "ARE YOU DISTURBED BY YOUR DREAMS?"
2140  DATA  "HOW DO YOU DO--PLEASE STATE YOUR PROBLEM."
2150  DATA  "YOU DON'T SEEM QUITE CERTAIN."
2160  DATA  "WHY THE UNCERTAIN TONE?"
2170  DATA  "CAN'T YOU BE MORE POSITIVE?"
2180  DATA  "YOU AREN'T SURE?"
2190  DATA  "DON'T YOU KNOW?"
2200  DATA  "ARE YOU SAYING NO JUST TO BE NEGATIVE?"
2210  DATA  "YOU ARE BEING A BIT NEGATIVE."
2220  DATA  "WHY NOT?"
2230  DATA  "ARE YOU SURE?"
2240  DATA  "WHY NO?"
2250  DATA  "WHY ARE YOU CONCERNED ABOUT MY*"
2260  DATA  "WHAT ABOUT YOUR OWN*"
2270  DATA  "CAN YOU THINK OF A SPECIFIC EXAMPLE?"
2280  DATA  "WHEN?"
2290  DATA  "WHAT ARE YOU THINKING OF?"
2300  DATA  "REALLY, ALWAYS?"
2310  DATA  "DO YOU REALLY THINK SO?"
2320  DATA  "BUT YOU ARE NOT SURE YOU*"
2330  DATA  "DO YOU DOUBT YOU*"
2340  DATA  "IN WHAT WAY?"
2350  DATA  "WHAT RESEMBLANCE DO YOU SEE?"
2360  DATA  "WHAT DOES THE SIMILARITY SUGGEST TO YOU?"
2370  DATA  "WHAT OTHER CONNECTIONS DO YOU SEE?"
2380  DATA  "COULD THERE REALLY BE SOME CONNECTION?"
2390  DATA  "HOW?"
2400  DATA  "YOU SEEM QUITE POSITIVE."
2410  DATA  "ARE YOU SURE?"
2420  DATA  "I SEE."
2430  DATA  "I UNDERSTAND."
2440  DATA  "WHY DO YOU BRING UP THE TOPIC OF FRIENDS?"
2450  DATA  "DO YOUR FRIENDS WORRY YOU?"
2460  DATA  "DO YOUR FRIENDS PICK ON YOU?"
2470  DATA  "ARE YOU SURE YOU HAVE ANY FRIENDS?"
2480  DATA  "DO YOU IMPOSE ON YOUR FRIENDS?"
2490  DATA  "PERHAPS YOUR LOVE FOR FRIENDS WORRIES YOU?"
2500  DATA  "DO COMPUTERS WORRY YOU?"
2510  DATA  "ARE YOU TALKING ABOUT ME IN PARTICULAR?"
2520  DATA  "ARE YOU FRIGHTENED BY MACHINES?"
2530  DATA  "WHY DO YOU MENTION COMPUTERS?"
2540  DATA  "WHAT DO YOU THINK MACHINES HAVE TO DO WITH YOUR PROBLEM?"
2550  DATA  "DON'T YOU THINK COMPUTERS CAN HELP PEOPLE?"
2560  DATA  "WHAT IS IT ABOUT MACHINES THAT WORRIES YOU?"
2570  DATA  "OH, DO YOU LIKE CARS?"
2580  DATA  "MY FAVORITE CAR IS A LAMBORGINI COUNTACH. WHAT IS YOUR FAVORITE CAR?"
2590  DATA  "MY FAVORITE CAR COMPANY IS FERRARI.  WHAT IS YOURS?"
2600  DATA  "DO YOU LIKE PORSCHES?"
2610  DATA  "DO YOU LIKE PORSCHE TURBO CARRERAS?"
2620  DATA  "SAY, DO YOU HAVE ANY PSYCHOLOGICAL PROBLEMS?"
2630  DATA  "WHAT DOES THAT SUGGEST TO YOU?"
2640  DATA  "I SEE."
2650  DATA  "I'M NOT SURE I UNDERSTAND YOU FULLY."
2660  DATA  "COME COME ELUCIDATE YOUR THOUGHTS."
2670  DATA  "CAN YOU ELABORATE ON THAT?"
2680  DATA  "THAT IS QUITE INTERESTING."
2690  REM
2700  REM     ---DATA FOR FINDING RIGHT REPLIES---
2710  REM
2720  DATA  1,3,4,2,6,4,6,4,10,4,14,3,17,3,20,2,22,3,25,3
2730  DATA  28,4,28,4,32,3,35,5,40,9,40,9,40,9,40,9,40,9,40,9
2740  DATA  49,2,51,4,55,4,59,4,63,1,63,1,64,5,69,5,74,2,76,4
2750  DATA  80,3,83,7,90,3,93,6,99,7,106,5,111,6
2760  REM
2770  REM
2780  REM  LAST MOD. JULY 1979
2790  REM
2800  REM  ' ELIZA '
2810  END