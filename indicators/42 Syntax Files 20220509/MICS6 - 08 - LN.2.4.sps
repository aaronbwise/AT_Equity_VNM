* Encoding: UTF-8.

/*****************************************************************************/
/*  MICS6: Standard.
/*  Chapter 8. Learn.
/*  LN.2. Attendance.
/*  Table LN.2.4: School attendance among children of lower secondary school age.
/*.
/*  Reflects Tab Plan of 3 March 2021.
/*.
/*  Updates:.
/*    [20210320] - Implementing Tab Plan of 3 March 2021.
/*      - The title and subtitle have been edited.
/*      - Change in defining 'outOfSchool' now ONLY ED9 = 2 (did not attend any level of education or early childhood education in the CURRENT school year).
/*      - In variable 'secondary' the label has been changed to "Net attendance rate (adjusted)".
/*      - In variable 'secondary' under 'Total' the label has been changed to "Net attendance rate (adjusted)[1]".
/*      - Table indicator note [1] has been edited to reflect the terminological change from ratio to rate.
/*      - Note [A] has been edited to reflect updated computation.
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

*All children of lower secondary school age at the beginning of the school year are included in the denominator.
select if (schage >= LowSecSchoolEntryAge and schage <= LowSecSchoolCompletionAge).

variable labels schage "Age at beginning of school year".

/*****************************************************************************/

*Children of lower secondary school age currently attending lower secondary school or higher (ED10A Level=2, 3 or 4) are included in the numerator.
compute secondary  = 0.
if (ED10A >= 2 and ED10A <= 4) secondary =  100.

*Children that did not attend school in the current school year, but have already completed lower secondary school are also included in the numerator (ED9=2 and ED5A=2 and ED5B=last grade of lower secondary school and ED6=1). 
*All children of lower secondary school age at the beginning of the school year are included in the denominator.
if (ED5A = 2 and ED5B = LowSecSchoolGrades and ED6 = 1 and ED9 = 2) secondary  = 100.

compute primary  = 0.
if (ED10A = 1) primary =  100.

*The percentage of children out of school are those who did not attend any level of education or early childhood education in the current school year (ED9=2).
*Children for whom it is not known whether they are attending school (ED9>2) are not considered out of school. 
*For this reason and because children who completed the level but are not attending school in the current school year will be in both numerators of ANAR and Out of school, the results do not necessarily sum to 100. 
compute outOfSchool = 0 .
if (ED4 = 2 or ED9 = 2) outOfSchool = 100.
* if (ED5A = 2 and ED5B = LowSecSchoolGrades and ED6 = 1 and ED9 = 2) outOfSchool  = 0.    Removed as per Tab Plan of 3 March 2021.

variable labels primary "".
variable labels secondary "".
variable labels outOfSchool "".
variable labels HL4 "".

compute layer = 1.
value labels layer 1 "Percentage of children:".

variable labels melevel "Mother's education [B]".
variable labels caretakerdis "Mother's functional difficulties [C]".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

/*****************************************************************************/

* Ctables command in English.
ctables
  /vlabels variables = hl4 secondary primary outOfSchool layer
           display = none
  /table   total [c]
         + hh6 [c]
         + hh7 [c]
         + schage [c]
         + melevel [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]
   by
           hl4 [c] > (
             secondary [s] [mean,'Net attendance rate (adjusted) [1]',f5.1]
           + layer [c] > (primary   [s] [mean,'Attending primary school',f5.1]
           + outOfSchool [s] [mean,'Out of school [2],[A]',f5.1])
           + secondary [s] [validn,'Number of children of lower secondary school age at beginning of school year',f5.0] )
  /categories variables=all empty=exclude missing=exclude
  /categories variables=hl4 total=yes position = after label = "Total"
  /slabels position=column
  /titles title=
    "Table LN.2.4: School attendance among children of lower secondary school age"
    "Percentage of children of lower secondary school age at the beginning of the school year attending lower secondary school or higher (net attendance rate, adjusted), " +
    "percentage attending primary school, and percentage out of school, by sex, " + surveyname
   caption =
    "[1] MICS indicator LN.5b - Lower secondary school net attendance rate (adjusted)"
    "[2] MICS indicator LN.6b - Out-of-school rate for adolescents of lower secondary school age"
    "[A] The percentage of children of lower secondary school age out of school are those not attending any level of education."
    "[B] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated or those age 18 at the time of interview."
    "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
.

/*****************************************************************************/

new file.
