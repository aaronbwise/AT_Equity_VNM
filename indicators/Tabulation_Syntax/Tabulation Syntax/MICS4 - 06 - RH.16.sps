include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

*___________________________________________ select women that gave birth in two years preceeding the survey.

select if (CM13 = "Y" or CM13 = "O").

compute total = 1.
variable labels total "Number of women age 15-49 years who gave birth in the 2 years preceding the survey".
value labels total 1 "".

compute agebrth = (wdoblc - wdob)/12.
variable labels agebrth "Mother's age at birth".
if (CM10 = 1) agebrth = (wdobfc - wdob)/12.

compute csec = 1.
if (MN19 = 1) csec = 2.
variable labels csec  "Type of delivery".
value labels csec
1 "Vaginal birth"
2 "C-section".

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

compute pncmed1 = 0.
if (PN13A = "A" or PN13B = "B "or PN13C = "C" or PN13F = "F" or PN13G = "G") pncmed1 = 1.
variable labels pncmed1 "Person checking health of a newborn".

compute pncvisit1 = 9.
if ((PN9 <> 9 and PN10 <> 1) or pncmed1 = 0) pncvisit1 = 6.
if (PN12AU = 1 and  pncmed1 = 1) pncvisit1 = 1.
if (PN12BU = 1 and  pncmed1 = 1) pncvisit1 = 1.
if (PN12AU = 2 and PN12AN = 1 and pncmed1 = 1) pncvisit1 = 2.
if (PN12BU = 2 and PN12BN = 1 and pncmed1 = 1) pncvisit1 = 2.
if (PN12AU = 2 and PN12AN = 2 and  pncmed1 = 1) pncvisit1 = 3.
if (PN12BU = 2 and PN12BN = 2 and  pncmed1 = 1) pncvisit1 = 3.
if (PN12AU = 2 and PN12AN >= 3 and PN12AN <= 6 and  pncmed1 = 1) pncvisit1 = 4.
if (PN12BU = 2 and PN12BN >= 3 and  PN12BN <=6 and pncmed1 = 1) pncvisit1 = 4.
if (PN12AU = 3 and  pncmed1 = 1) or (PN12AU = 2 and PN12AN > 6 and PN12AN < 98 and pncmed1 = 1) pncvisit1 = 5.
if (PN12BU = 3 and  pncmed1 = 1) or (PN12BU = 2 and PN12BN > 6 and PN12BN < 98 and pncmed1 = 1)  pncvisit1 = 5.

variable labels pncvisit1 "PNC visit".
value labels pncvisit1
  1 "Same day"
  2 "1 day following birth"
  3 "2 days following birth"
  4 "3-6 days following birth"
  5 "After the first week following birth"
  6 "No post-natal care visit"
  9 "Missing/DK".

compute pncchk1 = 0.
if ((PN3 = 1 or PN7 = 1)) or ((pncvisit1 =1 or pncvisit1 =2)) pncchk1 = 100.
variable labels pncchk1 "Post-natal health check for the newborn [1]".

compute pncmed = 0.
if (PN22A = "A" or PN22B = "B "or PN22C = "C" or PN22F = "F" or PN22G = "G") pncmed = 1.
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

compute pncchk = 0.
if ((PN4 = 1 or PN8 = 1)) or ((pncvisit = 1 or pncvisit = 2)) pncchk = 100.
variable labels pncchk "Post-natal health check for the mother [1]".

compute both = 4.
if (pncchk = 100 and pncchk1 = 100) both = 1.
if (pncchk = 100 and pncchk1 <> 100) both = 2.
if (pncchk <> 100 and pncchk1 = 100) both = 3.
if (pncvisit1 = 9 and pncvisit = 9) both = 9.
variable labels both "Health checks or PNC visits within 2 days of birth for:".
value labels both 
1 "Both mothers and newborns"
2 "Mothers only"
3 "Newborns only"
4 "Neither mother  nor newborn"
9 "Missing".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1 " ".

compute tot2 = 100.
variable labels tot2 "Total".
value labels tot2 100 " ".

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /table hh7 [c] + hh6 [c] + bagecat [c] + place1 [c] + place2 [c] + csec[c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  	both [c] [rowpct.validn,'',f5.1] + 
                  tot2 [s] [mean,'',f5.1] +
  	total[s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /title title=
    "Table RH.16: Post-natal health checks for mothers and newborns"
    "Percent distribution of women age 15-49 who gave birth in the two years preceding the survey by receipt of health checks " 
    "and post-natal care (PNC) visits within 2 days of birth, for the mother and newborn, " + surveyname.						
				
new file.
