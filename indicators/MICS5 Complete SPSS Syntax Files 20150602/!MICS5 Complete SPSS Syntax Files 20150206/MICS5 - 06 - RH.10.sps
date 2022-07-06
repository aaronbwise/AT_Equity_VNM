* MICS5 RH-10.

* v02 - 2014-04-02.
* In the sub-title, “years” has been added after “age 15-49” and a typo corrected in the word “assistance”.
* In the comments, the spelling of “caesarian” has been harmonised.

* v03 - 2015-04-21.
*	A note a has been added on column “Delivery assisted by any skilled attendant”.



* Information on persons assisting delivery is collected in MN17.

* The response codes to MN17 need to be customized at the country level.
* Specifically, the "auxiliary midwife" will have been customised and replaced by the local term used in the country.
* Normally, skilled attendants will include doctors, midwives and nurses (MN17=A, B).
* The locally adapted category equivalent to auxiliary midwife may or may not be considered skilled personnel.

* Births delivered by caesarean section are captured in MN19.
* An additional question is asked to those who had a caeserian section (MN19=1) to establish whether the decision taken to perform
  a caeserian section was taken before (MN19A=1) or after (MN19A=2) the onset of labour pains.

***.

include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

* select women that gave birth in two years preceeding the survey.
select if (CM13 = "Y" or CM13 = "O" or CM13 = "S").

* definitions of anc, ageAtBirth .
include 'define\MICS5 - 06 - RH.sps' .

compute personAtDelivery = 0.
if (MN17A = "A") personAtDelivery = 11.
if (personAtDelivery = 0 and MN17B = "B") personAtDelivery = 12.
if (personAtDelivery = 0 and MN17C = "C") personAtDelivery = 13.
if (personAtDelivery = 0 and MN17F = "F") personAtDelivery = 14.
if (personAtDelivery = 0 and MN17G = "G") personAtDelivery = 15.
if (personAtDelivery = 0 and MN17H = "H") personAtDelivery = 16.
if (personAtDelivery = 0 and (MN17X = "X" or MN17A = "?")) personAtDelivery = 97.
if (personAtDelivery = 0 and MN17Y = "Y") personAtDelivery = 98.
variable labels personAtDelivery "Person assisting at delivery".
value labels personAtDelivery
  11 "Medical doctor"
  12 "Nurse / Midwife"
  13 "Auxiliary midwife"
  14 "Traditional birth attendant"
  15 "Community health worker"
  16 "Relative / Friend"
  97 "Other/missing"
  98 "No attendant".


compute skilledAttendant = 0.
if any(personAtDelivery, 11, 12) skilledAttendant = 100.
variable labels skilledAttendant "Delivery assisted by any skilled attendant [1][a]".

recode MN19A (1=100) (else=0) into cBefore .
recode MN19A (2=100) (else=0) into cAfter .
recode MN19A (1,2=100) (else=0) into cTotal .
variable labels 
   cBefore "Decided before onset of labour pains"
  /cAfter "Decided after onset of labour pains"
  /cTotal "Total [2]" .

compute cLayer = 0.
value labels cLayer 0 "Percent delivered by C-section" .

compute numWomen = 1.
variable labels numWomen "Number of women who had a live birth in the last two years".
value labels numWomen 1 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels total100 "Total".
value labels total100 100 " ".


* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = cLayer display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]     
   by
           personAtDelivery [c] [rowpct.validn,'',f5.1]
         + total100 [s] [mean,'',f5.1]
         + skilledAttendant [s] [mean,'',f5.1] 
         + cLayer [c] > (cBefore [s] [mean,'',f5.1]  + cAfter [s] [mean,'',f5.1]  + cTotal [s] [mean,'',f5.1] )
         + numWomen [s] [count,'',f5.0]
  /categories var=all empty=exclude
  /slabels position=column visible=no
  /title title=
      "Table RH.10: Assistance during delivery and caesarian section"
      "Percent distribution of women age 15-49 years with a live birth in the last two years by person "
      "providing assistance at delivery, and percentage of births delivered by C-section, " + surveyname
   caption=
      "[1] MICS indicator 5.7; MDG indicator 5.2 - Skilled attendant at delivery"
      "[2] MICS indicator 5.9 - Caesarean section"
      "[a] Skilled attendants include Medical doctor and Nurse/Midwife."
  .

new file.

