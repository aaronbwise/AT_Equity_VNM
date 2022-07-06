* MICS5 HH-02.

* v02 - 2014-02-14.
* v03 - 2015-04-21: title changed.

* Information on age and sex are collected in the List of Household Members in the Household Questionnaire (Questions HL6 and HL4).
* Missing information on sex is normally not expected; in the event that few household members have missing sex in the final data set,
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
variable label memage "Age".
value label memage
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
  99 "Missing/DK".

* Recode single age groups to dependency age groups.
recode HL6 (0 thru 14 = 1) (15 thru 64 =2 ) (65 thru 95 = 3) (97,98,99 = 99) into depend.
variable labels depend "Dependency age groups".
value labels depend
  1  "0-14"
  2  "15-64"
  3  "65+"
  99 "Missing/DK".

* Recode single age groups to children and adult age groups.
recode HL6 (0 thru 17 = 1) (18 thru 95 = 2) (else = 99) into age017.
variable labels age017 "Children and adult populations".
value labels age017
  1  "Children age 0-17 years"
  2  "Adults age 18+ years"
  99 "Missing/DK".

compute total = 1.
variable labels total " ".
value labels total 1"Total".

* Compute empty variables to format the table.
compute row1 = $sysmis.
compute row2 = $sysmis.

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = hl4 total
           display = none
  /table   total [c]
         + memage[c]
         + depend [c]
         + age017 [c]
   by
           total [c] [count,'Number',f5.0,colpct.validn,'Percent',f5.1]
         + hl4  [c] [count,'Number',f5.0,colpct.validn,'Percent',f5.1]
  /categories var=all empty=exclude missing=exclude
  /title title=
      "Table HH.2: Age distribution of household population by sex"
      "Percent and frequency distribution of the household population by five-year age groups, dependency age groups,"
      "and by child (age 0-17 years) and adult populations (age 18 or more), by sex, " + surveyname
  .



new file.
