* MICS5 SW-02M.

* v01 - 2013-06-22.

* REMARK: this intro should be updated when Attila updates tab plan.

* Overall life satisfaction: MLS12=1 or 2.

* The average overall life satisfaction score is the average of responses to MLS12.
* Lower scores indicate higher satisfaction levels.

* Happiness: Women who are very or somewhat happy (MLS2=1 or 2).

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open men dataset.
get file = 'mn.sav'.

* Select completed interviews.
select if (MWM7 = 1).

* Select men aged 15-24.
select if (mwage = 1 or mwage  = 2).

* Weight the data by the men weight.
weight by mnweight.

* Create marital status with separate groups for ever married married.
recode mmstatus  (1, 2 = 1) (3 = 2) (else = 9).
variable labels mmstatus  "Marital status".
value labels mmstatus 
   1 "Ever married/in union"
   2 "Never married/in union"
   9 "Missing".

* Generate total variable.
compute numMen = 1 .
variable labels numMen "Number of men age 15-24 years" .

* Generate indicators.
recode MLS12 (1, 2 = 100) (else = 0) into overall.
variable labels overall "Percentage of men with overall life satisfaction [1]".

missing values MLS12 (6 thru 9).
variable labels MLS12 "Average life satisfaction score".

recode MLS2 (1, 2 = 100) (else = 0) into happy.
variable labels happy "Percentage of men who are very or somewhat happy [2]".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

ctables
  /vlabels variables =  total
           display = none
  /table   total [c]
         + mwage  [c]
         + hh7 [c]
         + hh6 [c]
         + mmstatus  [c]
         + mwelevel [c]
         + windex5 [c]
         + ethnicity [c]
     by
           overall [s] [mean,'',f5.1]
         + MLS12 [s] [mean,'',f5.1]
         + happy [s] [mean,'',f5.1]
         + numMen [s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
      "Table SW.2M: Overall life satisfaction and happiness (men)"
      "Percentage of men age 15-24 years who are very or somewhat satisfied with their life "+
      "overall, the average overall life satisfaction score, and percentage of men age 15-24 years " +
      "who are very or somewhat happy, " + surveyname
  caption =
      "[1] MICS Indicator 11.1 - Life satisfaction [M]"
      "[2] MICS indicator 11.2 - Happiness [M]"
  .

new file.
