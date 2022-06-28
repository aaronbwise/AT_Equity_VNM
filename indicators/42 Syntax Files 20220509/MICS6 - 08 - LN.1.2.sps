* Encoding: UTF-8.

/*****************************************************************************/
/*  MICS6: Standard.
/*  Chapter 8. Learn.
/*  LN.1. Early childhood education.
/*  LN.1.2: Participation rate in organized learning (one year before the official primary entry age).
/*.
/*  Reflects Tab Plan of 3 March 2021.
/*.
/*  Updates:.
/*    [20210319] - Implementing Tab Plan of 3 March 2021.
/*      - The title and subtitles have been edited.
/*      - In variables 'notattending...' the label has been replaced.
/*      - In variables 'attendance...' the label has been changed to "Net attendance rate (adjusted) [1]".
/*      - In variable 'numChildren' the label has been changed to "Number of children age 5 years at beginning of school year".
/*      - Indicator note [1] has been updated to reflect the same in List of indicators.
/*    [20200414].
/*      - Footnote [A] has been added.
/*      - Labels in French and Spanish have been removed.
/*    [20190827 - v02] - Tab Plan of 25 July 2019 implemented.
/*.
/*****************************************************************************/

include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

include "define/MICS6 - 08 - LN.sps".

* Select children who are attending first grade of primary education regardless of age.
select if (schage = primarySchoolEntryAge - 1).

/*****************************************************************************/

compute numChildren = 1.
variable labels numChildren  "".
value labels numChildren 1 "Number of children age 5 years at beginning of school year".

*The percent distribution by education attendance is computed by response to ED9 and ED10. 
*Children not attending any level are ED9=2, children attending ECE are ED9=1 and ED10=0 and children attending primary are ED9=1 and ED10=1. 
compute ecd  = 0.
if (ED10a = 0) ecd =  100.
variable labels ecd "Attending an early childhood education programme".

compute primary  = 0.
if (ED10a = 1) primary =  100.
variable labels primary "Attending primary education".

compute notattending = 0.
if (ecd = 0 and primary = 0) notattending = 100.
variable labels notattending "Not attending any level of education (out of school)".

compute attendance = 0.
if (ecd = 100 or primary = 100) attendance = 100.
variable labels attendance "Net attendance rate (adjusted) [1]".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of children:".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute tot = 100.
variable labels tot "Total".

* Parity indices calculation.
* Sex.
aggregate outfile = * mode = addvariables overwrite = yes
  /break  = hl4
  /ecd_sex   = mean(ecd)
  /primary_sex = mean(primary)
  /notattending_sex    = mean(notattending)
  /attendance_sex = mean (attendance).

if hl4 = 2 ecd_female = ecd_sex.
if hl4 = 2 primary_female = primary_sex.
if hl4 = 2 notattending_female = notattending_sex .
if hl4 = 2 attendance_female = attendance_sex .
if hl4 = 1 ecd_male = ecd_sex.
if hl4 = 1 primary_male = primary_sex.
if hl4 = 1 notattending_male = notattending_sex .
if hl4 = 1 attendance_male = attendance_sex .

* replace missing values.
rmv /ecd_f=smean(ecd_female).
rmv /primary_f=smean(primary_female).
rmv /notattending_f=smean(notattending_female).
rmv /attendance_f=smean(attendance_female).
rmv /ecd_m=smean(ecd_male).
rmv /primary_m=smean(primary_male).
rmv /notattending_m=smean(notattending_male).
rmv /attendance_m=smean(attendance_male).

compute ecdPsex = 0.
if ecd_m>0 ecdPsex = ecd_f/ecd_m.
variable labels ecdPsex "Attending an early childhood education programme".

compute primaryPsex = 0.
if primary_m>0 primaryPsex = primary_f/primary_m.
variable labels primaryPsex "Attending primary education".

compute notattendingPsex = 0.
if notattending_m>0 notattendingPsex = notattending_f/notattending_m.
variable labels notattendingPsex "Not attending any level of education (out of school)".

compute attendancePsex = 0.
if attendance_m>0 attendancePsex = attendance_f/attendance_m.
variable labels attendancePsex "Net attendance rate (adjusted) [1]".

compute sex = 1.
variable labels sex "Sex".
value labels sex 1 "Female/male [2]".

* Parity indices calculation.
* Wealth.
aggregate outfile = * mode = addvariables overwrite = yes
  /break  = windex5
  /ecd_wealth   = mean(ecd)
  /primary_wealth = mean(primary)
  /notattending_wealth    = mean(notattending)
  /attendance_wealth = mean (attendance).

if windex5 = 1 ecd_poor = ecd_wealth.
if windex5 = 1 primary_poor = primary_wealth.
if windex5 = 1 notattending_poor = notattending_wealth .
if windex5 = 1 attendance_poor = attendance_wealth .
if windex5 = 5 ecd_rich = ecd_wealth.
if windex5 = 5 primary_rich = primary_wealth.
if windex5 = 5 notattending_rich = notattending_wealth .
if windex5 = 5 attendance_rich = attendance_wealth .

* replace missing values.
rmv /ecd_p=smean(ecd_poor).
rmv /primary_p=smean(primary_poor).
rmv /notattending_p=smean(notattending_poor).
rmv /attendance_p=smean(attendance_poor).
rmv /ecd_r=smean(ecd_rich).
rmv /primary_r=smean(primary_rich).
rmv /notattending_r=smean(notattending_rich).
rmv /attendance_r=smean(attendance_rich).

compute ecdPwealth = 0.
if ecd_r>0 ecdPwealth = ecd_p/ecd_r.
variable labels ecdPwealth "Attending an early childhood education programme".

compute primaryPwealth = 0.
if primary_r>0 primaryPwealth = primary_p/primary_r.
variable labels primaryPwealth "Attending primary education".

compute notattendingPwealth = 0.
if notattending_r>0 notattendingPwealth = notattending_p/notattending_r.
variable labels notattendingPwealth "Not attending any level of education (out of school)".

compute attendancePwealth = 0.
if attendance_r>0 attendancePwealth = attendance_p/attendance_r.
variable labels attendancePwealth "Net attendance rate (adjusted) [1]".

compute wealth = 1.
variable labels wealth "Wealth".
value labels wealth 1 "Poorest/Richest [3]".

* Parity indices calculation.
* Area.
aggregate outfile = * mode = addvariables overwrite = yes
  /break  = hh6
  /ecd_area   = mean(ecd)
  /primary_area = mean(primary)
  /notattending_area    = mean(notattending)
  /attendance_area = mean (attendance).

if hh6 = 1 ecd_urban = ecd_area.
if hh6 = 1 primary_urban = primary_area.
if hh6 = 1 notattending_urban = notattending_area .
if hh6 = 1 attendance_urban = attendance_area .
if hh6 = 2 ecd_rural = ecd_area.
if hh6 = 2 primary_rural = primary_area.
if hh6 = 2 notattending_rural = notattending_area .
if hh6 = 2 attendance_rural = attendance_area .

* replace missing values.
rmv /ecd_u=smean(ecd_urban).
rmv /primary_u=smean(primary_urban).
rmv /notattending_u=smean(notattending_urban).
rmv /attendance_u=smean(attendance_urban).
rmv /ecd_rur=smean(ecd_rural).
rmv /primary_rur=smean(primary_rural).
rmv /notattending_rur=smean(notattending_rural).
rmv /attendance_rur=smean(attendance_rural).

compute ecdParea = 0.
if ecd_rur>0 ecdParea = ecd_rur/ecd_u.
variable labels ecdParea "Attending an early childhood education programme".

compute primaryParea = 0.
if primary_rur>0 primaryParea = primary_rur/primary_u.
variable labels primaryParea "Attending primary education".

compute notattendingParea = 0.
if notattending_rur>0 notattendingParea = notattending_rur/notattending_u.
variable labels notattendingParea "Not attending any level of education (out of school)".

compute attendanceParea = 0.
if attendance_rur>0 attendanceParea = attendance_rur/attendance_u.
variable labels attendanceParea "Net attendance rate (adjusted) [1]".

compute area = 1.
variable labels area "Area".
value labels area 1 "Rural/Urban [4]".

variable labels caretakerdis "Mother's functional difficulties [A]".

/*****************************************************************************/

* Ctables command in English.
ctables
  /vlabels variables =  numChildren layer
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
           layer [c]> (ecd [s] [mean '' f5.1] + primary [s] [mean '' f5.1] + notattending [s] [mean '' f5.1]) + tot [s] [mean '' f5.1] + attendance [s] [mean '' f5.1] + numChildren [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table LN.1.2: Participation rate in organised learning (one year before the official primary entry age)"
    "Percent distribution of children age one year younger than the official primary school entry age at the beginning of the school year, " +
     "by attendance to education, and percent of children attending early childhood education or primary education (net attendance rate, adjusted), " + surveyname
   caption=
    "[1] MICS indicator LN.2 - Participation rate in organised learning (one year before the official primary entry age) (adjusted); SDG indicator 4.2.2" 
    "[2] MICS indicator LN.11a - Parity indices - organised learning (gender); SDG indicator 4.5.1"
    "[3] MICS indicator LN.11b - Parity indices - organised learning (wealth); SDG indicator 4.5.1"
    "[4] MICS indicator LN.11c - Parity indices - organised learning (area); SDG indicator 4.5.1"
    "[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, " +
    "i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
    "na: not applicable"
.

* Ctables command in English.
ctables
  /vlabels variables =  total
           display = none
  /table   sex [c]
   by
           ecdPsex [s] [mean '' f5.2] + primaryPsex [s] [mean '' f5.2] + notattendingPsex [s] [mean '' f5.2] + attendancePsex [s] [mean '' f5.2]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table LN.1.2: Participation rate in organised learning (one year before the official primary entry age)"
    "Percent distribution of children age one year younger than the official primary school entry age at the beginning of the school year, " +
     "by attendance to education, and percent of children attending early childhood education or primary education (net attendance rate, adjusted), " + surveyname
   caption=
    "[1] MICS indicator LN.2 - Participation rate in organised learning (one year before the official primary entry age) (adjusted); SDG indicator 4.2.2"
    "[2] MICS indicator LN.11a - Parity indices - organised learning (gender); SDG indicator 4.5.1"
    "[3] MICS indicator LN.11b - Parity indices - organised learning (wealth); SDG indicator 4.5.1"
    "[4] MICS indicator LN.11c - Parity indices - organised learning (area); SDG indicator 4.5.1"
    "[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, " +
    "i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
    "na: not applicable"
.

* Ctables command in English.
ctables
  /vlabels variables =  total
           display = none
  /table   wealth [c]
   by
           ecdPwealth [s] [mean '' f5.2] + primaryPwealth [s] [mean '' f5.2] + notattendingPwealth [s] [mean '' f5.2] + attendancePwealth [s] [mean '' f5.2]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table LN.1.2: Participation rate in organised learning (one year before the official primary entry age)"
    "Percent distribution of children age one year younger than the official primary school entry age at the beginning of the school year, " +
     "by attendance to education, and percent of children attending early childhood education or primary education (net attendance rate, adjusted), " + surveyname
   caption=
    "[1] MICS indicator LN.2 - Participation rate in organised learning (one year before the official primary entry age) (adjusted); SDG indicator 4.2.2"
    "[2] MICS indicator LN.11a - Parity indices - organised learning (gender); SDG indicator 4.5.1"
    "[3] MICS indicator LN.11b - Parity indices - organised learning (wealth); SDG indicator 4.5.1"
    "[4] MICS indicator LN.11c - Parity indices - organised learning (area); SDG indicator 4.5.1"
    "[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, " +
    "i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
    "na: not applicable"
.

* Ctables command in English.
ctables
  /vlabels variables =  total
           display = none
  /table   area [c]
   by
           ecdParea [s] [mean '' f5.2] + primaryParea [s] [mean '' f5.2] + notattendingParea [s] [mean '' f5.2] + attendanceParea [s] [mean '' f5.2]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table LN.1.2: Participation rate in organised learning (one year before the official primary entry age)"
    "Percent distribution of children age one year younger than the official primary school entry age at the beginning of the school year, " +
     "by attendance to education, and percent of children attending early childhood education or primary education (net attendance rate, adjusted), " + surveyname
   caption=
    "[1] MICS indicator LN.2 - Participation rate in organised learning (one year before the official primary entry age) (adjusted); SDG indicator 4.2.2"
    "[2] MICS indicator LN.11a - Parity indices - organised learning (gender); SDG indicator 4.5.1"
    "[3] MICS indicator LN.11b - Parity indices - organised learning (wealth); SDG indicator 4.5.1"
    "[4] MICS indicator LN.11c - Parity indices - organised learning (area); SDG indicator 4.5.1"
    "[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, " +
    "i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
    "na: not applicable"
.

/*****************************************************************************/

new file.
