* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get file = 'hl.sav'.

* Weight the data by the household weight.
weight by hhweight.

* Recode age 85 and higher into 1 age group, and group DK and missing answers.
recode HL6 (0 thru 84 = copy ) (85 thru 96 = 85) (97 thru 99 = 99) into mage.
format mage (f3.0).
variable labels mage "Age".
value labels mage
	85  "85+"
 	99  "DK/missing".

variable labels hl4 'Sex'.
value labels hl4
	1 "Males"
	2 "Females".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

ctables
  /vlabels variables = hl4 display = none
  /table mage [c] + total [c] by 
            hl4[c][count,'Number',f5.0,colpct.validn,'Percent',f5.1]
  /titles title="Table DQ.1: Age distribution of household population"  
  "Single-year age distribution of household population by sex, " + surveyname.											

new file.

