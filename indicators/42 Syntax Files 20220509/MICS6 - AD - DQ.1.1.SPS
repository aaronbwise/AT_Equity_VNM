* Encoding: UTF-8.
* MICS6 SR.5.3.

***.
* v02 - 2017-09-21.
* v03 - 2020-04-14. Footnote [A] has been added. Labels in French and Spanish have been removed.


** Total weighted and unweighted numbers of children age 5-17 should be equal when normalized sample weights are used.

** The total weighted number of children age 5-17 does not necessarily match that presented on age groups 0-4 and 5-17 years in Table SR.4.1. 
** This table is based on completed children age 5-17 interviews only, whereas Table SR.4.1 is based on completed household interviews. The two tables are computed with different sample weights.


***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get file = 'hl.sav'.

* Weight the data by the household weight.
weight by hhweight.

* Recode age 85 and higher into 1 age group, and group DK and missing answers.
recode HL6 (0 thru 84 = copy ) (85 thru 96 = 85) (97 thru 99 = 99) into mage.
formats mage (f3.0).
variable labels mage "Age".
value labels mage
	85  "85+"
 	99  "DK/Missing".

value labels hl4
	1 "Males"
	2 "Females".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = hl4 display = none
  /table mage [c] + total [c] by 
            hl4[c][count,'Number',f5.0,colpct.validn,'Percent',f5.1]
  /titles title="Table DQ.1.1: Age distribution of household population"  
  "Single-year age distribution of household population [A], by sex, " + surveyname
  caption =
   "[A] As this table includes all household members listed in interviewed households, the numbers and distributions by sex do not match those shown for individuals in Tables SR.5.1W/M, SR.5.2 and SR.5.3 " +
   "where interviewed individuals are weighted with individual sample weights. Tables DQ.1.2W/M, DQ.1.3 and DQ.1.4 similarly use household sample weights and do not match distributions obtained through individual questionnaires."
.	

new file.

