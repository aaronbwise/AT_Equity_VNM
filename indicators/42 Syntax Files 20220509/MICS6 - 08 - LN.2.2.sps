* Encoding: windows-1252.

***.

* v02 - 2020-04-14. Footnote A has been added. Labels in French and Spanish have been removed.include "surveyname.sps".
***.

include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* include definition of primarySchoolEntryAge .
include 'define/MICS6 - 08 - LN.sps' .

select if (schage = primarySchoolEntryAge).

compute numChildren = 1.
variable labels numChildren  "Number of children of primary school entry age".
value labels numChildren 1 "".

compute firstGrade  = 0.
* Grade 2 of primary school is accepted to take into account early starters.
if (ED10A = 1 and (ED10B  = 1 or ED10B = 2)) firstGrade =  100.
variable labels firstGrade "Percentage of children of primary school entry age entering grade 1 [1]".

variable labels caretakerdis "Mother's functional difficulties [A]".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table   total [c]
         + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + melevel [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]
   by
           firstGrade [s] [mean '' f5.1]
         + numChildren [s] [sum '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
    "Table LN.2.2: Primary school entry"	
    "Percentage of children of primary school entry age entering grade 1 (net intake rate), " + surveyname
   caption=
    "[1] MICS indicator LN.4 - Net intake rate in primary education"
    "[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."	
  .	


new file.
