* MICS5 HA-05.

* v01 - 2014-03-17.
* v02 - 2014-04-22.
*The following comment: “Women who received HIV counselling includes those who were given information about
* (a) babies getting AIDS virus from their mothers,
* (b) things that can be done to prevent getting the AIDS virus, 
* and (c) getting tested for the AIDS virus. 
* All three should be "Yes": HA15[A]=1 and HA15[B]=1 and HA15[C]=1.” 
* has been changed to “Women who received HIV counselling includes those who were given information about 
(a) mother-to-child transmission of HIV, (b) things that can be done to prevent contracting HIV, and (c) getting tested for HIV.”

* Women who received antenatal care from a health care professional during the last pregnancy (MN2=’A’ or MN2=’B’ or MN2=’C’).

* Women who received HIV counselling includes those who were given infornation about 
    (a) babies getting AIDS virus from their mothers, 
    (b) things that can be done to prevent getting the AIDS virus, and 
    (c) getting tested for the AIDS virus. 
* All three should be ""Yes"": HA15[A]=1 and HA15[B]=1 and HA15[C]=1.

* Women who were offered a test (HA15[D]=1), were tested (HA16=1), and received the results (HA17=1) during antenatal care form the numerator 
  of MICS indicator 9_8.

* The last result column combines the two MICS indicators of receipt of HIV counseling and testing coverage.

* The denominator of the table includes all women, including those who have not heard of AIDS (HA1=2) .


***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM13 = "Y" or CM13 = "O").


* Women who received antenatal care during the last pregnancy.
compute receivedAntenatal = 0.
if (MN2A = "A" or MN2B = "B" or MN2C = "C") receivedAntenatal = 100.
variable labels receivedAntenatal "Received antenatal care from a health care professional for last pregnancy".

* Women who received HIV counselling .
compute hivCounselling = 0.
if (HA15A = 1 and HA15B = 1 and HA15C = 1) hivCounselling = 100.
variable labels hivCounselling "Received HIV counselling during antenatal care [1]".

* Women who were offered a test (HA15D=1) and were tested (HA16=1), .
* and received the results (HA17=1) during antenatal care form the numerator of MICS indicator 9.9.
compute hivTest = 0.
if (HA15D = 1 and HA16 = 1) hivTest = 100.
variable labels hivTest "Were offered an HIV test and were tested for HIV during antenatal care".

compute hivResult = 0.
if (hivTest = 100 and HA17 = 1) hivResult = 100.
variable labels hivResult "Were offered an HIV test and were tested for HIV during antenatal care, and received the results [2]".

* Combine receipt of HIV counseling and testing coverage.
compute allFour = 0.
if (hivCounselling = 100 and hivResult = 100) allFour = 100.
variable labels allFour "Received HIV counselling, were offered an HIV test, accepted and received the results".

recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status".
add value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode wage (1 = 2) (2 = 3) into wageAux2 .

recode wage (1, 2 = 1) (3 = 4) (4, 5 = 5) (6, 7 = 6) into wageAux1 .
variable labels wageAux1 "Age".
value labels wageAux1
 1 "15-24"
 2 "    15-19"
 3 "    20-24"
 4 "25-29"
 5 "30-39"
 6 "40-49" .

mrsets
  /mcgroup name=$wage
   label='Age'
   variables=wageAux1 wageAux2 .

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women who:".

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women age 15-49 with a live birth in the last 2 years".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = numWomen total layer 
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + $wage [c]
         + mstatus [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           layer [c]  > (
             receivedAntenatal [s] [mean,'',f5.1]
           + hivCounselling [s] [mean,'',f5.1]
           + hivTest [s] [mean,'',f5.1]
           + hivResult [s] [mean,'',f5.1]
           + allFour [s] [mean,'',f5.1] )
         + numWomen[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /title title=
    "Table HA.5: HIV counselling and testing during antenatal care"
    "Percentage of women age 15-49 with a live birth in the last 2 years who received antenatal care from a health professional during the " +
    "last pregnancy, percentage who received HIV counselling, percentage who were offered and tested for HIV, percentage who were offered, tested " +
    "and received the results of the HIV test, and percentage who received counselling and were offered, accepted and received the results " +
    "of the HIV test, " + surveyname
   caption = 
    "[1] MICS indicator 9.7 - HIV counselling during antenatal care"
    "[2] MICS indicator 9.8 - HIV testing during antenatal care"
  .

new file.
