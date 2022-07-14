include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

*___________________________________________ select women that gave birth in two years preceeding the survey.

select if (CM13 = "Y" or CM13 = "O").

*___________________________________________ select women that gave birth in a health facility.

compute instdlv = 0.
if ( (MN18 >= 21 and MN18 <= 26) or (MN18 >= 31 and MN18 <= 36) ) instdlv = 100.
variable label instdlv "Delivered in health facility".

select if (instdlv = 100).

compute total = 1.
variable label total "Number of women who gave birth in a health facility in the preceding two years".
value label total 1 "".

compute agebrth = (wdoblc - wdob)/12.
variable label agebrth "Mother's age at birth".
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

compute novisits = 0.
if (MN3 >= 1 and MN3 <= 3) novisits = 1.
if (MN3 >= 4) novisits = 2.
if (MN3 = 98 or MN3 = 99) novisits = 9.
variable label novisits "Percent of women who had:".
value label novisits
  0 "None"
  1 "1-3 visits"
  2 "4+ visits"
  9 "Missing/DK".

recode MN18 (11,12=0) (21 thru 29=1)(31 thru 39=2) (else=9) into place.
variable labels place "Type of health facility".
value labels place 
  0 "Home"
  1 "Public"
  2 "Private"
  9 "Other/DK/Missing".

recode MN19 (1=1) (else=2) into csect.
variable labels csect "Type of delivery".
value labels csect
  1 "C-section"
  2 "Not via C-section".

compute dstay = 9.
if (PN2U = 1 and PN2N < 6) dstay = 1.
if (PN2U = 1 and PN2N >= 6 and PN2N <= 11) dstay = 2.
if (PN2U = 1 and PN2N >= 12 and PN2N < 98) dstay = 3.
if (PN2U = 2 and (PN2N = 1 or PN2N = 2)) dstay = 4.
if (PN2U = 2 and PN2N >= 3 and PN2N < 98) dstay = 5.
if (PN2U >= 3) dstay = 5.
variable label dstay "Duration of stay in health facility:".
value label dstay
  1 "Less than 6 hours"
  2 "6-11 hours"
  3 "12-23 hours"
  4 "1-2 days"
  5 "3 days or more"
  9 "Missing/DK".

compute more12 = 0.
if (dstay = 3 or dstay = 4 or dstay = 5) more12 = 100.
variable label more12 "12 hours or more [1]".

compute tot1 = 1.
variable label tot1 "Total".
value label tot1 1 " ".

compute tot2 = 100.
variable label tot2 "Total".
value label tot2 100 " ".

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /table hh7r [c] + hh7 [c] + hh6a [c] + hh6b [c] + bagecat [c] + place [c] + csect [c] + welevel [c] + windex5 [c] + ethnicity [c] + lang [c] + religion [c] + tot1 [c] by 
  	dstay [c] [rowpct.validn,'',f5.1] + 
                  tot2 [s] [mean,'',f5.1] +
	more12 [s] [mean,'',f5.1] +
  	total[s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /title title=
    "Table RH.11: Post-partum stay in health facility"
    "Percent distribution of women age 15-49 years who gave birth in a health facility in the two years preceding the survey " 
    "by duration of stay in health facility following their last live birth, " + surveyname
  caption=
    "[1] MICS indicator 5.10".
					
new file.
