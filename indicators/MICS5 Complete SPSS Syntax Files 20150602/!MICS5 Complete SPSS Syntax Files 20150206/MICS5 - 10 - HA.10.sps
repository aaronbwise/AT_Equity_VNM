* MICS5 HA-10 .

* v01 - 2014-03-18.

* Men who have been circumcised: MMC1=1;
  age at circumcision is obtained from MMC2 .

***.


include "surveyname.sps".

get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.

select if (mwage >= 1 and mwage <= 7).

recode MMC1 (1 = 100) (else = 0) into beenCircumcised.
variable labels beenCircumcised "Percent circumcised [1]".

compute numMen = 1 .
variable labels numMen "Number of men age 15-49 years" .

do if (MMC1 = 1) .
+ recode MMC2
   (0 = 1)
   (1 thru 4 = 2)
   (5 thru 9 = 3)
   (10 thru 14 = 4)
   (15 thru 19 = 5)
   (20 thru 24 = 6)
   (25 thru 49 = 7)
   (else = 8) into ageAtCircumcision .
+ compute numBeenCircumcised = 1 .
end if .

variable labels ageAtCircumcision "Age at circumcision:".
value labels ageAtCircumcision
  1 "During infancy"
  2 "1-4 years"
  3 "5-9 years"
  4 "10-14 years"
  5 "15-19 years"
  6 "20-24 years"
  7 "25+ years"
  8 "DK/Missing" .

variable labels numBeenCircumcised "Number of men age 15-49 years who have have been circumcised".

recode mwage (1 = 2) (2 = 3) into mwageAux .

recode mwage (1, 2 = 1) (3 = 4) (4, 5 = 5) (6, 7 = 6).
variable labels mwage "Age".
value labels mwage
 1 "15-24"
 2 "    15-19"
 3 "    20-24"
 4 "25-29"
 5 "30-39"
 6 "40-49" .

mrsets
  /mcgroup name=$mwage
   label='Age'
   variables=mwage mwageAux .

compute total = 1.
variable labels total "".
value labels total 1 "Total".


* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + $mwage [c]
         + mwelevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           beenCircumcised [s] [mean,'',f5.1]
         + numMen [s] [sum,'',f5.0]
         + ageAtCircumcision [c] [rowpct.validn,'',f5.1]
         + numBeenCircumcised [s] [sum,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /categories var = ageAtCircumcision total = yes position = after label = "Total"
  /slabels visible = no
  /title title=
    "Table HA.10: Male circumcision"
    "Percentage of men age 15-49 years who report having been circumcised, and percent distribution of men by age of circumcision, " + surveyname
   caption =
    "[1] MICS indicator 9.17 - Male circumcision"
  .

new file.
