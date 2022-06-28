* Encoding: UTF-8.
* MICS6 SR.4.1.

* v01 - 2017-09-21.
* v02 - 2018-01-28.
* v03 - 2020-04-09. Table sub-title changed, and footnote added based on the latest tab plan. Labels in French and Spanish have been removed.

** Information on age and sex are collected in the List of Household Members in the Household Questionnaire (Questions HL6 and HL4). 
** Missing information on sex is normally not expected; in the event that few household members have missing sex in the final data set, 
this should be indicated in the final report in a footnote to the table, and such cases should be excluded from the table.


***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get file = 'hl.sav'.

* Weight the data by the household weight.
weight by hhweight.

variable labels hl4 "".
value labels hl4
  1 "Males"
  2 "Females"
  9 "Missing".

* Recode single age groups to 5 year age groups.
recode HL6
  ( 0 thru  4 = 1 ) ( 5 thru  9 =  2) (10 thru 14 =  3) (15 thru 19 =  4)
  (20 thru 24 = 5 ) (25 thru 29 =  6) (30 thru 34 =  7) (35 thru 39 =  8)
  (40 thru 44 = 9 ) (45 thru 49 = 10) (50 thru 54 = 11) (55 thru 59 = 12)
  (60 thru 64 = 13) (65 thru 69 = 14) (70 thru 74 = 15) (75 thru 79 = 16)
  (80 thru 84 = 17) (85 thru 95 = 18) (97,98,99 = 99) into memage.
variable labels memage "Age".
value labels memage
  1  "0-4"
  2  "5-9"
  3  "10-14"
  4  "15-19"
  5  "20-24"
  6  "25-29"
  7  "30-34"
  8  "35-39"
  9  "40-44"
  10 "45-49"
  11 "50-54"
  12 "55-59"
  13 "60-64"
  14 "65-69"
  15 "70-74"
  16 "75-79"
  17 "80-84"
  18 "85+"
  99 "DK/Missing".

compute memageAux = memage.
recode HL6 (15 thru 17 = 4.1) (18 thru 19 = 4.2) into memageAux1.

value labels memageAux
  1  "0-4"
  2  "5-9"
  3  "10-14"
  4  "15-19"
  4.1 "  15-17"
  4.2 "  18-19"
  5  "20-24"
  6  "25-29"
  7  "30-34"
  8  "35-39"
  9  "40-44"
  10 "45-49"
  11 "50-54"
  12 "55-59"
  13 "60-64"
  14 "65-69"
  15 "70-74"
  16 "75-79"
  17 "80-84"
  18 "85+"
  99 "DK/Missing".

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $memage
           label = 'Age'
           variables = memageAux memageAux1.

* Recode single age groups to children and adult age groups.
recode HL6 (0 thru 17 = 1) (18 thru 95 = 2) (else = 99) into age017.
variable labels age017 "Children and adult populations".
value labels age017
  1  "Children age 0-17 years"
  2  "Adults age 18+ years"
  99 "DK/Missing".

compute total = 1.
variable labels total " ".
value labels total 1 "Total".


* Ctables command in English.
ctables
  /vlabels variables = hl4 total
           display = none
  /table   total [c]
         + $memage[c]
         + age017 [c]
   by
          hl4  [c] [count,'Number',f5.0,colpct.validn,'Percent',f5.1]
          + total [c] [count,'Number',f5.0,colpct.validn,'Percent',f5.1]
  /categories variables=all empty=exclude missing=exclude
  /titles title=
      "Table SR.4.1: Age distribution of household population by sex"
      "Percent and frequency distribution of the household population [A] in five-year age groups and child (age 0-17 years) and adult populations (age 18 or more), by sex, " + surveyname
   caption =
     "[A] As this table includes all household members listed in interviewed households, the numbers and distributions by sex do not match those found for individuals in tables SR.5.1W/M, SR.5.2 and SR.5.3 " +
     "where interviewed individuals are weighted with individual sample weights."
  .

new file.
