* Encoding: windows-1252.
***.
* v02 - 2020-04-21. Subtitle has been edited. Labels in French and Spanish have been removed.
***.

include "surveyname.sps".

get file = "wm.sav".

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

compute heardFgm = 0.
if (FG1 = 1 or FG2 = 1) heardFgm = 100.
if (FG1 = 1 or FG2 = 1) numHeard = 1.
variable labels heardFgm "Percentage of women who have heard of FGM".
value labels numHeard 1 "Number of women who have heard of FGM".

recode FG24 (8,9 = 9) (else = copy).
variable labels FG24 "Percent distribution of women who believe the practice of FGM should be:".
value labels FG24
  1 "Continued [1]"
  2 "Discontinued"
  3 "Depends"
  9 "DK/Missing".

compute womanFgm = 1.
if (FG3 = 1) womanFgm = 2.
variable labels womanFgm "FGM experience".
value labels womanFgm
  1 "No FGM"
  2 "Had FGM".

compute numWomen = 1.
value labels numWomen 1 "Number of women".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".
	   
* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = numWomen numHeard
           display = none
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + $wage [c]
        + welevel [c]
        + womanFgm [c]         
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
   by
          heardFgm [s] [mean '' f5.1]
        + numWomen [c] [count '' f5.0]
        + FG24 [c] [rowpct.validn '' f5.1]
        + numHeard [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables = FG24 total = yes position = after labels = "Total"
  /slabels position=column visible = no
  /titles title=
     "Table PR.5.2: Approval of female genital mutilation/cutting (FGM)"
     "Percentage of women age 15-49 years who have heard of FGM, and percent distribution of women by their attitude towards continuation of the practice of FGM, " + surveyname
   caption =
     "[1] MICS indicator PR.10 - Approval for FGM"
  .

new file.
