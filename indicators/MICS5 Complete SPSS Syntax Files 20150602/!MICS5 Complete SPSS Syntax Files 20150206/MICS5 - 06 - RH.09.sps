* MICS5 RH-09.

* v01 - 2013-03-19.

* Percentages of pregnant women whose blood pressure was measured, and pregnant women who gave urine and blood samples are calculated separately 
  and are not additive: MN4A=1, MN4B=1, MN4C=1.

* The indicator is calculated as MN4A=1 AND MN4B=1 AND MN4C=1 - for respondents satisfying all three conditions.

* The table is based on all women with a live birth in the last two years, irrespective of whether they received antenatal care or not.

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

* select women that gave birth in two years preceeding the survey.
select if (CM13 = "Y" or CM13 = "O" or CM13 = "S").


* definitions of anc, ageAtBirth .
include 'define\MICS5 - 06 - RH.sps' .

recode MN4A (1 = 100) (else = 0) into bloodPressure.
variable labels bloodPressure "Blood pressure measured".
recode MN4B (1 = 100) (else = 0) into urineSample.
variable labels urineSample "Urine sample taken".
recode MN4C (1 = 100) (else = 0) into bloodSample.
variable labels bloodSample "Blood sample taken".
compute allthree = 0.
if (bloodPressure = 100 & urineSample = 100 & bloodSample = 100) allthree = 100.
variable labels allthree "Blood pressure measured, urine and blood sample taken [1]".

compute numWomen = 1.
variable labels numWomen "Number of women with a live birth in the last two years".
value labels numWomen 1 "".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women who, during the pregnancy of their last birth, had:".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable = layer
           display = none
  /table   total [c]
         + hh7 [c] 
         + hh6 [c] 
         + ageAtBirth [c]
         + welevel [c] 
         + windex5 [c] 
         + ethnicity [c]         
   by 
           layer [c] > ( 
             bloodPressure [s] [mean,'',f5.1] 
           + urineSample [s] [mean,'',f5.1] 
           + bloodSample [s] [mean,'',f5.1]
           + allthree [s] [mean,'',f5.1] )
           + numWomen [s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /titles title=
     "Table RH.9: Content of antenatal care" 
	"Percentage of women age 15-49 years with a live birth in the last two years who, at least once, "
	"had their blood pressure measured, urine sample taken, and blood sample taken as part of antenatal care, "
	"during the pregnancy for the last birth, " + surveyname
   caption =
     "[1] MICS indicator 5.6 - Content of antenatal care"
  .

new file.
