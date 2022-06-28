* Encoding: UTF-8.
***.
* v02. 2019-03-14.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

*select women that gave birth in two years preceeding the survey.
select if (CM17 = 1).

* definitions of anc, ageAtBirth .
include 'define\MICS6 - 06 - TM.sps' .

compute pncProvider = 0.
if (PN23A = "A" or PN23B = "B" ) pncProvider = 11.
if (pncProvider = 0 and PN23C = "C") pncProvider = 12.
if (pncProvider = 0 and PN23G = "G") pncProvider = 13.
if (pncProvider = 0 and PN23F = "F") pncProvider = 14.
if (pncProvider = 0 and (PN23H = "H" or PN23X = "X" or PN23A = "?" )) pncProvider = 96.
variable labels pncProvider "Provider of first PNC visit".
value labels pncProvider
  11 "Doctor/ nurse/ midwife"
  12 "Other qualified"  
  13 "Community / village health worker"
  14 "Traditional birth attendant"
  96 "Other/Missing" .

* select mothers who received a PNC visit within one week of birth: PN22A/B=100 through 199, 201 through 299 AND PN23=A through G.
select if (pncVisitM < 5 and pncProvider <= 14) .

compute numWomen = 1 .
variable labels numWomen "Number of women with a live birth in the last 2 years who received a PNC visit within one week of birth".
value labels numWomen 1 "" .

compute pncLocation = 0.
if (PN24 = 11 or PN24 = 12) pncLocation = 11.
if (PN24 >= 21 and PN24 <= 26) pncLocation = 12.
if (PN24 >= 31 and PN24 <= 36) pncLocation = 13.
if (PN24 = 96) pncLocation = 96.
if (pncLocation = 0 or PN24 = 76 or PN24 = 98 or PN24 = 99) pncLocation = 98.
variable labels pncLocation "Location of first PNC visit for mothers".
value labels pncLocation
  11 "Home"
  12 "Public Sector"
  13 "Private Sector"
  96 "Other location"
  98 "DK/Missing" .

compute total = 1 .
variable labels total "Total" .
value labels total 1 " " .

variable labels bh3_last "Sex of newborn".

* Ctables command in English.
ctables
  /table   total [c]
        + bh3_last [c]
         + hh6 [c]
         + hh7 [c]
         + welevel [c]
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + deliveryType [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]    
   by
           pncLocation [c] [rowpct.validn '' f5.1]
         + pncProvider [c] [rowpct.validn '' f5.1]
         + numWomen[s] [count '' f5.0]
  /categories variables=all empty=exclude
  /categories variables=pncLocation pncProvider total = yes position=after label="Total"
  /slabels position=column visible=no
  /titles title=
     "Table TM.8.8: Post-natal care visits for mothers within one week of birth"
       "Percent distribution of women age 15-49 years with a live birth in the last 2 years who for the most recent live birth received a post-natal care (PNC) visit " +
        "within one week of birth, by location and provider of the first PNC visit," + surveyname
.	

new file.
