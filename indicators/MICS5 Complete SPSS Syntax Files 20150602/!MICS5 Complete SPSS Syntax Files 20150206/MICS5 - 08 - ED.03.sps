* MICS5 ED-03.

* v01 - 2014-03-04.

* The denominator is the number of children who were of primary school entry age at the beginning of the current (or the most recent) school year.
* This is established by rejuvenating children to the first month of the current (or most recent) school year by using information on the date
  of birth (HL5), if available, and information on when the current (or most recent) school year began.
* If the date of birth is not available, then a full year is subtracted from the current age of the child at the time of survey (HL6),
  if the interview took place more than 6 months after the school year started.
* If the latter is less than six months and the date of birth is not available, the current age is assumed to be the same as the age at the
  beginning of the school year.

* The numerator includes those children in the denominator for whom (ED6 Level=1 and ED6 Grade=01 or 02).
* Grade 2 of primary school is accepted to take early starters into account.

* Primary school entry age is defined at the country level (usually based on UNESCO's ISCED classification).

***.

include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* include definition of primarySchoolEntryAge .
include 'define/MICS5 - 08 - ED.sps' .

select if (schage = primarySchoolEntryAge).

compute numChildren = 1.
variable labels numChildren  "".
value labels numChildren 1 "Number of children of primary school entry age".

compute firstGrade  = 0.
* Grade 2 of primary school is accepted to take into account early starters.
if (ED6A = 1 and (ED6B  = 1 or ED6B = 2)) firstGrade =  100.
variable labels firstGrade "Percentage of children of primary school entry age entering grade 1 [1]".

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
    "Table ED.3: Primary school entry"
    "Percentage of children of primary school entry age entering grade 1 (net intake rate), " + surveyname
   caption=
    "[1] MICS indicator 7.3 - Net intake rate in primary education"
  .

new file.
