* MICS5 RH-14.

* v01 - 2014-03-19..

* Newborns who received a PNC visit within the first week of life: PN12A or PN12B=100 through 199, 201 through 299 AND PN13=A through G
  Location of first PNC visit: PN14
  Provider of first PNC visit: PN13 .

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

* select women that gave birth in two years preceeding the survey.
select if (CM13 = "Y" or CM13 = "O").

* definitions of anc, ageAtBirth .
include 'define\MICS5 - 06 - RH.sps' .

select if (pncVisitC<5) .

recode PN14
  (11,12 = 1)
  (21 thru 26 = 2)
  (31 thru 36 = 3)
  (96 = 4)
  (else = 9) into pncLocation .
variable labels pncLocation "Location of first PNC visit for newborns" .
value labels pncLocation
  1 "Home"
  2 "Public sector"
  3 "Private sector"
  4 "Other location"
  9 "Missing" .

compute pncProvider = 0.
if (PN13A = "A" or PN13B = "B") pncProvider = 11.
if (pncProvider = 0 and PN13C = "C") pncProvider = 12.
if (pncProvider = 0 and PN13G = "G") pncProvider = 13.
if (pncProvider = 0 and PN13F = "F") pncProvider = 14.
if (pncProvider = 0 and (PN13H = "H" or PN13X = "X" or PN13A = "?")) pncProvider = 96.
variable labels pncProvider "Provider of first PNC visit for newborns".
value labels pncProvider
  11 "Doctor/ nurse/ midwife"
  12 "Auxiliary midwife" 
  13 "Community health worker"
  14 "Traditional birth attendant"
  96 "Other/missing"
  .

compute numBirths = 1.
variable labels numBirths "Number of last live births in the last two years with a PNC visit within the first week of life".
value labels numBirths 1 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + welevel [c]
         + windex5 [c]    
         + ethnicity [c]   
   by
           pncLocation [c] [rowpct.validn,'',f5.1]
         + pncProvider [c] [rowpct.validn,'',f5.1]
         + numBirths[s] [count,'',f5.0]
  /categories variables=all empty=exclude
  /categories variables=pncLocation pncProvider total=yes label='Total'
  /slabels position=column visible=no
  /titles title=
     "Table RH.14: Post-natal care visits for newborns within one week of birth"
	"Percent distribution of women age 15-49 years with a live birth in the last two years whose last live birth received a post-natal care (PNC) "+
	"visit within one week of birth, by location and provider of the first PNC visit, " + surveyname  .
									
new file.
