* Encoding: UTF-8.

***.
* v02 - 2020-04-14.  Sub-title has been edited. Labels in French and Spanish have been removed.
* v03 - 2020-07-10. Definition of water on premises updated, by removing code 13.
* v04 - 2021-03-03. Definition of households without drinking water on premises changed to: (WS1=61, 71 or 72) or (WS2=61, 71 or 72) or WS3=3

***.
* Households without drinking water on premises: (WS1=61, 71 or 72) or (WS2=61, 71 or 72) or WS3=3.
* Person usually collecting drinking water is obtained from WS5 by matching the line number of the person from the List of Household Members module in the Household Questionnaire.

* Denominators are obtained by weighting the number of households by the total number of household members (HH48).

***.

get file = 'hl.sav'.

* Sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 HL1.

compute personcwater=9.
if (HL4=2 and HL6>=15 and HL6<=95) personcwater=1.
if (HL4=1 and HL6>=15 and HL6<=95) personcwater=2.
if (HL4=2 and HL6<=14) personcwater=3.
if (HL4=1 and HL6<=14) personcwater=4.
variable labels  personcwater "Person usually collecting drinking water".
value labels personcwater 1 "Woman (15+)" 2 "Man (15+)" 3 "Female child under age 15" 4 "Male child under age 15" 9 "DK/Missing/Members do not collect".

* Save data file of person collecting water as only variables.
save outfile = 'tmppersoncwater.sav'
  /keep HH1 HH2 HL1 personcwater
  /rename HL1 = WS5.

new file.

get file = 'hh.sav'.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

sort cases by HH1 HH2.

* Merge the person collecting the water with the household file. 
match files
  /file = *
  /table = 'tmppersoncwater.sav'
  /by HH1 HH2 WS5.

if WS4=0 personcwater=9.
if WS5=0 or WS5>90 personcwater=9.
select if (HH46  = 1).

compute hhweightHH48 = HH48*hhweight.

weight by hhweightHH48.

compute nhhmem = 1.
variable labels  nhhmem "Number of household members".
value labels nhhmem 1 "".

* Water not on premises.
compute withoutWater = 0.
if (any(WS1, 61, 71, 72) or any (WS2, 61, 71, 72) or (WS3=3)) withoutWater=100.
variable labels  withoutWater "Percentage of household members without drinking water on premises".

if withoutWater=100 nhhmemwithoutWater=1.

variable labels  nhhmemwithoutWater "Number of household members without drinking water on premises".
value labels nhhmemwithoutWater 1 "".

* include definition of drinkingWater .
include "define/MICS6 - 10 - WS.sps" .

variable labels drinkingWater "Source of drinking water".
value labels drinkingWater 1 "Improved" 2 "Unimproved".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

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
           withoutWater [s] [mean '' f5.1]
         + nhhmem [s][sum '' f5.0]
         + personcwater [c] [rowpct.validn '' f5.1]
         + nhhmemwithoutWater[s][sum '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=personcwater total=yes position= after label= "Total"
  /slabels position=column visible = no
  /titles title=
    "Table WS.1.3: Person collecting water"
    "Percentage of household members without drinking water on premises, and percent distribution of household members " +
    "without drinking water on premises by person usually collecting drinking water used in the household, " + surveyname
  .

new file.

erase file = 'tmppersoncwater.sav'.
