* MICS5 SW-03.

* v01 - 2013-06-22.

* Women who think that their life has improved during the last one year:
     LS14=1.

* Women who expect that their life will get better after one year:
     LS15=1.

* Women who think their life has been improving and will continue to improve:
     (LS14=1 and LS15=1).

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open women dataset.
get file = 'wm.sav'.

* Select completed interviews.
select if (WM7 = 1).

* Select men aged 15-24.
select if (wage = 1 or wage = 2).

* Weight the data by the women weight.
weight by wmweight.

* Create marital status with separate groups for ever married married.
recode mstatus  (1, 2 = 1) (3 = 2) (else = 9).
variable labels mstatus  "Marital status".
value labels mstatus 
    1 "Ever married/in union"
    2 "Never married/in union"
    9 "Missing".

* Generate total variable.
compute numWomen = 1.
variable labels numWomen "Number of women age 15-24 years".

* Generate indicators.
recode LS14 (1 = 100) (else = 0) into improve.
variable labels improve "Improved during the last one year".

recode LS15 (1 = 100) (else = 0) into better1yr.
variable labels better1yr "Will get better after one year".

* in order to have a base who have at least answered on one question, we calculate sum * 0.
compute lifeiprv = sum(improve, better1yr) * 0.
if (improve = 100 and better1yr = 100) lifeiprv = 100.
variable labels lifeiprv "Both [1]".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women who think that their life".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

ctables
  /vlabels variables =  total layer
           display = none
  /table   total [c]
         + wage [c]
         + hh7 [c]
         + hh6 [c]
         + mstatus  [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]
     by
         layer [c] > ( 
           improve [s] [mean,'',f5.1]
         + better1yr [s] [mean,'',f5.1]
         + lifeiprv [s] [mean,'',f5.1] )
       + numWomen [s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
    "Table SW.3: Perception of a better life (women)"
    "Percentage of women age 15-24 years who think that their lives improved during the last one year and those who "+
    "expect that their lives will get better after one year, " + surveyname
   caption =
    "[1] MICS indicator 11.3 - Perception of a better life".

new file.
