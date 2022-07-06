* MICS5 RH-17.

* v01 - 2013-03-19.

* For definitions of health checks and PNC visits within 2 days of birth, see Tables RH.12 and RH.14
* In cases when either the newborn's or the mother's receipt of post-natal health checks cannot be established,
  the case is treated as a DK/Missing case  .

***.

include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

* select women that gave birth in two years preceeding the survey.
select if (CM13 = "Y" or CM13 = "O" or CM13 = "S").

* definitions of anc, ageAtBirth .
include 'define\MICS5 - 06 - RH.sps' .



compute pncNewborn = 0.
if ((PN3 = 1 or PN7 = 1)) or ((pncVisitC = 1 or pncVisitC = 2 or pncVisitC = 3)) pncNewborn = 100.
variable labels pncNewborn "Post-natal health check for the newborn".

compute pncMother = 0.
if ((PN4 = 1 or PN8 = 1)) or ((pncVisitM = 1 or pncVisitM = 2 or pncVisitM = 3)) pncMother = 100.
variable labels pncMother "Post-natal health check for the mother".

compute both = 4.
if (pncMother =  100 and pncNewborn =  100) both = 1.
if (pncMother =  100 and pncNewborn <> 100) both = 2.
if (pncMother <> 100 and pncNewborn =  100) both = 3.
if (pncVisitM = 9 and pncVisitC = 9) both = 9.
variable labels both "Health checks or PNC visits within 2 days of birth for:".
value labels both
  1 "Both mothers and newborns"
  2 "Mothers only"
  3 "Newborns only"
  4 "Neither mother  nor newborn"
  9 "Missing" .

compute numWomen = 1.
variable labels numWomen "Number of women age 15-49 years who gave birth in the 2 years preceding the survey".
value labels numWomen 1 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + deliveryType [c]
         + welevel [c]
         + windex5 [c]
          + ethnicity [c]      
   by
           both [c] [rowpct.validn,'',f5.1]
         + numWomen[s] [count,'',f5.0]
  /categories variables=all empty=exclude
  /categories variables=both total = yes position=after label="Total"
  /slabels position=column visible=no
  /title title=
     "Table RH.17: Post-natal health checks for mothers and newborns"
     "Percent distribution of women age 15-49 years with a live birth in the last two years by post-natal health checks for the mother and newborn, " +
     "within two days of the most recent birth, " + surveyname
  .

new file.
