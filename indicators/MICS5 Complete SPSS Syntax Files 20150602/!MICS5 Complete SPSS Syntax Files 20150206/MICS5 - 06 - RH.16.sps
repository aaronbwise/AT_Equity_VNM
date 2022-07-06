* MICS5 RH-16.

* v01 - 2014-03-19.
* v02 - 2014-04-28.
* background variable "healthFacility" excluded from the table. 

* Mothers who received a PNC visit within one week of birth:
    PN21A or PN21B=100 through 199, 201 through 299 AND PN22=A through G
  Location of first PNC visit: PN23
  Provider of first PNC visit: PN22  .

***.
include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

* select women that gave birth in two years preceeding the survey.
select if (CM13 = "Y" or CM13 = "O").

* definitions of anc, ageAtBirth .
include 'define/MICS5 - 06 - RH.sps' .

* select mothers with a PNC visit within the first week of life.
select if (pncVisitM < 5) .

compute numWomen = 1 .
variable labels numWomen "Number of women who gave birth in the two years preceding survey and received a PNC visit within one week of delivery".
value labels numWomen 1 "" .

compute pncLocation = 0.
if (PN23 = 11 or PN23 = 12) pncLocation = 11.
if (PN23 >= 21 and PN23 <= 26) pncLocation = 12.
if (PN23 >= 31 and PN23 <= 36) pncLocation = 13.
if (PN23 = 96) pncLocation = 96.
if (PN23 = 98 or PN23 = 99) pncLocation = 98.
variable labels pncLocation "Location of first PNC visit".
value labels pncLocation
  11 "Home"
  12 "Public Sector"
  13 "Private Sector"
  96 "Other location"
  98 "Missing/DK" .

compute pncProvider = 0.
if (PN22A = "A" or PN22B = "B" ) pncProvider = 11.
if (pncProvider = 0 and PN22C = "C") pncProvider = 12.
if (pncProvider = 0 and PN22G = "G") pncProvider = 13.
if (pncProvider = 0 and PN22F = "F") pncProvider = 14.
if (pncProvider = 0 and (PN22H = "H" or PN22X = "X" or PN22A = "?" )) pncProvider = 96.
variable labels pncProvider "Provider of first PNC visit".
value labels pncProvider
  11 "Doctor/ nurse/ midwife"
  12 "Auxiliary midwife"  
  13 "Community health worker"
  14 "Traditional birth attendant"
  96 "Other/missing" .

compute total = 1 .
variable labels total "Total" .
value labels total 1 " " .

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + deliveryType [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]      
   by
           pncLocation [c] [rowpct.validn,'',f5.1]
         + pncProvider [c] [rowpct.validn,'',f5.1]
         + numWomen[s] [count,'',f5.0]
  /categories var=all empty=exclude
  /categories var=pncLocation pncProvider total = yes position=after label="Total"
  /slabels position=column visible=no
  /titleq title=
     "Table RH.16: Post-natal care visits for mothers within one week of birth"
	"Percent distribution of women age 15-49 years with a live birth in the last two years who received a post-natal care (PNC) "+
	 "visit within one week of birth, by location and provider of the first PNC visit, " + surveyname
  	.

new file.
