* Encoding: UTF-8.

/*****************************************************************************/
/*  MICS6: Standard.
/*  Chapter 8. Learn.
/*  LN.2. Attendance.
/*  Table LN.2.5: Age for grade.
/*.
/*  Tab Plan version: 3 March 2021.
/*.
/*  Updates:.
/*    [20210320] - Implementing Tab Plan of 3 March 2021.
/*      - In the subtitle, "attended" has been added to the end.
/*    [???????? - v03].
/*      - calculation of "ageP "Primary school: Percent of children by grade of attendance:"" and "ageLS "Lower secondary school: Percent of children by grade of attendance:"." corrected to be aligned with the indicator definition.
/*    [20200414 - v02].
/*      - Subtitle and existing footnotes have been edited, and footnote has been added.
/*      - Labels in French and Spanish have been removed.
/*.
/*****************************************************************************/

include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* Select children who are of primary school age; this definition is
* country-specific and should be changed to reflect the situation in your
* country.

* include definition of primarySchoolEntryAge .
include 'define/MICS6 - 08 - LN.sps' .

/*****************************************************************************/

* Children attending primary school.
do if (ED10A = 1).

compute grade = ED10B.
compute ageForGrade = primarySchoolEntryAge+grade-1.

compute ageP = 0.
if (schage < ageForGrade) ageP = 1.
if (schage = ageForGrade) ageP = 2.
if (schage = ageForGrade + 1) ageP = 3.
if (schage > ageForGrade + 1) ageP = 4.

variable labels ageP "Primary school: Percent of children by grade of attendance:".
value labels ageP 1 "Under-age"  2 "At official age" 3 "Over-age by 1 year  " 4 "Over-age by 2 or more [1]".

compute numPrimary = 1.
variable labels numPrimary "Number of children attending primary school".

end if.

* Children attending lower secondary school.
do if (ED10A = 2).

compute gradeLS = ED10B.
compute ageForGradeLS = LowSecSchoolEntryAge+gradeLS-1.

compute ageLS = 0.
if (schage < ageForGradeLS) ageLS = 1.
if (schage = ageForGradeLS) ageLS = 2.
if (schage = ageForGradeLS + 1) ageLS = 3.
if (schage > ageForGradeLS + 1) ageLS = 4.

variable labels ageLS "Lower secondary school: Percent of children by grade of attendance:".
value labels ageLS 1 "Under-age"  2 "At official age" 3 "Over-age by 1 year" 4 "Over-age by 2 or more [2]".

compute numSecondary = 1.
variable labels numSecondary "Number of children attending lower secondary school".

end if.

variable labels melevel "Mother's education [A]".
variable labels caretakerdis "Mother's functional difficulties [B]".

recode ED10B (8 thru hi = sysmis) (else = copy).

variable labels ED10B "Grade".
value labels ED10B
1 "1 (primary/lower secondary)"
2 "2 (primary/lower secondary)"
3 "3 (primary/lower secondary)"
4 "4 (primary)"
5 "5 (primary)"
6 "6 (primary)"
7 "7 (primary)"
.

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

/*****************************************************************************/

* Ctables command in English.
ctables
  /format missing = "na"
  /vlabels variables = numPrimary numSecondary
           display = none
  /table   total [c]
         + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + melevel [c]
         + ED10B [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]
   by
             ageP[c] [rowpct.validn '' f5.1]
           + numPrimary [s] [validn,'Number of children attending primary school',f5.0]
           + ageLS [c] [rowpct.validn '' f5.1]
           + numSecondary [s] [validn,'Number of children attending lower secondary school',f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=ageP ageLS total=yes position = after label = "Total"
  /slabels position=column
  /titles title=
     "Table LN.2.5: Age for grade"
     "Percent distribution of children attending primary and lower secondary school who are underage, at official age and overage by 1 and by 2 or more years for grade attended, " + surveyname
   caption =
          "[1] MICS indicator LN.10a - Over-age for grade (Primary)"
          "[2] MICS indicator LN.10b - Over-age for grade (Lower secondary)"
          "[A] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated or those age 18 at the time of interview."
          "[B] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
          "na: not applicable"
.

/*****************************************************************************/

new file.
