* MICS5 ED-02.

* v01 - 2014-03-04.

* The numerator includes children for whom:
    ED6A Level=1 and ED6B Grade=01 and ED8A Level=0.

* The denominator is the number of children attending first grade of primary school (ED6A Level=1 and ED6B Grade=01) regardless of age.

***.


include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* Select children who are attending first grade of primary education regardless of age.
select if (ED6A = 1 and ED6B = 1).

compute numChildren = 1.
variable labels numChildren  "".
value labels numChildren 1 "Number of children attending first grade of primary school".

compute firstGrade  = 0.
if (ED8A = 0) firstGrade =  100.
variable labels firstGrade "Percentage of children attending first grade who attended preschool in previous year [1]".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = numChildren
           display = none
  /table   total [c]
         + hl4 [c]
         + hh7 [c]
         + hh6 [c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           firstGrade [s] [mean,'',f5.1]
         + numChildren [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
    "Table ED.2: School readiness"
    "Percentage of children attending first grade of primary school who attended pre-school the previous year, " + surveyname
   caption=
    "[1] MICS indicator 7.2 - School readiness"
  .

new file.
