* Encoding: windows-1252.

***.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'mn.sav'.

include "CommonVarsMN.sps".

select if (MWM17 = 1).

select if (MWB4>=15 and MWB4<=24).

weight by mnweight.

include 'define\MICS6 - 06 - TM.M.sps' .

compute layerCan = 0.
variable labels layerCan "".
value labels layerCan 0 "Percentage of men age 15-24 years who:".

variable labels comprehensiveKnowledge "Have comprehensive knowledge [1]".

variable labels allThree "Know all three means of HIV transmission from mother to child".
variable labels knowPlace "Know a place to get tested".
variable labels toldResult12 "Have been tested for HIV in the last 12 months and know the result".

do if (MHA1 = 1).
+ compute discriminatory=0.
+ if (food =100 or school=100) discriminatory=100.
+ compute numHeard = 1.
end if.
variable labels discriminatory "Percentage who report discriminatory attitudes towards people living with HIV [A]".
variable labels numHeard "".
value labels numHeard 1 "Number of men age 15-24 years who have heard of AIDS".

do if (sex12 = 100).
+ compute toldResultActive=0.
+ if (toldResult12 = 100) toldResultActive=100.
+ compute numSex = 1.
end if.
variable labels toldResultActive "Percentage of sexually active young men who have been tested for HIV in the last 12 months and know the result [2]".
variable labels numSex "".
value labels numSex 1 "Number of men age 15-24 years who had sex in the last 12 months".

compute nummen = 1.
variable labels nummen "".
value labels nummen 1 "Number of men age 15-24 years".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* ctables command in English.
ctables
  /vlabels variables = nummen numSex numHeard layerCan  total
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + $mwagex [c]
         + mwelevel [c]
         + mmstatus2 [c]
         + mdisability [c]
         + ethnicity [c]
         + windex5 [c]
   by
         layerCan [c] > 
         (comprehensiveKnowledge [s] [mean '' f5.1] + allThree [s] [mean '' f5.1] + knowPlace [s] [mean '' f5.1] + toldResult [s] [mean '' f5.1] + toldResult12 [s] [mean '' f5.1]  + sex12 [s] [mean '' f5.1])
         + nummen[c][count '' f5.0]
         + toldResultActive [s] [mean '' f5.1] + numsex [count '' f5.0]
         + discriminatory [s] [mean '' f5.1] + numHeard [count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /titles title=
    "Table TM.11.6M: Key HIV and AIDS indicators (young men)"
    "Percentage of men age 15-24 years by key HIV and AIDS indicators,  " + surveyname
   caption =
      "[1] MICS indicator TM.29 - Comprehensive knowledge about HIV prevention among young people"										
      "[2] MICS indicator TM.34 - Sexually active young people who have been tested for HIV and know the results"									
      "[A] Refer to Table TM.11.3M for the two components."
  .

new file.
