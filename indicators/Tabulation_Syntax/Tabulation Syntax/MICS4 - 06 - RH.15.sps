include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

*___________________________________________ select women that gave birth in two years preceeding the survey.

select if (CM13 = "Y" or CM13 = "O").

*___________________________________________ select mothers with a PNC visit within the first week of life.

compute pncmed = 0.
if (PN22A = "A" or PN22B = "B" or PN22C = "C" or PN22F = "F" or PN22G = "G") pncmed = 1.
variable labels pncmed "Person checking health".

compute pncvisit = 9.
if ((PN16 <> 1 and PN18 <> 1 and PN19 <> 1) or pncmed = 0) pncvisit = 6.
if (PN21AU = 1 and  pncmed = 1) pncvisit = 1.
if (PN21BU = 1 and  pncmed = 1) pncvisit = 1.
if (PN21AU = 2 and PN21AN = 1 and pncmed = 1) pncvisit = 2.
if (PN21BU = 2 and PN21BN = 1 and pncmed = 1) pncvisit = 2.
if (PN21AU = 2 and PN21AN = 2 and  pncmed = 1) pncvisit = 3.
if (PN21BU = 2 and PN21BN = 2 and  pncmed = 1) pncvisit = 3.
if (PN21AU = 2 and PN21AN >= 3 and PN21AN <= 6 and  pncmed = 1) pncvisit = 4.
if (PN21BU = 2 and PN21BN >= 3 and  PN21BN <=6 and pncmed = 1) pncvisit = 4.
if (PN21AU = 3 and  pncmed = 1) or (PN21AU = 2 and PN21AN > 6 and PN21AN < 98 and pncmed = 1) pncvisit = 5.
if (PN21BU = 3 and  pncmed = 1) or (PN21BU = 2 and PN21BN > 6 and PN21BN < 98 and pncmed = 1)  pncvisit = 5.
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
variable labels total "Number of women who gave birth in the two years preceding survey and received a PNC visit within one week of delivery".
value labels total 1 "".

compute agebrth = (wdoblc - wdob)/12.
variable labels agebrth "Mother's age at birth".
if (CM10 = 1) agebrth = (wdobfc - wdob)/12.

compute bagecat = 9.
if (agebrth < 20) bagecat = 1.
if (agebrth >= 20 and agebrth < 35) bagecat = 2.
if (agebrth >= 35 and agebrth <= 49) bagecat = 3.
variable labels bagecat "Mother's age at birth".
value labels bagecat
  1 "Less than 20"
  2 "20-34"
  3 "35-49"
  9 "Missing".

compute csec = 1.
if (MN19 = 1) csec = 2.
variable labels csec  "Type of delivery".
value labels csec
1 "Vaginal birth"
2 "C-section".

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
if (PN23 >= 21 and PN23 <= 26) pncloc = 12.
if (PN23 >= 31 and PN23 <= 36) pncloc = 13.
if (PN23 = 11 or PN23 = 12) pncloc = 11.
if (PN23 = 96) pncloc = 96.
if (PN23 = 98 or PN23 = 99) pncloc = 98.
variable labels pncloc "Location of first PNC visit".
value labels pncloc
  12 "Public Sector"
  13 "Private Sector"
  11 "Home"
  96 "Other location"
  98 "Missing/DK".

compute pncdoc = 0.
if (PN22A = "A" or PN22B = "B" ) pncdoc = 11.
if (pncdoc = 0 and PN22C = "C") pncdoc = 12.
if (pncdoc = 0 and PN22G = "G") pncdoc = 13.
if (pncdoc = 0 and PN22F = "F") pncdoc = 14.
if (pncdoc = 0 and (PN22X = "X" or PN22A = "?" )) pncdoc = 96.
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
  /table hh7 [c] + hh6 [c] + bagecat [c] + place1 [c] + place2 [c] + csec[c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  	pncloc [c] [rowpct.validn,'',f5.1] + 
	pncdoc [c] [rowpct.validn,'',f5.1] +
  	total[s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /categories var=pncloc pncdoc total = yes position=after label="Total"
  /title title=
    "Table RH.15: Post-natal care (PNC) visits for mothers within one week of birth"
    "Percentage of women age 15-49 years who gave birth in the preceding 2 years and received a PNC visit within one week of birth,  " 
    "by location and provider of the first PNC visit, " + surveyname.
												
			
new file.
