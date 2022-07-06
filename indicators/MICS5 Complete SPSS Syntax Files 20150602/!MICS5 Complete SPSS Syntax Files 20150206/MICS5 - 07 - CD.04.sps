* MICS5 CD-04.

* v01 - 2014-03-17.

* Inadequate care is defined as children left alone (EC3A => 1 and EC3A <= 7) or in the care
  of another child younger than 10 years of age (EC3B => 1 and EC3B <= 7) more than one hour
  at least once in the past week.

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* open children dataset.
get file = 'ch.sav'.

* Select completed interviews.
select if (UF9 = 1).

* Weight the data by the children weight.
weight by chweight.

* generate the total.
compute numChildren = 100.
variable labels numChildren "Number of children under age 5".
value labels numChildren 100 "".

* generate the background variable agegrp.
recode cage (0 thru 23 = 1) (else = 2) into agegrp .
variable labels agegrp "Age".
value labels agegrp 1 "0-23" 2 "24-59".

* generate the indicators.
recode EC3A  (0 = 0) (else = 100) into alone.
variable labels  alone "Left alone in the past week".

recode EC3B  (0 = 0) (else = 100) into care.
variable labels care "Left in the care of another child younger than 10 years of age in the past week".

compute inadeq = 0.
if (care = 100 or alone  = 100) inadeq  = 100.
variable labels inadeq "Left with inadequate care in the past week [1]".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of children under age 5".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer
           display = none
  /table   total [c]
         + hl4 [c]
         + hh7 [c]
         + hh6 [c]
         + agegrp [c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           layer [c]  > ( 
             alone [s] [mean,'',f5.1]
           + care [s] [mean,'',f5.1]
           + inadeq [s] [mean,'',f5.1] )
         + numChildren [s] [count,'',f5.0]
  /categories var=all empty=exclude
  /slabels position=column visible = no
  /title title=
     "Table CD.4: Inadequate care"
     "Percentage of children under age 5 left alone or left in the care of another child younger " +
     "than 10 years of age for more than one hour at least once during the past week, " + surveyname
   caption=
     "[1] MICS indicator 6.7 - Inadequate care"
  .

new file.
