* MICS5 WS-02.

* v01 - 2014-03-03.

* Drinking water is considered appropriately treated if one the following methods of treatment is used:
    boiling; adding bleach or chlorine; using a water filter; or using solar disinfection (WS7=A, B, D, E).

* Note that responses may total to more than 100 percent since households may be using more than one treatment method.

* Denominators are obtained by weighting the number of households by the number of household members (HH11).

* Users of unimproved sources of drinking water are WS1=32, 42, 61, 71, 81, 96 or (WS1=91 and WS2=32, 42, 61, 71, 81, 96).

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweightHH11 = HH11 * hhweight.

weight by hhweightHH11.

* create variable that will provide title in final table.

compute treat = 1.
value labels treat 1  "Water treatment method used in the household".
variable labels  treat " ".

compute none = 0.
if (WS6 <> 1) none = 100.
variable labels  none "None".

compute boil = 0.
if (WS7A = "A") boil = 100.
variable labels  boil "Boil".

compute bleach = 0.
if (WS7B = "B") bleach = 100.
variable labels  bleach "Add bleach / chlorine".

compute cloth = 0.
if (WS7C = "C") cloth = 100.
variable labels  cloth "Strain through a cloth".

compute waterFilter = 0.
if (WS7D = "D") waterFilter = 100.
variable labels  waterFilter "Use water filter".

compute solar = 0.
if (WS7E = "E") solar = 100.
variable labels  solar "Solar disinfection".

compute stand = 0.
if (WS7F = "F") stand = 100.
variable labels  stand "Let it stand and settle".

compute other = 0.
if (WS7X = "X") other = 100.
variable labels  other "Other".

compute dk = 0.
if (WS7Z = "Z") dk = 100.
variable labels  dk "Don't know".

compute nhhmem = 1.
value labels nhhmem 1 "".
variable labels  nhhmem "Number of household members".

* include definition of drinkingWater .
include "define/MICS5 - 05 - WS.sps" .
value labels drinkingWater
  1 "Improved"
  2 "Unimproved".

do if (drinkingWater  = 2).
+ compute unimproved = 0.
* Appropriately treated if method is: 
* boiling; adding bleach or chlorine; using a water filter; or using solar disinfection (WS7=A, B, D, E).
+ if (boil = 100 or bleach = 100 or waterFilter = 100 or solar = 100) unimproved = 100.
+ compute unprovedTotal = 1.
end if.

variable labels unimproved "Percentage of household members in households " +
                           "using unimproved drinking water sources and using " +
                           "an appropriate water treatment method [1]".

value labels unprovedTotal  1 "".
variable labels  unprovedTotal "Number of household members in households using unimproved drinking water sources".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = treat display = none
  /table   total [c]
         + hh7 [c]
         + hh6[c]
         + drinkingWater [c]
         + helevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           treat [c] > (
             none[s][mean,'',f5.1]
           + boil[s][mean,'',f5.1]
           + bleach[s][mean,'',f5.1]
           + cloth[s][mean,'',f5.1]
           + waterFilter[s][mean,'',f5.1]
           + solar[s][mean,'',f5.1]
           + stand[s][mean,'',f5.1]
           + other[s][mean,'',f5.1]
           + dk[s][mean,'',f5.1] )
         + nhhmem[s][sum,'',f5.0]
         + unimproved[s][mean,'',f5.1]
         + unprovedTotal[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.2: Household water treatment"
    "Percentage of household population by drinking water treatment method used in the household, " +
    "and for household members living in households where an unimproved drinking water source is used, " +
    "the percentage who are using an appropriate treatment method, " + surveyname
   caption =
    "[1] MICS indicator 4.2 - Water treatment"
    "na: not applicable"
  .

new file.
