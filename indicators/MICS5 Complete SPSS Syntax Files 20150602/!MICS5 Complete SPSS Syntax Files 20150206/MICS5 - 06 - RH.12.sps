* MICS5 RH-12.

* v01 - 2014-03-19.

* Women who delivered in a health facility: MN18=21-26 (Public) or 31-36 (Private).
* Duration of stay is calculated from question PN2.
* The following approach is adopted in case of unknown/missing information:
    If PN2A (Unit) = 1 and PN2B (Number) = 99 then duration of stay in health facility = 12-23 hours
    If PN2A (Unit) = 2 or 3 and PN2B (Number) = 99 then duration of stay in health facility = 3 days or more .

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

* select women that gave birth in two years preceeding the survey.
select if (CM13 = "Y" or CM13 = "O").

* definitions of anc, ageAtBirth .
include 'define\MICS5 - 06 - RH.sps' .

* select women that gave birth in a health facility.
select if (any(deliveryPlace, 11, 12)).

compute numWomen = 1.
variable labels numWomen "Number of women who had their last birth delivered in a health facility in the last 2 years".
value labels numWomen 1 "".

recode deliveryPlace (11,12 = copy) (else = 99) into deliveryPlace2.
variable labels deliveryPlace2 "Type of health facility".
value labels deliveryPlace2
  11 "Public"
  12 "Private"
  99 "Other/DK/Missing".

compute stayDuration = 9.
if (PN2U = 1 and PN2N < 6) stayDuration = 1.
if (PN2U = 1 and PN2N >= 6 and PN2N <= 11) stayDuration = 2.
if (PN2U = 1 and PN2N >= 12 and PN2N < 98) stayDuration = 3.
if (PN2U = 2 and (PN2N = 1 or PN2N = 2)) stayDuration = 4.
if (PN2U = 2 and PN2N >= 3 and PN2N < 98) stayDuration = 5.
if (PN2U >= 3 and PN2U < 9) stayDuration = 5.
variable labels stayDuration "Duration of stay in health facility:".
value labels stayDuration
  1 "Less than 6 hours"
  2 "6-11 hours"
  3 "12-23 hours"
  4 "1-2 days"
  5 "3 days or more"
  9 "Missing/DK".

compute more12 = 0.
if any(stayDuration, 3, 4, 5) more12 = 100.
variable labels more12 "12 hours or more [1]".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

ctables
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + ageAtBirth [c]
         + deliveryPlace2 [c]
         + deliveryType [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]       
   by
  	       stayDuration [c] [rowpct.validn,'',f5.1]
                       + more12 [s] [mean,'',f5.1] 
  	     + numWomen[s] [count,'',f5.0]
  /categories var=all empty=exclude
  /categories var=stayDuration total=yes label='Total'
  /slabels position=column visible=no
  /title title=
     "Table RH.12: Post-partum stay in health facility"
     "Percent distribution of women age 15-49 years with a live birth in the last two years who had their last birth delivered in a health facility by duration of stay in health facility, " + surveyname
  caption=
     "[1] MICS indicator 5.10 - Post-partum stay in health facility"
  .

new file.
