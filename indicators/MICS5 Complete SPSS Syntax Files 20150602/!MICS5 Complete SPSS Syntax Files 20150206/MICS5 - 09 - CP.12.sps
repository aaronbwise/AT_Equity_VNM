* MICS5 CP-12 .

* v01 - 2013-10-24.
* v02 - 2014-04-22.
* value labels heardFGM1 "Number of women age 15-49 years who have heard of FGM/C".
* correctd to value labels numHeard.


* Women who have heard of FGM/C:
    FG1=1 or FG2=1

*  Women who believe that the practice of FGM/C should be continued:
    FG22=1 .

***.

include "surveyname.sps".

get file = "wm.sav".

select if (WM7 = 1).

weight by wmweight.

compute heardFgm = 0.
if (FG1 = 1 or FG2 = 1) heardFgm = 100.
if (FG1 = 1 or FG2 = 1) numHeard = 1.
variable labels heardFgm "Percentage of women who have heard of FGM/C".
value labels numHeard 1 "Number of women age 15-49 years who have heard of FGM/C".

recode FG22 (8,9 = 9) (else = copy).
variable labels FG22 "Percent distribution of women who believe the practice of FGM/C should be:".
value labels FG22
  1 "Continued [1]"
  2 "Discontinued"
  3 "Depends"
  9 "Don't know/Missing".

compute womanFgm = 1.
if (FG3 = 1) womanFgm = 2.
variable labels womanFgm "FGM/C experience".
value labels womanFgm
  1 "No FGM/C"
  2 "Had FGM/C".

compute numWomen = 1.
value labels numWomen 1 "Number of women aged 15-49 years".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = numWomen numHeard
           display = none
  /table  total [c]
        + hh7 [c]
        + hh6 [c]
        + wage [c]
        + welevel [c]
        + womanFgm [c]
        + windex5 [c]
        + ethnicity [c]
   by
          heardFgm [s] [mean,'',f5.1]
        + numWomen [c] [count,'',f5.0]
        + FG22 [c] [rowpct.validn,'',f5.1]
        + numHeard [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var = FG22 total = yes position = after labels = "Total"
  /slabels position=column visible = no
  /title title=
     "Table CP.12: Approval of female genital mutilation/cutting (FGM/C)"
     "Percentage of women age 15-49 years who have heard of FGM/C, and percent distribution of women according to attitudes towards " +
     "whether the practice of FGM/C should be continued" + surveyname
   caption =
     "[1] MICS indicator 8.9 - Approval for FGM/C"
  .

new file.
