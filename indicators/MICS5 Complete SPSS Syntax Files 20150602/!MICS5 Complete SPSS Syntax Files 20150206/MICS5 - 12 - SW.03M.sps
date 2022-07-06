* MICS5 SW-03M.

* v01 - 2013-06-22.

* Men who think that their life has improved during the last one year:
     MLS14=1.

* Men who expect that their life will get better after one year:
     MLS15=1.

* Men who think their life has been improving and will continue to improve:
     (MLS14=1 and MLS15=1).

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open men dataset.
get file = 'mn.sav'.

* Select completed interviews.
select if (MWM7 = 1).

* Select men aged 15-24.
select if (mwage  = 1 or mwage  = 2).

* Weight the data by the men weight.
weight by mnweight.

* Create marital status with separate groups for ever married married.
recode mmstatus  (1, 2 = 1) (3 = 2) (else = 9).
variable labels mmstatus  "Marital status".
value labels mmstatus 
   1 "Ever married/in union"
   2 "Never married/in union"
   9 "Missing".

* Generate total variable.
compute numMen = 1 .
variable labels numMen "Number of men age 15-24 years" .

* Generate indicators.
recode MLS14 (1 = 100) (else = 0) into improve.
variable labels improve "Improved during the last one year".

recode MLS15 (1 = 100) (else = 0) into better1yr.
variable labels better1yr "Will get better after one year".

* in order to have a base who have at least answered on one question, we calculate sum * 0.
compute lifeiprv = sum(improve, better1yr) * 0.
if (improve = 100 and better1yr = 100) lifeiprv = 100.
variable labels lifeiprv "Both [1]".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of men who think that their life".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

ctables
  /vlabels variables =  total layer
           display = none
  /table   total [c]
         + mwage  [c]
         + hh7 [c]
         + hh6 [c]
         + mmstatus  [c]
         + mwelevel [c]
         + windex5 [c]
         + ethnicity [c]
     by
           layer [c] > (
             improve [s] [mean,'',f5.1]
           + better1yr [s] [mean,'',f5.1]
           + lifeiprv [s] [mean,'',f5.1] )
         + numMen [s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
    "Table SW.3M: Perception of a better life (men)"
    "Percentage of men age 15-24 years who think that their lives improved during the last one year and those who "+
    "expect that their lives will get better after one year, " + surveyname
   caption =
    "[1] MICS indicator 11.3 - Perception of a better life [M]".

new file.
