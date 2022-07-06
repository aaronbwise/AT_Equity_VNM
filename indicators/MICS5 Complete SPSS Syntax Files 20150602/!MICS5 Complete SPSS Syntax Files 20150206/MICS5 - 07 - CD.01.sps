* MICS5 CD-01.

* v01 - 2014-03-04.

* Children attending early childhood education: EC5=1.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get file = 'ch.sav'.

* Select completed households.
select if (UF9  = 1).

* Select only children 36 to 59 months old.
select if ( cage >= 36 and  cage <= 59).

* Weight the data by the children weight.
weight by chweight.

* Generating age groups.
recode  cage
  (36 thru 47 = 1)
  (48 thru 59 = 2) into ageGr.
variable label ageGr 'Age of child'.
value labels ageGr
  1 '36-47 months'
  2 '48-59 months'.

compute ecedu = 0.
if (EC5 = 1) ecedu = 100.
variable labels ecedu "Percentage of children age 36-59 months attending early childhood education [1]".

* Generate total.
compute total = 1.
compute numChildren = 1.
variable labels total "Total".
value labels
  /total 1 " "
  /numChildren 1 "Number of children age 36-59 months".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable =  numChildren 
           display = none
  /table   total[c]
         + hl4 [c]
         + hh7 [c]
         + hh6 [c]
         + ageGr [c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           ecedu [s] [mean,'', f5.1]
         + numChildren [c] [count f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels visible=no
  /title title=
     "Table CD.1: Early childhood education"
     "Percentage of children age 36-59 months who are attending an organized early childhood education programme, " + surveyname
   caption=
     "[1] MICS indicator 6.1 - Attendance to early childhood education"
  .

new file.


