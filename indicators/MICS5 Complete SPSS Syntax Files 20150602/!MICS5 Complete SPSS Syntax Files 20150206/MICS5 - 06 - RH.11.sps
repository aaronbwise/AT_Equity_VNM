* MICS5 RH-11.

* v02 - 2014-04-03.
* In the sub-title, “years” has been added after “age 15-49”.

* Information on places of delivery are collected in MN18.
* Public sector health facilities: MN18=21-26,
  private sector health facilities: MN18=31-36 .

***.
   

include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

*select women that gave birth in two years preceeding the survey.
select if (CM13 = "Y" or CM13 = "O" or CM13 = "S").

* definitions of anc, ageAtBirth .
include 'define\MICS5 - 06 - RH.sps' .

compute inHealthFacility = 0.
if any(deliveryPlace, 11, 12) inHealthFacility = 100.
variable labels inHealthFacility "Delivered in health facility [1]".

compute numWomen = 1.
variable labels numWomen "Number of women with a live birth in the last two years".
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
         + noVisits[c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]     
   by
  	       deliveryPlace [c] [rowpct.validn,'',f5.1]
         + inHealthFacility [s] [mean,'',f5.1]
         + numWomen[s] [count,'',f5.0]
  /categories var=all empty=exclude
  /categories var=deliveryPlace empty=exclude total=yes label='Total'
  /slabels position=column visible=no
  /title title=
    "Table RH.11: Place of delivery"
    "Percent distribution of women age 15-49 years with a live birth in the last two years by place of delivery of their last birth, " + surveyname
  caption=
    "[1] MICS indicator 5.8 - Institutional deliveries"
  .

new file.
