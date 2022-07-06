* MICS5 RH-05.

* v01 - 2014-03-19.
* v02 - 2014-04-21.
* variable "any" renamed to "anyMethod" as any is predefined spss's function.
* v03 - 2014-04-28.
* As per the latest tab plan change missing data on question CP3 excluded from "traditional" methods.
* Therefore, if there are cases of missing responses to CP3, the two columns of modern and traditional methods will not sum to the indicator column of any method.


* The table is based only on women who were married or in union at the time of survey
    (MA1=1 or 2) .
* Women who were married or in union, and pregnant at the time of survey (CP1=1) are not asked the questions on contraception,
  but are included in the denominator of the table.
* Such women are included in the numerator of the column "Not using any method".

* Modern methods of contraception include:
   female and male sterilization, IUD, injectables, implants, pill, male and female condom, diaphragm, foam/jelly and LAM (lactational amenorrhea method)
     (CP3 = A-K).
* Traditional methods of contraception include:
    periodic abstinence, withdrawal, and other methods
      (CP3 = L, M, X) .
* Question CP3 allows the respondent to mention current use of more than one method.
* If more than one method is mentioned, the case is assigned to only one column of the table, in the order with which the methods appear from
  left to right.
* For example, a woman who states that she (her husband/partner) is using the male condom and withdrawal appears as a male condom user in this table.

* Note that the lactational amenorrhoea method (LAM) is not to be confused with breastfeeding (although it is a breastfeeding based method),
  during the design of questionnaires, during data collection and during analysis.
* A woman is required to meet a number of criteria in order to be considered a LAM user:
    Breastfeeding an infant less than 6 months old whose only source of nutrition is breastmilk,
    breastfeeding the infant at least every four hours during the day and at least every six hours at night,
    and not having had a period for at least 56 days after delivery .
* LAM should only be included in questionnaires if there is a LAM programme in the country, training and supervising women for the use of the method.
* The method is easily confused with breastfeeding .

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if  (mstatus = 1).

* definitions of contraceptiveMethod .
include 'define/MICS5 - 06 - RH.sps' .

variable labels contraceptiveMethod "Percent of women currently married or in union who are using (or whose partner is using):".

compute anyModern = 0.
if (contraceptiveMethod >= 1 and contraceptiveMethod <= 11) anyModern = 100.
variable labels anyModern "Any modern method".

compute anyTraditional = 0.
if (contraceptiveMethod >= 12 and contraceptiveMethod < 99) anyTraditional = 100.
variable labels anyTraditional "Any traditional method".

* Any method of contraception still includes all responses to CP3, i.e. all modern and traditional methods, as well as any missing values (CP3 = A-X or ?). 
compute anyMethod = 0.
if (anyModern = 100 or anyTraditional = 100 or  contraceptiveMethod = 99) anyMethod = 100.
variable labels anyMethod "Any method [1]".

compute livingChildren = 0.
if (CM1 = 1 and CM8 <> 1) livingChildren = CM10.
if (CM1 = 1 and CM8 = 1) livingChildren = CM10 - (CM9A + CM9B).
recode livingChildren (0 thru 3 = copy) (4 thru hi = 4).
variable labels livingChildren "Number of living children".
value labels livingChildren 4 "4+".
formats livingChildren (f5.0).

compute numWomen = 1.
variable labels numWomen "Number of women currently married or in union".
value labels numWomen 1 "".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + wage[c]
         + livingChildren [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]        
   by
           contraceptiveMethod [c] [rowpct.validn,'',f5.1]
         + anyModern [s] [mean,'',f5.1]
         + anyTraditional [s] [mean,'',f5.1]
         + anyMethod [s] [mean,'',f5.1]
         + numWomen [s] [sum,'',f5.0]
  /slabels position=column visible = no
  /title title=
     "Table RH.5: Use of contraception"
     "Percentage of women age 15-49 years currently married or in union who are using (or whose partner is using) a contraceptive method, " + surveyname
   caption=
     "[1] MICS indicator 5.3; MDG indicator 5.3 - Contraceptive prevalence rate"
  .

new file.
