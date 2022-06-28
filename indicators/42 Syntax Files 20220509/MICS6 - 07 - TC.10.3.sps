* Encoding: windows-1252.
* MICS6 TC - 10.4.

* v01 - 2020-04-14. Labels in French and Spanish have been removed.

 * Inadequate supervision is defined as children left alone (EC3A => 1 and EC3A <= 7) or under the supervision of 
   another child younger than 10 years of age (EC3B => 1 and EC3B <= 7) more than one hour at least once in the past week.

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* open children dataset.
get file = 'ch.sav'.

include "CommonVarsCH.sps".

* Select completed interviews.
select if (UF17 = 1).

* Weight the data by the children weight.
weight by chweight.

* generate the total.
compute numChildren = 100.
variable labels numChildren "Number of children".
value labels numChildren 100 "".

* generate the indicators.
recode EC3A  (0 = 0) (else = 100) into alone.
variable labels  alone "Left alone in the past week".

recode EC3B  (0 = 0) (else = 100) into care.
variable labels care "Left under the supervision of another child younger than 10 years of age in the past week".

compute inadeq = 0.
if (care = 100 or alone  = 100) inadeq  = 100.
variable labels inadeq "Left with inadequate supervision in the past week [1]".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of children:".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

* Ctables command in English.
ctables
  /vlabels variables = layer
           display = none
  /table   total [c]
         + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + ageGr [c]
         + melevel [c]
        + cdisability [c]
        + ethnicity [c]
        + windex5[c]
   by
           layer [c]  > ( 
             alone [s] [mean '' f5.1]
           + care [s] [mean '' f5.1]
           + inadeq [s] [mean '' f5.1] )
         + numChildren [s] [count '' f5.0]
  /categories variables=all empty=exclude
  /slabels position=column visible = no
  /titles title=
     "Table TC.10.3: Inadequate care"
     "Percentage of children under age 5 left alone or under the supervision of another child younger than 10 years of age for more than one hour at least once during the past week,  " + surveyname
   caption=
     "[1] MICS indicator TC.52 - Inadequate supervision"
  .

new file.
