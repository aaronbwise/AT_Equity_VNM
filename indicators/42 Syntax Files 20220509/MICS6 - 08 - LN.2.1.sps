* Encoding: windows-1252.

/*****************************************************************************/
/*  MICS6: Standard.
/*  Chapter 8. Learn.
/*  LN.2. Attendance.
/*  Table LN.2.1: School readiness.
/*.
/*  Reflects Tab Plan of 3 March 2021.
/*.
/*  Updates:.
/*    [20210319] - Implementing Tab Plan of 3 March 2021.
/*      - The subtitle and indicator column header have been edited.
/*    [20200414 - v02].
/*      - Footnote [A] has been added.
/*      - Labels in French and Spanish have been removed.
/*.
/*****************************************************************************/

include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* include definition of primarySchoolEntryAge .
include 'define/MICS6 - 08 - LN.sps' .

* Select children who are attending first grade of primary education regardless of age.
select if (ED10A = 1 and ED10B = 1).

/*****************************************************************************/

compute numChildren = 1.
variable labels numChildren  "".
value labels numChildren 1 "Number of children attending first grade of primary school".

compute firstGrade  = 0.
if (ED16A = 0) firstGrade =  100.
variable labels firstGrade "Percentage of children attending the first grade of primary school who attended an early childhood education programme during the previous school year [1]".

variable labels caretakerdis "Mother's functional difficulties [A]".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

/*****************************************************************************/

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = numChildren
           display = none
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
         + numChildren [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
    "Table LN.2.1: School readiness"
    "Percentage of children attending the first grade of primary school who attended an early childhood education programme during the previous school year, " + surveyname
   caption=
    "[1] MICS indicator LN.3 - School readiness"
    "[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, " +
    "i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
.

/*****************************************************************************/

new file.
