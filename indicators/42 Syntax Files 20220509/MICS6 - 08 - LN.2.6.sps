* Encoding: UTF-8.

/*****************************************************************************/
/*  MICS6: Standard.
/*  Chapter 8. Learn.
/*  LN.2. Attendance.
/*  Table LN.2.6: School attendance among children of upper secondary school age.
/*.
/*  Tab Plan version: 3 March 2021.
/*.
/*  Updates:.
/*    [20210409] - Implementing Tab Plan of 3 March 2021.
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

*All children of upper secondary school age at the beginning of the school year are included in the denominator.
select if (schage >= UpSecSchoolEntryAge  and schage <= UpSecSchoolCompletionAge).

variable labels schage "Age at beginning of school year".

/*****************************************************************************/

*Children of upper secondary school age currently attending upper secondary school or higher (ED10A=3 or 4) are included in the numerator.
compute secondary  = 0.
if (ED10A >= 3 and ED10A <= 4) secondary =  100.

* Children that did not attend school in the current school year, but have already completed upper secondary school are also included in the numerator (ED9=2 and ED5A=3 and ED5B=last grade of upper secondary school and ED6=1). 
if (ED5A = 3 and ED5B = UpSecSchoolGrades and ED6 = 1 and ED9 = 2) secondary  = 100.

compute primary  = 0.
if (ED10A = 1) primary =  100.

compute lowsecondary  = 0.
if (ED10A = 2) lowsecondary =  100.

* The percentage of children out of school are those who did not attend any level of education or early childhood education in the current school year (ED9=2).
compute outOfSchool = 0 .
if (ED9 = 2 or ED4 = 2) outOfSchool = 100.
* if (ED5A = 3 and ED5B = UpSecSchoolGrades and ED6 = 1 and ED9 = 2) outOfSchool  = 0.    Removed as per Tab Plan of 3 March 2021.

variable labels melevel "Mother's education [B]".
variable labels caretakerdis "Mother's functional difficulties [C]".

variable labels primary "".
variable labels lowsecondary "".
variable labels secondary "".
variable labels outOfSchool "".
variable labels HL4 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute layer = 1.
value labels layer 1 "Percentage of children:".

/*****************************************************************************/

* Ctables command in English.
ctables
  /vlabels variables = hl4 secondary lowsecondary primary outOfSchool layer
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
           + layer [c] > (lowsecondary  [s] [mean,'Attending lower secondary school',f5.1]
           + primary   [s] [mean,'Attending primary school',f5.1]
           + outOfSchool [s] [mean,'Out of school [A]',f5.1])
           + secondary [s] [validn,'Number of children of upper secondary school age at beginning of school year',f5.0] )
  /categories variables=all empty=exclude missing=exclude
  /categories variables=hl4 total=yes position = after label = "Total"
  /slabels position=column
  /titles title=
    "Table LN.2.6: School attendance among children of upper secondary school age"
    "Percentage of children of upper secondary school age at the beginning of the school year attending upper secondary school or higher (net attendance rate, adjusted), " +
    "percentage attending lower secondary school, percentage attending primary school, and percentage out of school, by sex, " + surveyname
   caption =
    "[1] MICS indicator LN.5c - Upper secondary school net attendance rate (adjusted)"
    "[2] MICS indicator LN.6c - Out-of-school rate for youth of upper secondary school age"
    "[A] The percentage of children of upper secondary school age out of school are those not attending any level of education."
    "[B] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated or those age 18 at the time of interview."
    "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
.

/*****************************************************************************/

new file.
