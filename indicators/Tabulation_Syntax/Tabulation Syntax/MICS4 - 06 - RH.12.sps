include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

*___________________________________________ select women that gave birth in two years preceeding the survey.

select if (CM13 = "Y" or CM13 = "O").

compute total = 1.
variable labels total "Number of last births in the two years preceding the survey".
value labels total 1 "".

compute agebrth = (wdoblc - wdob)/12.
variable labels agebrth "Mother's age at birth".
if (CM10 = 1) agebrth = (wdobfc - wdob)/12.

compute bagecat = 9.
if (agebrth < 20) bagecat = 1.
if (agebrth >= 20 and agebrth <35) bagecat = 2.
if (agebrth >= 35 and agebrth <= 49) bagecat = 3.
variable labels bagecat "Mother's age at birth".
value labels bagecat
  1 "Less than 20"
  2 "20-34"
  3 "35-49"
  9 "Missing".

recode MN18 (11,12=0) (21 thru 29=1)(31 thru 39=2) (else=9) into delivery.
variable labels delivery "Place of birth".
value labels delivery 
  0 "Home"
  1 "Public"
  2 "Private"
  9 "Other/DK/Missing".

recode delivery (0=0)(1,2=1)(else=sysmis) into place1.
recode delivery (0=sysmis)(else=copy) into place2.
variable labels 
  place1 "Place of birth"
 /place2 ".".
value labels 
  place1 
  0 "Home"
  1 "Health facility"
 /place2
  1 "  Public"
  2 "  Private"
  9 "Other/DK/Missing".

* Health check following birth while in facility or while at home.
compute healthch = 0.
if (PN3 = 1 or PN7 = 1) healthch = 100.
variable labels healthch "Health check following birth while in facility or at home".

* Person checking health: excluding relative / friend and other.
compute pncmed = 0.
if (PN13A = "A" or PN13B = "B "or PN13C = "C" or PN13F = "F" or PN13G = "G") pncmed = 1.
variable labels pncmed "Person checking health".

compute pncvisit = 9.
if ((PN9 <> 9 and PN10 <> 1) or pncmed = 0) pncvisit = 6.
if (PN12AU = 1 and  pncmed = 1) pncvisit = 1.
if (PN12BU = 1 and  pncmed = 1) pncvisit = 1.
if (PN12AU = 2 and PN12AN = 1 and pncmed = 1) pncvisit = 2.
if (PN12BU = 2 and PN12BN = 1 and pncmed = 1) pncvisit = 2.
if (PN12AU = 2 and PN12AN = 2 and  pncmed = 1) pncvisit = 3.
if (PN12BU = 2 and PN12BN = 2 and  pncmed = 1) pncvisit = 3.
if (PN12AU = 2 and PN12AN >= 3 and PN12AN <= 6 and  pncmed = 1) pncvisit = 4.
if (PN12BU = 2 and PN12BN >= 3 and  PN12BN <=6 and pncmed = 1) pncvisit = 4.
if (PN12AU = 3 and  pncmed = 1) or (PN12AU = 2 and PN12AN > 6 and PN12AN < 98 and pncmed = 1) pncvisit = 5.
if (PN12BU = 3 and  pncmed = 1) or (PN12BU = 2 and PN12BN > 6 and PN12BN < 98 and pncmed = 1)  pncvisit = 5.
variable labels pncvisit "PNC visit".
value labels pncvisit
  1 "Same day"
  2 "1 day following birth"
  3 "2 days following birth"
  4 "3-6 days following birth"
  5 "After the first week following birth"
  6 "No post-natal care visit"
  9 "Missing/DK".

compute pncchk = 0.
if (healthch = 100 or (pncvisit = 1 or pncvisit = 2)) pncchk = 100.
variable labels pncchk "Post-natal health check for the newborn [1]".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1 " ".

compute tot2 = 100.
variable labels tot2 "Total".
value labels tot2 100 " ".

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /table hh7 [c] + hh6 [c] + bagecat [c] + + place1 [c] + place2 [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
                  healthch [s] [mean,'',f5.1] +
  	pncvisit [c] [rowpct.validn,'',f5.1] + 
                  tot2 [s] [mean,'',f5.1] +
	pncchk [s] [mean,'',f5.1] +
  	total[s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /title title=
    "Table RH.12: Post-natal health checks for newborns"
    "Percentage of newborns born in the last two years who received health checks and post-natal care (PNC) " 
    "visits from any health provider after birth, " + surveyname
  caption=
    "[1] MICS indicator 5.11".

					
new file.
