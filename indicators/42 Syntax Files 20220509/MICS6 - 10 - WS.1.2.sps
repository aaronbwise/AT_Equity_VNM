* Encoding: UTF-8.
* MICS6 WS.1.2.

***.
* v01 - 2020-04-14. Sub-title has been edited. Labels in French and Spanish have been removed.
* v02 - 2020-07-10. Definition of water on premises updated, by removing code 13.

***.
* Households are considered to use improved sources of drinking water if WS1=11, 12, 13, 14, 21, 31, 41, 51, 61, 71, 72, 91, 92

* Water on premises: (WS1 or WS2=11, 12) or (WS3=1 or 2).

* Time to water source is based on responses to WS4. Note that "up to and including 30 mins" differs from previous MICS tabulation and is aligned with SDG definition for 
   basic drinking water services (no more than 30 mins roundtrip). Members do not collect should be treated as <=30 mins.

* Households are considered to use basic drinking water services if
if (drinkingwater =1 and time <=2) INDWS2=100.

* Denominators are obtained by weighting the number of households by the number of household members (HH48).
***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH46  = 1).

compute hhweightHH48 = HH48*hhweight.

weight by hhweightHH48.

compute nhhmem  = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 "".

recode WS4
  (0 = 2)
  (1 thru 30 = 2)
  (31 thru 990 = 3)
  (998, 999 = 9) into time.

* Water on premises.
if ( any(WS1, 11, 12) or
     any(WS2, 11, 12) or
     any(WS3, 1, 2) )        time = 1.

variable labels  time "Time to source of drinking water".
value labels time
    1 "Water on premises"
    2 "Up to and including 30 minutes [A]"
    3 "More than 30 minutes"
    9 "DK/Missing" .

* include definition of drinkingWater .
include "define/MICS6 - 10 - WS.sps" .

variable labels  drinkingWater "Time to source of drinking water".
value labels drinkingWater 1 "Users of improved drinking water sources" 2 "Users of unimproved drinking water sources".

compute	INDWS2=0.
if (drinkingwater =1 and time <=2) INDWS2=100.
variable labels INDWS2 "Percentage using basic drinking water services [1]".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels  total100 "Total".
value labels total100 100 " ".

* Ctables command in English.
ctables
  /vlabels variables = time
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + helevel [c]
         + ethnicity [c]
         + windex5 [c]
   by
           drinkingWater [c] >
             time[c][layerrowpct.validn '' f5.1]
         + total100 [s] [mean '' f5.1]
         + INDWS2 [s] [mean '' f5.1]
         + nhhmem [s] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.1.2: Use of basic and limited drinking water services"
    "Percent distribution of household population by time to go to source of drinking water, get water and return, " +
    "for users of improved and unimproved drinking water sources and percentage using basic drinking water services, " + surveyname
 caption=
    "[1] MICS indicator WS.2 - Use of basic drinking water services; SDG Indicator 1.4.1"
    "[A] Includes cases where household members do not collect".

new file.
