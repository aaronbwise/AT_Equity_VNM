* Encoding: windows-1252.
***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
***.
include "surveyname.sps".

get file = "wm.sav".

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

compute anyFgm = 0 .
if (FG3 = 1) anyFgm = 100 .
variable labels anyFgm "Percentage who had any form of FGM [1]".

do if (FG3 = 1) .
+ compute fgmType = 4 .
+ if (FG4 = 1) fgmType = 1 .
+ if (FG5 = 1) fgmType = 2 .
+ if (FG6 = 1) fgmType = 3 .
end if .
variable labels fgmType "Percent distribution of women who had FGM:".
value labels  fgmType 
  1 "Had flesh removed" 
  2 "Were nicked" 
  3 "Were sewn closed" 
  4 "Form of FGM not determined" .
  
if (FG3 = 1) numFgm = 1 .
value labels numFgm 1 "Number of women  who had FGM" .

compute numWomen = 1 .
value labels numWomen 1 "Number of women" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = numWomen numFgm
           display = none
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + $wage [c]
        + welevel [c]
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
   by 
 	       anyFgm [s] [mean '' f5.1]
         + numWomen [c] [count '' f5.0]
         + fgmType [c] [rowpct.validn '' f5.1]
         + numFgm [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=fgmType total=yes
  /slabels position=column visible = no
  /titles title=
     "Table PR.5.1: Female genital mutilation/cutting (FGM) among women"
	 "Percentage of women age 15-49 years by FGM status and percent distribution of women who had FGM by type of FGM, " + surveyname
   caption =
     "[1] MICS indicator PR.9 - Prevalence of FGM among women"
  .

new file.
