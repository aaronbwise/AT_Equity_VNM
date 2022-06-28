* Encoding: UTF-8.
***.
*v02. 2019-03-14.
*v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.


include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

*select women that gave birth in two years preceeding the survey.
select if (CM17 = 1).

* definitions of anc, ageAtBirth .
include 'define\MICS6 - 06 - TM.sps' .

*PN13A/B=100 through 199, 201 through 299 AND PN14=A through G.

compute pncProvider = 0.
if (PN14A = "A" or PN14B = "B") pncProvider = 11.
if (pncProvider = 0 and PN14C = "C") pncProvider = 12.
if (pncProvider = 0 and PN14G = "G") pncProvider = 13.
if (pncProvider = 0 and PN14F = "F") pncProvider = 14.
if (pncProvider = 0 and (PN14H = "H" or PN14X = "X" or PN14A = "?" )) pncProvider = 96.
variable labels pncProvider "Provider of first PNC visit for newborns".
value labels pncProvider
  11 "Doctor/ nurse/ midwife"
  12 "Other qualified" 
  13 "Community / village health worker"
  14 "Traditional birth attendant"
  96 "Other/Missing"
  .

select if (pncVisitC<5 and pncProvider <= 14) .

recode PN15
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
  9 "DK/Missing" .


compute numBirths = 1.
variable labels numBirths "Number of women with a live birth in the last 2 years whose most recent live-born child had a PNC visit within one week of birth".
value labels numBirths 1 "".

variable labels welevel "Education".
variable labels ageAtBirth "Age at most recent live birth".
variable labels disability "Functional difficulties (age 18-49 years)".
variable labels bh3_last "Sex of newborn".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /table   total [c]
         + bh3_last [c]
         + hh6 [c]
         + hh7 [c]
         + welevel [c]
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]    
   by
           pncLocation [c] [rowpct.validn '' f5.1]
         + pncProvider [c] [rowpct.validn '' f5.1]
         + numBirths[s] [count '' f5.0]
  /categories variables=all empty=exclude
  /categories variables=pncLocation pncProvider total=yes label='Total'
  /slabels position=column visible=no
  /titles title=
     "Table TM.8.3: Post-natal care visits for newborns within one week of birth"
	"Percent distribution of women age 15-49 years with a live birth in the last 2 years whose most recent live-born child " +
                  "received a post-natal care (PNC) visit within one week of birth, by location and provider of the first PNC visit, " + surveyname  .
									
new file.
