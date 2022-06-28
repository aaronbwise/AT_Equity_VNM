* Encoding: windows-1252.
* MICS6 WS.1.1.

* v01 - 2014-03-2014.
* v02 - 2020-04-14. Sub-title has been edited. Labels in French and Spanish have been removed.

* Households are considered to use improved sources of drinking water 
  WS1=11, 12, 13, 14, 21, 31, 41, 51, 61, 71, 72, 91, 92.
  
* Denominators are obtained by weighting the number of households by the nhhmem number of household members (HH48). 

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH46  = 1).

compute hhweightHH48 = HH48*hhweight.

weight by hhweightHH48.

compute nhhmem = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 " ".

* adding water labels .
add value labels WS1
  61 "Tanker Truck" 
  71 "Cart with small tank" 
  91 "Bottled water [A]" 
  92 "Sachet water [A]" 
  99 "Missing" .

* include definition of drinking water sources: both improved and unimproved .
include "define/MICS6 - 10 - WS.sps" .

recode drinkingWater (1 = 100) (else = 0) into improvedWater.
variable labels improvedWater "Percentage using improved sources of drinking water [1]".
variable labels  WS1 "".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels  total100 "Total".
value labels total100 100 " ".

* Ctables command in English.
ctables
  /vlabels variables = WS1
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + helevel [c]
         + ethnicity [c]
         + windex5 [c]
   by 
           drinkingWater [c] > 
            ws1 [c] [layerrowpct.validn,' ',f5.1]
         + total100 [s] [mean '' f5.1] 
         + improvedWater [s] [mean '' f5.1] 
         + nhhmem [s] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
    "Table WS.1.1: Use of improved and unimproved water sources "
    "Percent distribution of household population by main source of drinking water and percentage of household population using improved drinking water sources, " + surveyname
 caption=
    "[1] MICS indicator WS.1 - Use of improved drinking water sources"
    "[A] Delivered and packaged water considered improved sources of drinking water based on new SDG definition.".
            
new file.
