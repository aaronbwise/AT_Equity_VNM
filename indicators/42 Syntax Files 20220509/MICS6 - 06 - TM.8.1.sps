* Encoding: windows-1252.
***.
*v02. 2019-03-14.
*v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

*select women that gave birth in two years preceeding the survey.
select if (CM17 = 1).

* definitions of anc, ageAtBirth .
include 'define\MICS6 - 06 - TM.sps' .

* select women that gave birth in a health facility.
select if (any(deliveryPlace, 11, 12)).

compute numWomen = 1.
variable labels numWomen "Number of women with a live birth in the last 2 years who delivered the most recent live birth in a health facility".
value labels numWomen 1 "".

recode deliveryPlace (11,12 = copy) (else = 99) into deliveryPlace2.
variable labels deliveryPlace2 "Type of health facility".
value labels deliveryPlace2
  11 "Public"
  12 "Private"
  99 "Other/DK/Missing".

compute stayDuration = 9.
if (PN3U = 1 and PN3N < 6) stayDuration = 1.
if (PN3U = 1 and PN3N >= 6 and PN3N <= 11) stayDuration = 2.
if (PN3U = 1 and PN3N >= 12 and PN3N < 98) stayDuration = 3.
if (PN3U = 2 and (PN3N = 1 or PN3N = 2)) stayDuration = 4.
if (PN3U = 2 and PN3N >= 3 and PN3N < 98) stayDuration = 5.
if (PN3U >= 3 and PN3U < 9) stayDuration = 5.
variable labels stayDuration "Duration of stay in health facility:".
value labels stayDuration
  1 "Less than 6 hours"
  2 "6-11 hours"
  3 "12-23 hours"
  4 "1-2 days"
  5 "3 days or more"
  9 "DK/Missing".

compute more12 = 0.
if any(stayDuration, 3, 4, 5) more12 = 100.
variable labels more12 "12 hours or more [1]".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

ctables
  /table   total [c]
         + hh6 [c]
         + hh7 [c]
         + welevel [c]         
         + ageAtBirth [c]
         + deliveryPlace2 [c]
         + deliveryType [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]         
   by
  	       stayDuration [c] [rowpct.validn '' f5.1]
                       + more12 [s] [mean '' f5.1] 
  	     + numWomen[s] [count '' f5.0]
  /categories variables=all empty=exclude
  /categories variables=stayDuration total=yes label='Total'
  /slabels position=column visible=no
  /titles title=
     "Table TM.8.1: Post-partum stay in health facility"
     "Percent distribution of women age 15-49 years with a live birth in the last 2 years and delivered the most recent live birth in a health facility by duration of stay in health facility, " + surveyname
  caption=
     "[1] MICS indicator TM.12 - Post-partum stay in health facility"
  .
  
new file.
