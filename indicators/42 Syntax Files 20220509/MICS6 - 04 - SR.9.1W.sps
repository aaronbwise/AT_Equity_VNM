* Encoding: windows-1252.
* MICS6 SR.9.1W.

* v01 - 2017-09-22.
* v02 - 2019-03-14.
* v03 - 2020-04-09. Labels in French and Spanish have been removed.

** Women who are exposed to all three media at least once a week are:
(MT1=1 or 2) and (MT2=1 or 2) and (MT3=1 or 2).

** Women exposed to any media at least once a week are: (MT1=1 or 2) or (MT2=1 or 2) or (MT3=1 or 2).

** Note that the percentages in the table do not add to 100.


***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open women dataset.
get file = 'wm.sav'.

include "CommonVarsWM.sps".

* Select completed interviews.
select if (WM17 = 1).

* Weight the data by the women weight.
weight by wmweight.

* Generate numWomen variable.
compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women".

* Generate indicators.
recode MT1 (2,3 = 100) (else = 0) into read1w.
variable labels read1w "Read a newspaper at least once a week".

recode MT2 (2,3 = 100) (else = 0) into listen1w.
variable labels listen1w "Listen to the radio at least once a week".

recode MT3 (2,3 = 100) (else = 0) into watch1w.
variable labels watch1w "Watch television at least once a week".

* Women who are exposed to all three media at least once a week are:.
* (MT1=1 or 2) and (MT2=1 or 2) and (MT3=1 or 2).
compute three = 0.
if (read1w = 100 and listen1w = 100 and watch1w = 100) three = 100.
variable labels three "All three media at least once a week [1]".

* Women exposed to any media at least once a week are: (MT1=1 or 2) or (MT2=1 or 2) or (MT3=1 or 2).
compute any1w = 0.
if (read1w = 100 or listen1w = 100 or watch1w = 100) any1w = 100.
variable labels any1w "Any media at least once a week".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of women who:".

compute total = 1.
variable labels total "".
value labels total 1 "Total".
 
* Ctables command in English.
ctables
  /vlabels variables =  numWomen layer0 total
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
          layer0 [c] > ( read1w [s] [mean '' f5.1]
                       + listen1w [s] [mean '' f5.1]
                       + watch1w [s] [mean '' f5.1])
        + three[s] [mean '' f5.1]
        + any1w[s] [mean '' f5.1]
        + numWomen[c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table SR.9.1W: Exposure to mass media (women)"
     "Percentage of women age 15-49 years who are exposed to specific mass media on a weekly basis, " + surveyname
   caption =
     "[1] MICS indicator SR.3 - Exposure to mass media".

new file.
