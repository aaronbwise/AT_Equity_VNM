* MICS5 WS-04.

* v01 - 2014-03-03.

* Households without drinking water on premises: WS3=3

* Person usually collecting drinking water is obtained from WS5.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

compute nhhmem = 1.
variable labels  nhhmem "Number of households".
value labels nhhmem 1 "".

compute withoutWater = 0.
if (not(sysmis(WS5))) withoutWater = 100.
variable labels  withoutWater "Percentage of households without drinking water on premises".

do if (not(sysmis(WS5))).
+ compute nhhmemwithoutWater  = 1.
end if.

variable labels  WS5 "Person usually collecting drinking water".

variable labels  nhhmemwithoutWater "Number of households without drinking water on premises".
value labels nhhmemwithoutWater 1 "".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

ctables
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + helevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           withoutWater [s] [mean,'',f5.1]
         + nhhmem [s][sum,'',f5.0]
         + ws5 [c] [rowpct.validn,'',f5.1]
         + nhhmemwithoutWater[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=ws5 total=yes position= after label= "Total"
  /slabels position=column visible = no
  /titles title=
    "Table WS.4: Person collecting water"
      "Percentage of households without drinking water on premises, " +
      "and percent distribution of households without drinking water on premises "+
      "according to the person usually collecting drinking water used in the household, " + surveyname
  .

new file.
