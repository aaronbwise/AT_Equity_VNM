* Encoding: windows-1252.

***.

* v02 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

select if (WB4>=15 and WB4<=24).

weight by wmweight.

include 'define\MICS6 - 06 - TM.sps' .

compute layerCan = 0.
variable labels layerCan "".
value labels layerCan 0 "Percentage of women age 15-24 years who:".

variable labels comprehensiveKnowledge "Have comprehensive knowledge [1]".

variable labels allThree "Know all three means of HIV transmission from mother to child".
variable labels knowPlace "Know a place to get tested".
variable labels toldResult12 "Have been tested for HIV in the last 12 months and know the result".

do if (HA1 = 1).
+ compute discriminatory=0.
+ if (food =100 or school=100) discriminatory=100.
+ compute numHeard = 1.
end if.
variable labels discriminatory "Percentage who report discriminatory attitudes towards people living with HIV [A]".
variable labels numHeard "".
value labels numHeard 1 "Number of women age 15-24 years who have heard of AIDS".

do if (sex12 = 100).
+ compute toldResultActive=0.
+ if (toldResult12 = 100) toldResultActive=100.
+ compute numSex = 1.
end if.
variable labels toldResultActive "Percentage of sexually active young women who have been tested for HIV in the last 12 months and know the result [2]".
variable labels numSex "".
value labels numSex 1 "Number of women age 15-24 years who had sex in the last 12 months".

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women age 15-24 years".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* ctables command in English.
ctables
  /vlabels variables = numWomen numSex numHeard layerCan  total
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + $wagex [c]
         + welevel [c]
         + mstatus2 [c]
         + disability [c]
         + ethnicity [c]
         + windex5 [c]
   by
         layerCan [c] > 
         (comprehensiveKnowledge [s] [mean '' f5.1] + allThree [s] [mean '' f5.1] + knowPlace [s] [mean '' f5.1] + toldResult [s] [mean '' f5.1] + toldResult12 [s] [mean '' f5.1]  + sex12 [s] [mean '' f5.1])
         + numWomen[c][count '' f5.0]
         + toldResultActive [s] [mean '' f5.1] + numsex [count '' f5.0]
         + discriminatory [s] [mean '' f5.1] + numHeard [count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /titles title=
    "Table TM.11.6W: Key HIV and AIDS indicators (young women)"
    "Percentage of women age 15-24 years by key HIV and AIDS indicators,  " + surveyname
   caption =
      "[1] MICS indicator TM.29 - Comprehensive knowledge about HIV prevention among young people"										
      "[2] MICS indicator TM.34 - Sexually active young people who have been tested for HIV and know the results"									
      "[A] Refer to Table TM.11.3W for the two components."
  .

new file.
