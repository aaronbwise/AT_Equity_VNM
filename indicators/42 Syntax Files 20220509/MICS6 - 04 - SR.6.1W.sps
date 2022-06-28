* Encoding: windows-1252.
* MICS6 SR.6.1W.

* v01 - 2017-09-22.
* v03 - 2020-04-09.  Labels in French and Spanish have been removed.

** Respondents are distributed according to the highest level of school attended (WB6U) and further by the results of reading a short simple statement about everyday life (WB14).

** Those who attended secondary or higher education (WB6U=2, 3 or 4) are classified as literate, as they are assumed literate due to their education level and are therefore not asked to read the statement. 
** All others who successfully read the statement (WB14=3) are also classified as literate. 

** The percent missing includes those for whom no sentence in the required language was available (WB14=6) or for whom no response was reported. If exceeding 10 percent in any category, 
    caution should be exercised in the interpretation of the results. Additionally, a low response rate may be observed among certain age groups. Particularly, if the response rate of age group 15-24 years is below 95 percent, 
    the data obtained through the Education module should be examined. In some countries, low response rates for this age group is due to boarding at secondary or higher education, 
    in which case a large number of lost respondents would have been classified as literate had they been interviewed.


***.


include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

compute literate  = 2.
if (WB6A >= 2 and WB6A < 8) literate = 1. 
if (WB14 = 3) literate = 1.
variable labels literate " ".
value labels literate 1 "Literate" 2 "Illiterate".

compute literateP = 0.
if (literate = 1) literateP = 100. 
variable labels literateP "Total percentage literate [1]".

compute layer = 0.
variable labels layer " ".
value labels layer 0 "Percent distribution of highest level attended and literacy".

* add A to welevel label.
add value labels welevel 3 "Secondary or higher [A]".

compute numWomen = 1.
variable labels numWomen "Number of women".
value labels numWomen 1 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute tot = 100.
variable labels tot "Total".
value labels tot 100 " ".

* Ctables command in English.
ctables
  /vlabels variables = layer welevel literate display = none
  /table   total[c]
         + hh6 [c]
         + hh7 [c]
         + $age [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]
   by
           layer [c] > welevel [c] > literate [c] [layerrowpct.validn '' f5.1] + tot [s] [mean '' f5.1] +
           literateP [s] [mean '' f5.1]
         + numWomen[s][sum '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table SR.6.1W: Literacy (women)"
    "Percent distribution of women age 15-49 years by highest level of school attended and literacy, and the total percentage literate, " + surveyname
   caption =
    "[1] MICS indicator SR.2 - Literacy rate (age 15-24 years)"
    "[A] Respondents who have attended secondary school or higher are considered literate and are not tested."
  .  

new file.
