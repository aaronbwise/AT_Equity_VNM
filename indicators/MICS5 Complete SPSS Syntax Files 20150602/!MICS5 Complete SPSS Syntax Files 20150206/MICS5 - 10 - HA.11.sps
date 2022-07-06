* MICS5 HA-11 .

* v01 - 2014-03-17.

* Person peforming circumcision: MMC3.
* Location of circumcision: MMC4 .

***.


include "surveyname.sps".

get file = 'mn.sav'.

select if (MWM7 = 1 and MMC1 = 1).

weight by mnweight.

recode MMC3 (8,9 = 8) (else = copy) into personPerformingCircumcision.
variable labels personPerformingCircumcision "Person performing circumcision:".
value labels personPerformingCircumcision
 1 "Traditional practitioner/family/friend"
 2 "Health worker/professional"
 6 "Other"
 8 "Don't know/Missing".

recode MMC4 (8,9 = 8) (else = copy) into placeOfCircumcision.
variable labels placeOfCircumcision "Place of circumcision:".
value labels placeOfCircumcision
 1 "Health facility"
 2 "Home of a health worker/professional"
 3 "At home"
 4 "Ritual site"
 6 "Other home/place"
 8 "Don't know/Missing".

compute numMenCircumcised = 1.
variable labels numMenCircumcised "Number of men age 15-49 years who have have been circumcised".

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
           personPerformingCircumcision [c] [rowpct.validn,'',f5.1]
         + placeOfCircumcision [c] [rowpct.validn,'',f5.1]
         + numMenCircumcised [s] [sum,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /categories var = personPerformingCircumcision placeOfCircumcision total = yes position = after label = "Total"
  /slabels visible = no
  /title title=
    "Table HA.11: Provider and location of circumcision"
    "Percent distribution of circumcised men age 15-49 by person performing circumcision and the location where circumcision was performed" + surveyname
  .

new file.
