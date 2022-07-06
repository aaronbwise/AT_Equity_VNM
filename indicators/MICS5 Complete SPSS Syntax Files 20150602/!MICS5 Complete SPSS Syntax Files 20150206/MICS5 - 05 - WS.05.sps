* MICS5 WS-05.

* v01 - 2014-03-03.

* Improved sanitation facilities are:
    WS8=11, 12, 13, 15, 21, 22, and 31.

* Denominators are obtained by weighting the number of households by the number of household members (HH11).

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweightHH11 = HH11* hhweight.

weight by hhweightHH11.

compute nhhmem = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 " ".

* include definition of drinkingWater .
include "define/MICS5 - 05 - WS.sps" .

recode WS8 (97,98, 99 = 99) .
variable labels  WS8 "".
add value labels WS8 
	95 " " 
	99 "Missing/DK".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels  total100 "Total".
value labels total100 100 " ".


* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = ws8
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + helevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           toiletType [c] >
             ws8 [c] [layerrowpct.validn,'',f5.1]
         + total100 [s] [mean,'',f5.1]
         + nhhmem [s] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.5: Types of sanitation facilities"
    "Percent distribution of household population according to type of toilet facility used by the household, " + surveyname
  .

new file.
