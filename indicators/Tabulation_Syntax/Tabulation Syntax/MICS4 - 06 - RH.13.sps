include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

*___________________________________________ select women that gave birth in two years preceeding the survey.

select if (CM13 = "Y" or CM13 = "O").

*___________________________________________ select newborns with a PNC visit within the first week of life.

compute pncmed = 0.
if (PN13A = "A" or PN13B = "B" or PN13C = "C" or PN13F = "F" or PN13G = "G") pncmed = 1.
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

select if (pncvisit < 5).

compute total = 1.
variable labels total "Number of all newborns born in the preceding two years with a PNC visit within the first week of life".
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

compute pncloc = 0.
if (PN14 >= 21 and PN14 <= 26) pncloc = 12.
if (PN14 >= 31 and PN14 <= 36) pncloc = 13.
if (PN14 = 11 or PN14 = 12) pncloc = 11.
if (PN14 = 96) pncloc = 96.
if (PN14 = 98 or PN14 = 99) pncloc = 98.
variable labels pncloc "Location of first PNC visit".
value labels pncloc
  12 "Public Sector"
  13 "Private Sector"
  11 "Home"
  96 "Other location"
  98 "Missing/DK".

compute pncdoc = 0.
if (PN13A = "A" or PN13B = "B" ) pncdoc = 11.
if (pncdoc = 0 and PN13C = "C") pncdoc = 12.
if (pncdoc = 0 and PN13G = "G") pncdoc = 13.
if (pncdoc = 0 and PN13F = "F") pncdoc = 14.
if (pncdoc = 0 and (PN13X = "X" or PN13A = "?" )) pncdoc = 96.
variable labels pncdoc "Provider of first PNC visit".
value labels pncdoc
  11 "Doctor/ nurse/ midwife"
  12 "Auxiliary midwife"
  13 "Community health worker"
  14 "Traditional birth attendant"
  96 "Other/missing".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1 " ".

compute tot2 = 100.
variable labels tot2 "Total".
value labels tot2 100 " ".

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /table hh7 [c] + bagecat [c] + place1 [c] + place2 [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  	pncloc [c] [rowpct.validn,'',f5.1] + 
	pncdoc [c] [rowpct.validn,'',f5.1] +
  	total[s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /categories var=pncloc pncdoc total = yes position=after label="Total"
  /title title=
    "Table RH.13: Post-natal care (PNC) visits for newborns within one week of birth"
    "Percentage of newborns who were born in the last two years and received a PNC visit within one week of birth " 
    "by location and provider of the first PNC visit, " + surveyname.												
			
new file.
