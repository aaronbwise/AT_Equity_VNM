* Encoding: UTF-8.

/*****************************************************************************/
/*  MICS6: Standard.
/*  Chapter 8. Learn.
/*  LN.2. Attendance.
/*  Table LN.2.3: School attendance among children of primary school age.
/*.
/*  Reflects Tab Plan of 3 March 2021.
/*.
/*  Updates:.
/*    [20210320] - Implementing Tab Plan of 3 March 2021.
/*      - The title and subtitle have been edited.
/*      - Change in defining 'notAttendingSchoolPreschool' now ONLY ED9 = 2 (did not attend any level of education or early childhood education in the CURRENT school year).
/*      - Change in defining 'primary' now ED10A = 1, 2 or 3 (primary, lower or upper secondary).
/*      - In variable 'primary' the label has been changed to "Net attendance rate (adjusted)".
/*      - In variable 'primary' under 'Total' the label has been changed to "Net attendance rate (adjusted)[1]".
/*      - Table indicator note [1] has been edited to reflect the terminological change from ratio to rate.
/*      - Note [A] has been edited to reflect updated computation. 
/*    [20200414 - v02].
/*      - Subtitle has been edited, and footnote has been added.
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

variable labels schage "Age at beginning of school year".

select if (schage >= primarySchoolEntryAge and schage <= primarySchoolCompletionAge).

/*****************************************************************************/

compute primary  = 0.
if (ED10A >= 1 and ED10A <= 3)  primary =  100.

*Children that did not attend school in the current school year, but have already completed primary school are also included in the numerator (ED9=2 and ED5A=1 and ED5B=last grade of primary school and ED6=1). 
*All children of primary school age (at the beginning of the school year) are included in the denominator. 
if (ED5A = 1 and ED5B = primarySchoolGrades and ED6 = 1 and ED9 = 2) primary  = 100.

*Rates presented in this table are termed "adjusted" since they include not only primary school attendance, but also secondary school attendance in the numerator.
*The percentage of children: 
*i) Attending early childhood education are those who in the current school year have been attending early childhood education (ED10A=0).
compute attendingPreschool = 0.
if (ED10A = 0) attendingPreschool = 100 .

*ii) Out of school children are those who did not attend any level of education or early childhood education in the current school year (ED9=2).
*Children for whom it is not known whether they are attending school (ED9>2) are not considered out of school. 
*For this reason and because children who completed the level but are not attending school in the current school year will be in both numerators of ANAR and Out of school, the results do not necessarily sum to 100. 
* compute notAttendingSchoolPreschool = 0 .                                                                                                    Removed as per Tab Plan of 3 March 2021.
* if (ED9 = 2 or ED4 = 2) notAttendingSchoolPreschool = 100 .                                                                            Removed as per Tab Plan of 3 March 2021.
* if (ED5A = 1 and ED5B = primarySchoolGrades and ED6 = 1 and ED9 = 2) notAttendingSchoolPreschool  = 0.    Removed as per Tab Plan of 3 March 2021.

compute outOfSchool = 0.
if (ED4 = 2 or ED9 = 2) outOfSchool = 100.

variable labels primary "".
variable labels HL4 "".

compute layer = 1.
value labels layer 1 "Percentage of children:".

compute numChildren = 1.

variable labels caretakerdis "Mother's functional difficulties [B]".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

/*****************************************************************************/

* Ctables command in English.
ctables
  /vlabels variables = hl4 primary layer attendingPreschool outOfSchool numChildren
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
             primary [s][mean,'Net attendance rate (adjusted) [1]',f5.1]
           + layer [c] > (
               attendingPreschool [s] [mean,'Attending early childhood education',f5.1]
             + outOfSchool [s] [mean,'Out of school [A]',f5.1] )
           + numChildren [s] [validn,'Number of children of primary school age at beginning of school year'] )
  /categories variables=all empty=exclude missing=exclude
  /categories variables=hl4 total=yes position = after label = "Total"
  /slabels position=column
  /titles title=
    "Table LN.2.3: School attendance among children of primary school age"
    "Percentage of children of primary school age at the beginning of the school year attending primary, lower or upper secondary school (net attendance rate, adjusted), " +
    "percentage attending early childhood education, and percentage out of school, by sex, " + surveyname
   caption =
    "[1] MICS indicator LN.5a - Primary school net attendance rate (adjusted)"
    "[2] MICS indicator LN.6a - Out-of-school rate for children of primary school age"
    "[A] The percentage of children of primary school age out of school are those not attending any level of education."
    "[B] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years " +
    "and men age 18-49 years in selected households."
.

/*****************************************************************************/

new file.
