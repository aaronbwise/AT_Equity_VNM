* Encoding: windows-1252.
***.

* v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

select if (WM17 = 1).

weight by wmweight.

recode CM11 (sysmis = 0) .

do if (WB4 >=15 and WB4<=19).
+ compute numWoman15 = 1.
+ compute hadBirth = 0.
+ if (CM11 > 0) hadBirth = 100.
+ compute firstChild = 0.
+ if (hadBirth = 0 and CP1 = 1) firstChild = 100.
+ compute begunChildbearing = 0.
+ if (hadBirth = 100 or CP1 = 1) begunChildbearing  = 100.
+ compute birthBefore15 = 0.
+ if ((wdobfc - wdob)/12 < 15) birthBefore15 = 100.
end if.

variable labels
   numWoman15 "Number of women age 15-19 years"
  /hadBirth "Have had a live birth"
  /firstChild "Are pregnant with first child"
  /begunChildbearing "Have had a live birth or are pregnant with first child"
  /birthBefore15 "Have had a live birth before age 15"
  .

do if (WB4 >=20 and WB4 <= 24).
+ compute numWoman20 = 1.
+ compute birthBefore18 = 0.
+ if ((wdobfc - wdob)/12 < 18) birthBefore18 = 100.
end if.

variable labels
   numWoman20 "Number of women age 20-24 years"
  /birthBefore18 "Percentage of women age 20-24 years who have had a live birth before age 18 [1]"
  .

compute layer = 0.
value labels layer 0 "Percentage of women age 15-19 years who:".
variable labels layer " ".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

* Ctables command in English.
ctables
  /vlabels variables = layer
           display = none
  /table   total [c]
         + HH6 [c]
         + hh7 [c]
         + welevel [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]     
   by
           layer [c] > (
             hadBirth [s] [mean '' f5.1]
           + firstChild [s] [mean '' f5.1]
           + begunChildbearing [s] [mean '' f5.1]
           + birthBefore15 [s] [mean '' f5.1] )
         + numWoman15 [s] [sum '' f5.0]
         + birthBefore18 [s] [mean '' f5.1]
         + numWoman20 [s] [sum '' f5.0]
  /slabels position=column visible =no
  /categories variables=all empty=exclude missing=exclude
  /titles title=
                 "Table TM.2.2W: Early childbearing (young women)"						
                 "Percentage of women age 15-19 years who have had a live birth, are pregnant with the first child, have had a live birth or are pregnant with first child, "+
                 "and who have had a live birth before age 15, and percentage of women age 20-24 years who have had a live birth before age 18, " + surveyname
   caption =
     "[1] MICS indicator TM.2 - Early childbearing"
  .
  
new file.
