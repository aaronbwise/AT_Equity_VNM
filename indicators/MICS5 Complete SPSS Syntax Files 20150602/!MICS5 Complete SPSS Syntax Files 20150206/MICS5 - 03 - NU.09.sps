* MICS5 NU-09.

* v02 - 2014-03-05.

* Bottle feeding: BD4=1 .

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

select if (cage <= 23).

* there is childAge6 that we could use? .
recode cage
  (low thru 5 = 1)
  (6 thru 11 = 2)
  (12 thru 23 = 3) into ageCat.
variable labels ageCat "Age".
value labels ageCat
  1 "0-5 months"
  2 "6-11 months"
  3 "12-23 months".

compute numChildren = 1.
variable labels numChildren "Number of children age 0-23 months:".
value labels numChildren 1"".

compute bottleFeeding = 0.
if (BD4 = 1) bottleFeeding = 100.
variable labels bottleFeeding "Percentage of children age 0-23 months fed with a bottle with a nipple [1]".

compute total = 1.
variable labels total  "Total".
value labels total 1 " ".


* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table   total [c]
         + hl4 [c]
         + ageCat [c]
         + hh7 [c]
         + hh6 [c]
         +  melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           bottleFeeding [s] [mean,'',f5.1]
         + numChildren [s] [count,'' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visable = no
  /titles title=
     "Table NU.9: Bottle feeding"
     "Percentage of children age 0-23 months who were fed with a bottle with a nipple during the previous day, " + surveyname
   caption=
     "[1] MICS indicator 2.18 - Bottle feeding".

new file.
