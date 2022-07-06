* MICS5 SW-02.

* v01 - 2013-06-22.

* REMARK: this intro should be updated when Attila updates tab plan.

* Overall life satisfaction: LS12=1 or 2.

* The average overall life satisfaction score is the average of responses to LS12.
* Lower scores indicate higher satisfaction levels.

* Happiness: Women who are very or somewhat happy (LS2=1 or 2).

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open women dataset.
get file = 'wm.sav'.

* Select completed interviews.
select if (WM7 = 1).

* Select women aged 15-24.
select if (wage = 1 or wage = 2).

* Weight the data by the women weight.
weight by wmweight.

* Create marital status with separate groups for ever married married.
recode mstatus  (1, 2 = 1) (3 = 2) (else = 9).
variable labels mstatus  "Marital status".
value labels mstatus 
    1 "Ever married/in union"
    2 "Never married/in union"
    9 "Missing".

* Generate total variable.
compute numWomen = 1.
variable labels numWomen "Number of women age 15-24 years" .


* Generate indicators.
recode LS12 (1, 2 = 100) (else = 0) into overall.
variable labels overall "Percentage of women with overall life satisfaction [1]".

missing values LS12 (6 thru 9).
variable labels LS12 "Average life satisfaction score".

recode LS2 (1, 2 = 100) (else = 0) into happy.
variable labels happy "Percentage of women who are very or somewhat happy [2]".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

ctables
  /vlabels variables =  total
           display = none
  /table   total[c]
         + wage [c]
         + hh7 [c]
         + hh6 [c]
         + mstatus  [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]
     by
           overall [s] [mean,'',f5.1]
         + LS12 [s] [mean,'',f5.1]
         + happy [s] [mean,'',f5.1]
         + numWomen [s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
      "Table SW.2: Overall life satisfaction and happiness (women)"
      "Percentage of women age 15-24 years who are very or somewhat satisfied with their life "+
      "overall, the average overall life satisfaction score, and percentage of women age 15-24 years " +
      "who are very or somewhat happy, " + surveyname
  caption =
      "[1] MICS Indicator 11.1 - Life satisfaction"
      "[2] MICS indicator 11.2 - Happiness"
  .

new file.
