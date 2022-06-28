* Encoding: windows-1252.
***.
   
*v2.2019-03-14.
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

compute inHealthFacility = 0.
if any(deliveryPlace, 11, 12) inHealthFacility = 100.
variable labels inHealthFacility "Delivered in health facility [1]".

compute numWomen = 1.
variable labels numWomen "Number of women with a live birth in the last 2 years".
value labels numWomen 1 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

value labels noVisitsAux1
  0 "None"
  0.1 "1-3 visits"
  1 "4+ visits"
  2 "   8+ visits"
  9 "DK/Missing".

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $antvisits
           label = 'Number of antenatal care visits'
           variables =  noVisitsAux1 noVisitsAux2 .
		   
* Ctables command in English.
ctables
  /table   total [c]
         + hh6 [c]
         + hh7 [c]
         + welevel [c]         
         + ageAtBirth [c]
         + $antvisits [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]     
   by
  	       deliveryPlace [c] [rowpct.validn '' f5.1]
         + inHealthFacility [s] [mean '' f5.1]
         + numWomen[s] [count '' f5.0]
  /categories variables=all empty=exclude
  /categories variables=deliveryPlace empty=exclude total=yes label='Total'
  /slabels position=column visible=no
  /titles title=
      "Table TM.6.1: Place of delivery"
      "Percent distribution of women age 15-49 years with a live birth in the last 2 years by place of delivery of the most recent live birth, " + surveyname
   caption=
      "[1] MICS indicator TM.8 - Institutional deliveries"
  .

new file.
