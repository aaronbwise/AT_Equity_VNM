* MICS5 WS-03.

* v01 - 2014-03-03.

* Users of improved water sources are
    WS1=11, 12, 13, 14, 21, 31, 41, 51
    or (WS1=91 and WS2=11, 12, 13, 14, 21, 31, 41, 51) .
* Users of unimproved sources of drinking water are
    WS1=32, 42, 61, 71, 81, 96
    or (WS1=91 and WS2=32, 42, 61, 71, 81, 96).

* Water on premises:
    (WS1 or WS2=11, 12, or 13) or (WS3=1 or 2).

* Time to water source is based on responses to WS4.

* Denominators are obtained by weighting the number of households by the number of household members (HH11).

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweightHH11 = HH11*hhweight.

weight by hhweightHH11.

compute nhhmem  = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 "".

recode WS4
  (0 thru 29 = 2)
  (30 thru 990 = 3)
  (998, 999 = 9) into time.

* Water on premises.
if ( any(WS1, 11, 12, 13) or
     any(WS2, 11, 12, 13) or
     any(WS3, 1, 2) )        time = 1.

variable labels  time "Time to source of drinking water".
value labels time
    1 "Water on premises"
    2 "Less than 30 minutes"
    3 "30 minutes or more"
    9 "Missing/DK" .

* include definition of drinkingWater .
include "define/MICS5 - 05 - WS.sps" .

variable labels  drinkingWater "Time to source of drinking water".
value labels drinkingWater 1 "Users of improved drinking water sources" 2 "Users of unimproved drinking water sources".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels  total100 "Total".
value labels total100 100 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = time
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6[c]
         + helevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           drinkingWater [c] >
             time[c][layerrowpct.validn,'',f5.1]
         + total100 [s] [mean,'',f5.1]
         + nhhmem [s] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.3: Time to source of drinking water "
    "Percent distribution of household population according to time to go to source of drinking water, " +
    "get water and return, for users of improved and unimproved drinking water sources, " + surveyname
  .

new file.
