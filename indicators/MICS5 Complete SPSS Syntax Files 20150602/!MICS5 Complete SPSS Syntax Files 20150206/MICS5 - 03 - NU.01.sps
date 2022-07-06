* MICS5 NU-01.

* v02 - 2014-03-05.
* v03 - 2014-04-14.
* variable labels welevel is relabeled to "Mother’s education" as per to tab plan.

* The percentage of births weighing below 2,500 grams is estimated from two items in the questionnaire: the mother’s assessment of the child’s size
  at birth (ie, very small, smaller than average, average, larger than average, very large) (MN20) and the mother’s recall of the child’s weight
  or the information on the health card (MN22) if the child was weighed at birth (MN21).

* First, the two items are cross-tabulated for those children who were weighed at birth to obtain the proportion of births in each category
  of size who weighed less than 2,500 grams (25 percent of children reported as weighing exactly 2,500 grams are treated as weighing less
  than 2500 grams to adjust for heaping on 2,500 grams).
* This proportion is then multiplied by the total number of children falling in the size category to obtain the estimated number of children in
  each size category who were of low birth weight. The numbers for each size category are summed to obtain the total number of low birth weight children.
* This number is divided by the total number of last-born children to obtain the percentage with low birth weight.

* This method is not recommended if the number of children with birth weight information available (from the card or mother's recall) is
  less than 25 unweighted cases in any one of the five mother's assessment of size at birth categories (see above).
* To check this, SPSS produces an unweighted working table which cross-tabulates the mother's assessment of size at birth categories by availability
  of birth weight information. This working table should be checked before running NU1.
* If the method cannot be used because of this reason, then the table should then be re-designed to exclude the column reporting the percentage of
  live births below 2,500 grams.
* The rest of the table should be published.

* It should be noted that if birth weight information is available for only a small percentage of births, it is very likely that low birth weight
  prevalence for such groups will be significantly lower than the true prevalence of low birth weight for the total population, since births with
  birth weight information are usually more likely to be births to advantaged population groups (e.g. economically better-off, urban, educated,
  population groups with access to health facilities, etc), these will form the majority of the births with birth weight information.
* The lower the percentage of births with birth weight information, the larger the downward bias will be in low birth weight estimates.
* In most surveys, the indicator value will represent a lower bound of the true prevalence of children born with low birth weight.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'wm.sav'.

* select only those that have completed interview.
select if (WM7 = 1).

* ... and last live-born children in the last two years.
select if (CM13 = 'Y' or CM13 = "O" or CM13 = "S").

* select children those weights come from the card or the mother’s recall of the child’s weight. 
select if (any(MN22A, 1, 2)) .

* SPSS produces an unweighted working table which cross-tabulates the mother's assessment of size at birth categories
* by availability of birth weight information. This working table is used during the review process only as a background table.
* In the event of small sample sizes this table should be carefully examined whether the assumptions of the estimation method are applicable.

ctables
  /table MN20[c][ucount]
  /title title=
    "Working table.  In the event of small sample sizes this table should be carefully examined whether the assumptions of the estimation method are applicable".

weight by wmweight.

* generate binary variable if child is less then 2.5 kg.
* generate binary variable if child is equal to  2.5 kg.
compute lessThen2500 = MN22 < 2.5 .
compute equalTo2500 = MN22 = 2.5 .

compute total = 1 .

* aggregate the data in order to calculate the proportion low birth.
aggregate outfile = 'tmp.sav'
  /break   = MN20
  /lessThen2500Count  = sum(lessThen2500)
  /equalTo2500Count   = sum(equalTo2500)
  /totalCount         = sum(total) .


* merge data on the entire file, weight from card or recall .
get file = 'wm.sav'.

* select completed interviews.
select if (WM7 = 1).

* ... and last live-born children in the last two years.
select if (CM13 = 'Y' or CM13 = "O" or CM13 = "S").

weight by wmweight.

* merge the data for ratio calculation .
sort cases by MN20.

match files
  /file = *
  /table = 'tmp.sav'
  /by MN20 .

* compute ratio of less the 2.5kg in each group of MN20.
compute ratio = (lessThen2500Count + equalTo2500Count * 0.25)/ totalCount * 100 .

* generate total variable.
compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute total100 = 100.
variable labels total100 "Total".

compute  numChildren = 1.
variable labels numChildren ''.
value labels numChildren 1 'Number of last live-born children in the last two years'.

* generate order of the birth by looking at the total number of children ever born. 
recode cm10
  (1=1)
  (2,3 = 2)
  (4,5 = 4)
  (6 thru highest = 6)
  into birthOrder.
variable labels birthOrder "Birth order".
value labels birthOrder
 1 '1'
 2 '2-3'
 4 '4-5'
 6 '6+' .

* generate Mother's age at birth (calculate in months by subtracting CMC date of birth of last child and women date of birth).
compute motherAgeAtBirth = WDOBLC - WDOB.
recode motherAgeAtBirth
  (lowest thru 239 = 1)
  (240 thru 419 = 2)
  (420 thru highest = 3) .
variable labels motherAgeAtBirth "Mother's age at birth" .
value labels motherAgeAtBirth
  1 "Less than 20 years"
  2 "20-34 years"
  3 "35-49 years" .

* generate Percent distribution of births by mother's assessment of size at birth.
recode MN20
  (5 = 1)
  (4 = 2)
  (3 = 3)
  (2,1 = 4)
  (8,9 = 8) into sizeAtBirth.
variable labels sizeAtBirth "Percent distribution of births by mother's assessment of size at birth" .
value labels sizeAtBirth
  1 'Very small'
  2 'Smaller than average'
  3 'Average'
  4 'Larger than average or very large'
  8 'DK'.

* generate layer.
compute layer = 1.
variable labels layer ''.
value labels layer 1 'Percentage of live births:'.

* generate weighed at birth.
recode MN21
  (1 = 100)
  (else = 0)
  into weighedAtBirth .
variable labels weighedAtBirth 'Weighed at birth [2]'.

variable labels ratio 'Below 2,500 grams [1]' .

variable labels welevel "Mother’s education".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables=total layer numChildren display=none
  /table  total [c]
        + motherAgeAtBirth [c]
        + birthOrder [c]
        + hh7 [c]
        + hh6 [c]
        + welevel [c]
        + windex5 [c]
        + ethnicity [c]
   by
          sizeAtBirth [c] [rowpct f8.1]
        + total100 [s][mean f8.1 "Total"]
        + layer [c] > (
          ratio[s][mean f8.1]
          + weighedAtBirth [s][mean f8.1]
          )
        + numChildren [c][count]
  /slables visible = no
  /title title=
     "Table NU.1: Low birth weight infants"
     "Percentage of last live-born children in the last two years that are estimated to have weighed below 2,500 grams at birth and percentage of live births weighed at birth, " + surveyname
   caption =
     "[1] MICS indicator 2.20 - Low-birthweight infants"
     "[2] MICS indicator 2.21 - Infants weighed at birth" .

new file.

* Delete temporary working files.
erase file = 'tmp.sav'.