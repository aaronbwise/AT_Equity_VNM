* Encoding: UTF-8.
* MICS6 WS.1.5.

***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
* v03 - 2020.03.03. "Definition of number of household members unable to access water in sufficient quantities when needed" have been changed. 

***.
 * Household members with a water source that is available when needed: WS7=2. 
 * Number of household members unable to access water in sufficient quantities when needed: WS7=1
 * Main reason that the household members are unable to access water in sufficient quantities: WS8
 * Denominators are obtained by weighting the number of households by the total number of household members (HH48).
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

* include definition of drinkingWater .
include "define/MICS6 - 10 - WS.sps" .

variable labels drinkingWater "Source of drinking water".
add value labels drinkingWater 1 "Improved" 2 "Unimproved".

compute sufficentwater=0.
if WS7= 2 sufficentwater=100.
variable labels sufficentwater "Percentage of household population with drinking water available in sufficient quantities [1]".

compute nmemnotsufficent=$sysmis. 
if WS7=1 nmemnotsufficent=1.
variable labels nmemnotsufficent "Number of household members unable to access water in sufficient quantities when needed".

recode WS8 (8=9) (else = copy).
add value labels WS8 9 "DK/Missing".

variable labels WS8 "Main reason that the household members are unable to access water in sufficient quantities".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels  total100 "Total".
value labels total100 100 " ".

* Ctables command in English.
ctables
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + helevel [c]
         + drinkingWater [c]
         + ethnicity [c]
         + windex5 [c]
   by
           sufficentwater [s] [mean '' f5.1]
         + nhhmem [s][sum '' f5.0]
         + WS8 [c] [rowpct.validn '' f5.1]
         + nmemnotsufficent[s][sum '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=WS8 total=yes position= after label= "Total"
  /slabels position=column visible = no
  /titles title=
    "Table WS.1.5: Availability of sufficient drinking water when needed"
    "Percentage of household members with drinking water available when needed and percent distribution of the main reasons " +
    "household members unable to access water in sufficient quantities when needed, " + surveyname
 caption=
    "[1] MICS indicator WS.3 - Availability of drinking water".
	
new file.
