* Encoding: UTF-8.
* v01 - 2013-03-19.
* v02 - 2019-03-14.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

* For definitions of health checks and PNC visits within 2 days of birth, see Tables RH.12 and RH.14
* In cases when either the newborn's or the mother's receipt of post-natal health checks cannot be established,
  the case is treated as a DK/Missing case  .

***.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

*select women that gave birth in two years preceeding the survey.
select if (CM17 = 1).

* definitions of anc, ageAtBirth .
include 'define\MICS6 - 06 - TM.sps' .

compute pncNewborn = 0.
if ((PN4 = 1 or PN8 = 1)) or ((pncVisitC = 1 or pncVisitC = 2 or pncVisitC = 3)) pncNewborn = 100.
variable labels pncNewborn "Post-natal health check for the newborn".

compute pncMother = 0.
if ((PN5 = 1 or PN9 = 1)) or ((pncVisitM = 1 or pncVisitM = 2 or pncVisitM = 3)) pncMother = 100.
variable labels pncMother "Post-natal health check for the mother".

compute both = 4.
if (pncMother =  100 and pncNewborn =  100) both = 3.
if (pncMother =  100 and pncNewborn <> 100) both = 2.
if (pncMother <> 100 and pncNewborn =  100) both = 1.
if (pncVisitM = 9 and pncVisitC = 9) both = 9.
variable labels both "Percentage of post-natal health checks within two days of birth for:".
value labels both
  1 "Only newborns"
  2 "Only mothers"
  3 "Both mothers and newborns"
  4 "Neither mother nor newborn"
  9 "Missing" .

compute bothAux = both.
if (pncNewborn =  100) bothAux1 = 1.
if (pncMother =  100) bothAux2 = 2.
value labels bothAux
  1 "Newborns [1]"
  2 "Mothers [2]"
  3 "Both mothers and newborns"
  4 "Neither mother nor newborn"
  9 "Missing" .

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $both
           label = 'Percentage of post-natal health checks within two days of birth for:'
           variables = bothAux bothAux1 bothAux2.

compute numWomen = 1.
variable labels numWomen "Number of women with a live birth in the last 2 years".
value labels numWomen 1 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels bh3_last "Sex of newborn".

* Ctables command in English.
ctables
  /table   total [c]
         + bh3_last [c]
         + hh6 [c]
         + hh7 [c]
         + welevel [c]
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + deliveryType [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]    
   by
           $both [c] [rowpct.validn '' f5.1]
         + numWomen[s] [count '' f5.0]
  /categories variables=all empty=exclude
  /slabels position=column visible=no
  /titles title=
     "Table TM.8.9: Post-natal health checks for mothers and newborns"
     "Percentage of women age 15-49 years with a live birth in the last 2 years by post-natal health checks for the mother and newborn, within 2 days of the most recent live birth, " + surveyname
   caption = 
       "[1] MICS indicator TM.13 - Post-natal health check for the newborn"			
       "[2] MICS indicator TM.20 - Post-natal health check for the mother".

new file.
