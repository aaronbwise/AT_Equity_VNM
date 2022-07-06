* MICS5 WS-07.

* v01 - 2014-03-18.

* For definitions, see Tables WS_1, WS_5, and WS_6.

* Denominators are obtained by weighting the number of households by the total number of household members (HH11) .


***.


include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweightHH11 = HH11*hhweight.

weight by hhweightHH11.

compute nhhmem  = 1.
value labels nhhmem 1 "".
variable labels nhhmem "Number of household members".

* include definition of drinkingWater .
include "define/MICS5 - 05 - WS.sps" .

* Water.
compute improvedLayer = 0.
value labels improvedLayer 0 "Improved drinking water [1] [a]".

compute improvedWater1 = 0.
if (any(WS1, 11, 12)) improvedWater1 = 100.
if (any(WS2, 11, 12) and WS1 = 91) improvedWater1 = 100.
variable labels improvedWater1 "Piped into dwelling, plot or yard".

compute improvedWater2 = 0.
if (drinkingWater=1 & improvedWater1=0) improvedWater2 = 100.
variable labels improvedWater2 "Other improved".

compute unimprovedWater = 0.
if (drinkingWater <> 1) unimprovedWater = 100.
variable labels unimprovedWater "Unimproved drinking water".

* Sanitation.
compute improvedSanitation = 0.
if (toiletType = 1 and sharedToilet = 0) improvedSanitation = 100.
variable labels improvedSanitation "Improved sanitation [2]".

do if (improvedSanitation <> 100).
+ compute unimprovedSanitation = 0.
+ if (toiletType = 1 and sharedToilet <> 0) unimprovedSanitation = 1.
+ if (toiletType = 2) unimprovedSanitation = 2.
+ if (toiletType = 3) unimprovedSanitation = 3.
end if.

variable labels unimprovedSanitation "Unimproved sanitation".
value labels unimprovedSanitation
 1 "Shared improved facilities"
 2 "Unimproved facilities"
 3 "Open defecation".

compute improvedWaterAndSanitation = 0.
if (unimprovedWater = 0 and improvedSanitation = 100) improvedWaterAndSanitation = 100.
variable labels improvedWaterAndSanitation "Improved drinking water sources and improved sanitation".

compute layer = 100.
variable labels layer "".
value labels layer 100 "Percentage of household population using:".

compute total = 100.
variable labels total "Total".
value labels total 100 " ".

ctables
 /vlabels variable = layer improvedLayer
          display = none
 /table   total [c]
        + hh7 [c]
        + hh6 [c]
        + helevel [c]
        + windex5 [c]
        + ethnicity [c]
  by
          layer[c] > (
          improvedLayer [c] > (
          improvedWater1 [s] [mean,'',f5.1]
          + improvedWater2 [s] [mean,'',f5.1] )
          + unimprovedWater [s] [mean,'',f5.1]
          + total [s] [mean,'',f5.1]
          + improvedSanitation [s] [mean,'',f5.1]
          + unimprovedSanitation [c] [rowpct.totaln,'',f5.1]
          + total [s] [mean,'',f5.1]
          + improvedWaterAndSanitation [s] [mean,'',f5.1] )
          + nhhmem [s] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.7: Drinking water and sanitation ladders"
    "Percentage of household population by drinking water and sanitation ladders, " + surveyname
   caption =
    "[1] MICS indicator 4.1; MDG indicator 7.8 - Use of improved drinking water sources"
    "[2] MICS indicator 4.3; MDG indicator 7.9 - Use of improved sanitation"
    "[a]  Those indicating bottled water as the main source of drinking water are distributed according to the water source used for other purposes such as cooking and handwashing."
  .

new file.
