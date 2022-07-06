* MICS5 WS-01.

* v01 - 2014-03-2014.

* Households are considered to use improved sources of drinking water 
  if WS1=11, 12, 13, 14, 21, 31, 41, 51 
  or (WS1=91 and WS2=11, 12, 13, 14, 21, 31, 41, 51) 
  
* Households using bottled water as the main source of drinking water (WS1) are classified into improved or unimproved drinking water users 
  according to the water source used for other purposes such as cooking and handwashing (WS2).

* Denominators are obtained by weighting the number of households by the nhhmem number of household members (HH11). 

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweightHH11 = HH11*hhweight.

weight by hhweightHH11.

compute nhhmem = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 " ".

* Recode DK and missing to one combined category.
recode WS1 (98,99 = 99) .

* addin [a] to the bottled water label .
add value labels WS1
  91 "Bottled water [a]" .

* include definition of drinking water sources: both improved and unimproved .
include "define/MICS5 - 05 - WS.sps" .

recode drinkingWater (1 = 100) (else = 0) into improvedWater.
variable labels improvedWater "Percentage using improved sources of drinking water [1]".
variable labels  WS1 "".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels  total100 "Total".
value labels total100 100 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = ws1
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + helevel [c]
         + windex5 [c]
         + ethnicity [c]
   by 
           drinkingWater [c] > 
             ws1 [c] [layerrowpct.validn,' ',f5.1]
         + total100 [s] [mean,'',f5.1] 
         + improvedWater [s] [mean,'',f5.1] 
         + nhhmem [s] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
    "Table WS.1: Use of improved water sources"
    "Percent distribution of household population according to main source of drinking water " +
    "and percentage of household population using improved drinking water sources, " + surveyname
 caption=
    "[1] MICS indicator 4.1; MDG indicator 7.8 - Use of improved drinking water sources"
    "[a] Households using bottled water as the main source of drinking water are classified into " +
    "improved or unimproved drinking water users according to the water source used for other purposes such as cooking and handwashing.".
                            
new file.
