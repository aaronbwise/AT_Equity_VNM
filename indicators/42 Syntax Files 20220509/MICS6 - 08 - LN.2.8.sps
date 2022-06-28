* Encoding: UTF-8.

/*****************************************************************************/
/*  MICS6: Standard.
/*  Chapter 8. Learn.
/*  LN.2. Attendance.
/*  Table LN.2.8: Parity indices.
/*.
/*  Tab Plan version: 3 March 2021.
/*.
/*  Updates:.
/*    [20210415] - Implementing Tab Plan of 3 March 2021.
/*      - The subtitle has been edited.
/*      - All column headers have been edited. 
/*    [20200909 - v04].
/*      - Updated definition of orphanhood status in line with the table SR.11.2.
/*    [20200414 - v03].
/*      - Footnote has been added.
/*      - Labels in French and Spanish have been removed.
/*    [20190827 - v02].
/*      - Last modified to reflect tab plan changes as of 25 July 2019.
/*.
/*****************************************************************************/

include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* include definition of primarySchoolEntryAge .
include 'define/MICS6 - 08 - LN.sps' .

/*****************************************************************************/

* Orphanhood: ANAR of children whose mother and father have died (HL12=2 and HL16=2) divided by ANAR of children whose parents are alive and who are living with at least one parent: (HL12=1 and HL16=1) and (HL13=1 or HL17=1). 
* This row is included in the standard to accommodate a need for continuing presentation of data related to the MDG indicator. 
* It should be noted that the MDG was measured on the age group of 10-14 alone, whereas this replacing measure is on adjusted NAR for each of the three levels of education. 
* Similarly to the MDG, it is expected that the number of orphans in many surveys will be too few to calculate. 
* The syntax produces the background characteristic of "Orphanhood", but this should not be presented in the table and is only included for the purpose of manually computing the parity.
* Note that definition of orphanhood is different in this table compared to LN tables.

compute orphanStatus = 9.
if (HL12 = 2 and HL16 = 2) orphanStatus=1.
if (HL12 = 1 and HL16 = 1) and (HL13 = 1 or HL17 = 1) orphanStatus = 2.
if (HL12 >= 8 or HL16 >= 8) orphanStatus=9.
variable labels orphanStatus "Orphanhood status".
value labels orphanStatus
1 "Orphans (not to be presented in the table - needed for parity indices)"
2 "Non-Orphans (not to be presented in the table - needed for parity indices)"
9 "Unknown (not to be presented in the table - needed for parity indices)".

compute total = 1.
variable labels total "".
value labels total 1 "Total [3]".

compute AgedForPrimary = 0.
if (schage >= primarySchoolEntryAge and schage <= primarySchoolCompletionAge) AgedForPrimary = 1.
variable labels AgedForPrimary "Number of primary school age children".

compute AttendingPrimary = 0.
if (AgedForPrimary = 1 and ED10A >= 1 and ED10A <= 2) AttendingPrimary = 1.
if (AgedForPrimary = 1 and ED5A = 1 and ED5B = primarySchoolGrades and ED6 = 1 and ED9 = 2) AttendingPrimary  = 1.
variable labels AttendingPrimary "Number of primary school age children attending primary school".

compute boysAgedForPrimary = 0.
if (HL4 = 1 and AgedForPrimary = 1) boysAgedForPrimary = 1.
variable labels boysAgedForPrimary "Number of primary school age boys".

compute boysAttendingPrimary = 0.
if (boysAgedForPrimary = 1 and AttendingPrimary = 1) boysAttendingPrimary = 1.
variable labels boysAttendingPrimary "Number of primary school age boys attending primary school".

compute girlsAgedForPrimary = 0.
if (HL4 = 2 and AgedForPrimary = 1) girlsAgedForPrimary = 1.
variable labels girlsAgedForPrimary "Number of primary school age girls".

compute girlsAttendingPrimary = 0.
if (girlsAgedForPrimary = 1 and AttendingPrimary = 1) girlsAttendingPrimary = 1.
variable labels girlsAttendingPrimary "Number of primary school age girls attending primary school".

compute AgedForLowSec = 0.
if (schage >= LowSecSchoolEntryAge and schage <= LowSecSchoolCompletionAge) AgedForLowSec = 1.
variable labels AgedForLowSec "Number of lower secondary school age children".

compute AttendingLowSec = 0.
if (AgedForLowSec = 1 and ED10A >= 2 and ED10A <= 4) AttendingLowSec = 1.
if (AgedForLowSec = 1 and ED5A = 2 and ED5B = LowSecSchoolGrades and ED6 = 1 and ED9 = 2) AttendingLowSec = 1.
variable labels AttendingLowSec "Number of lower secondary school age children attending secondary school".

compute boysAgedForLowSec = 0.
if (HL4 = 1 and schage >= LowSecSchoolEntryAge and schage <= LowSecSchoolCompletionAge) boysAgedForLowSec = 1.
variable labels boysAgedForLowSec "Number of lower secondary school age boys".

compute boysAttendingLowSec = 0.
if (boysAgedForLowSec = 1 and AttendingLowSec = 1) boysAttendingLowSec = 1.
variable labels boysAttendingLowSec "Number of lower secondary school age boys attending secondary school".

compute girlsAgedForLowSec = 0.
if (HL4 = 2 and schage >= LowSecSchoolEntryAge and schage <= LowSecSchoolCompletionAge) girlsAgedForLowSec = 1.
variable labels girlsAgedForLowSec "Number of lower secondary school age girls".

compute girlsAttendingLowSec  = 0.
if (girlsAgedForLowSec = 1 and AttendingLowSec = 1) girlsAttendingLowSec =  1.
variable labels girlsAttendingLowSec "Number of lower secondary school age girls attending secondary school".

compute AgedForUpSec = 0.
if (schage >= UpSecSchoolEntryAge and schage <= UpSecSchoolCompletionAge) AgedForUpSec = 1.
variable labels AgedForUpSec "Number of upper secondary school age children".

compute AttendingUpSec = 0.
if (AgedForUpSec = 1 and ED10A >= 3 and ED10A <= 4) AttendingUpSec = 1.
if (AgedForUpSec = 1 and ED5A = 3 and ED5B = UpSecSchoolGrades and ED6 = 1 and ED9 = 2) AttendingUpSec = 1.
variable labels AttendingUpSec "Number of upper secondary school age children attending secondary school".

compute boysAgedForUpSec = 0.
if (HL4 = 1 and AgedForUpSec = 1) boysAgedForUpSec = 1.
variable labels boysAgedForupSec "Number of upper secondary school age boys".

compute boysAttendingUpSec = 0.
if (boysAgedForUpSec = 1 and AttendingUpSec = 1) boysAttendingUpSec = 1.
variable labels boysAttendingUpSec "Number of upper secondary school age boys attending secondary school".

compute girlsAgedForUpSec = 0.
if (HL4 = 2 and AgedForUpSec = 1) girlsAgedForUpSec = 1.
variable labels girlsAgedForUpSec "Number of upper secondary school age girls".

compute girlsAttendingUpSec  = 0.
if (girlsAgedForUpSec = 1 and AttendingUpSec = 1) girlsAttendingUpSec =  1.
variable labels girlsAttendingUpSec "Number of upper secondary school age girls attending secondary school".

/*****************************************************************************/

aggregate outfile = 'tmp1.sav'
  /break   = total
  /AgedForPrimary      = sum(AgedForPrimary)
  /AttendingPrimary    = sum(AttendingPrimary)
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /AgedForLowSec    = sum(AgedForLowSec)
  /AttendingLowSec  = sum(AttendingLowSec)
  /boysAgedForLowSec    = sum(boysAgedForLowSec)
  /boysAttendingLowSec  = sum(boysAttendingLowSec)
  /girlsAgedForLowSec   = sum(girlsAgedForLowSec)
  /girlsAttendingLowSec = sum(girlsAttendingLowSec)
  /boysAgedForUpSec   = sum(boysAgedForUpSec)
  /AttendingUpSec  = sum(AttendingUpSec)
  /AgedForUpSec   = sum(AgedForUpSec)
  /boysAttendingUpSec  = sum(boysAttendingUpSec)
  /girlsAgedForUpSec   = sum(girlsAgedForUpSec)
  /girlsAttendingUpSec = sum(girlsAttendingUpSec).

aggregate outfile = 'tmp2.sav'
  /break   = HL4
  /AgedForPrimary      = sum(AgedForPrimary)
  /AttendingPrimary    = sum(AttendingPrimary)
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /AgedForLowSec    = sum(AgedForLowSec)
  /AttendingLowSec  = sum(AttendingLowSec)
  /boysAgedForLowSec    = sum(boysAgedForLowSec)
  /boysAttendingLowSec  = sum(boysAttendingLowSec)
  /girlsAgedForLowSec   = sum(girlsAgedForLowSec)
  /girlsAttendingLowSec = sum(girlsAttendingLowSec)
  /boysAgedForUpSec   = sum(boysAgedForUpSec)
  /AttendingUpSec  = sum(AttendingUpSec)
  /AgedForUpSec   = sum(AgedForUpSec)
  /boysAttendingUpSec  = sum(boysAttendingUpSec)
  /girlsAgedForUpSec   = sum(girlsAgedForUpSec)
  /girlsAttendingUpSec = sum(girlsAttendingUpSec).

aggregate outfile = 'tmp3.sav'
  /break   = HH7
  /AgedForPrimary      = sum(AgedForPrimary)
  /AttendingPrimary    = sum(AttendingPrimary)
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /AgedForLowSec    = sum(AgedForLowSec)
  /AttendingLowSec  = sum(AttendingLowSec)
  /boysAgedForLowSec    = sum(boysAgedForLowSec)
  /boysAttendingLowSec  = sum(boysAttendingLowSec)
  /girlsAgedForLowSec   = sum(girlsAgedForLowSec)
  /girlsAttendingLowSec = sum(girlsAttendingLowSec)
  /boysAgedForUpSec   = sum(boysAgedForUpSec)
  /AttendingUpSec  = sum(AttendingUpSec)
  /AgedForUpSec   = sum(AgedForUpSec)
  /boysAttendingUpSec  = sum(boysAttendingUpSec)
  /girlsAgedForUpSec   = sum(girlsAgedForUpSec)
  /girlsAttendingUpSec = sum(girlsAttendingUpSec).

aggregate outfile = 'tmp5.sav'
  /break   = HH6
  /AgedForPrimary      = sum(AgedForPrimary)
  /AttendingPrimary    = sum(AttendingPrimary)
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /AgedForLowSec    = sum(AgedForLowSec)
  /AttendingLowSec  = sum(AttendingLowSec)
  /boysAgedForLowSec    = sum(boysAgedForLowSec)
  /boysAttendingLowSec  = sum(boysAttendingLowSec)
  /girlsAgedForLowSec   = sum(girlsAgedForLowSec)
  /girlsAttendingLowSec = sum(girlsAttendingLowSec)
  /boysAgedForUpSec   = sum(boysAgedForUpSec)
  /AttendingUpSec  = sum(AttendingUpSec)
  /AgedForUpSec   = sum(AgedForUpSec)
  /boysAttendingUpSec  = sum(boysAttendingUpSec)
  /girlsAgedForUpSec   = sum(girlsAgedForUpSec)
  /girlsAttendingUpSec = sum(girlsAttendingUpSec).

aggregate outfile = 'tmp6.sav'
  /break   = melevel
  /AgedForPrimary      = sum(AgedForPrimary)
  /AttendingPrimary    = sum(AttendingPrimary)
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /AgedForLowSec    = sum(AgedForLowSec)
  /AttendingLowSec  = sum(AttendingLowSec)
  /boysAgedForLowSec    = sum(boysAgedForLowSec)
  /boysAttendingLowSec  = sum(boysAttendingLowSec)
  /girlsAgedForLowSec   = sum(girlsAgedForLowSec)
  /girlsAttendingLowSec = sum(girlsAttendingLowSec)
  /boysAgedForUpSec   = sum(boysAgedForUpSec)
  /AttendingUpSec  = sum(AttendingUpSec)
  /AgedForUpSec   = sum(AgedForUpSec)
  /boysAttendingUpSec  = sum(boysAttendingUpSec)
  /girlsAgedForUpSec   = sum(girlsAgedForUpSec)
  /girlsAttendingUpSec = sum(girlsAttendingUpSec).

aggregate outfile = 'tmp7.sav'
  /break   = windex5
  /AgedForPrimary      = sum(AgedForPrimary)
  /AttendingPrimary    = sum(AttendingPrimary)
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /AgedForLowSec    = sum(AgedForLowSec)
  /AttendingLowSec  = sum(AttendingLowSec)
  /boysAgedForLowSec    = sum(boysAgedForLowSec)
  /boysAttendingLowSec  = sum(boysAttendingLowSec)
  /girlsAgedForLowSec   = sum(girlsAgedForLowSec)
  /girlsAttendingLowSec = sum(girlsAttendingLowSec)
  /boysAgedForUpSec   = sum(boysAgedForUpSec)
  /AttendingUpSec  = sum(AttendingUpSec)
  /AgedForUpSec   = sum(AgedForUpSec)
  /boysAttendingUpSec  = sum(boysAttendingUpSec)
  /girlsAgedForUpSec   = sum(girlsAgedForUpSec)
  /girlsAttendingUpSec = sum(girlsAttendingUpSec).

aggregate outfile = 'tmp8.sav'
  /break   = ethnicity
  /AgedForPrimary      = sum(AgedForPrimary)
  /AttendingPrimary    = sum(AttendingPrimary)
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /AgedForLowSec    = sum(AgedForLowSec)
  /AttendingLowSec  = sum(AttendingLowSec)
  /boysAgedForLowSec    = sum(boysAgedForLowSec)
  /boysAttendingLowSec  = sum(boysAttendingLowSec)
  /girlsAgedForLowSec   = sum(girlsAgedForLowSec)
  /girlsAttendingLowSec = sum(girlsAttendingLowSec)
  /boysAgedForUpSec   = sum(boysAgedForUpSec)
  /AttendingUpSec  = sum(AttendingUpSec)
  /AgedForUpSec   = sum(AgedForUpSec)
  /boysAttendingUpSec  = sum(boysAttendingUpSec)
  /girlsAgedForUpSec   = sum(girlsAgedForUpSec)
  /girlsAttendingUpSec = sum(girlsAttendingUpSec).

aggregate outfile = 'tmp9.sav'
  /break   = caretakerdis
  /AgedForPrimary      = sum(AgedForPrimary)
  /AttendingPrimary    = sum(AttendingPrimary)
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /AgedForLowSec    = sum(AgedForLowSec)
  /AttendingLowSec  = sum(AttendingLowSec)
  /boysAgedForLowSec    = sum(boysAgedForLowSec)
  /boysAttendingLowSec  = sum(boysAttendingLowSec)
  /girlsAgedForLowSec   = sum(girlsAgedForLowSec)
  /girlsAttendingLowSec = sum(girlsAttendingLowSec)
  /boysAgedForUpSec   = sum(boysAgedForUpSec)
  /AttendingUpSec  = sum(AttendingUpSec)
  /AgedForUpSec   = sum(AgedForUpSec)
  /boysAttendingUpSec  = sum(boysAttendingUpSec)
  /girlsAgedForUpSec   = sum(girlsAgedForUpSec)
  /girlsAttendingUpSec = sum(girlsAttendingUpSec).

aggregate outfile = 'tmp10.sav'
  /break   = orphanStatus
  /AgedForPrimary      = sum(AgedForPrimary)
  /AttendingPrimary    = sum(AttendingPrimary)
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /AgedForLowSec    = sum(AgedForLowSec)
  /AttendingLowSec  = sum(AttendingLowSec)
  /boysAgedForLowSec    = sum(boysAgedForLowSec)
  /boysAttendingLowSec  = sum(boysAttendingLowSec)
  /girlsAgedForLowSec   = sum(girlsAgedForLowSec)
  /girlsAttendingLowSec = sum(girlsAttendingLowSec)
  /boysAgedForUpSec   = sum(boysAgedForUpSec)
  /AttendingUpSec  = sum(AttendingUpSec)
  /AgedForUpSec   = sum(AgedForUpSec)
  /boysAttendingUpSec  = sum(boysAttendingUpSec)
  /girlsAgedForUpSec   = sum(girlsAgedForUpSec)
  /girlsAttendingUpSec = sum(girlsAttendingUpSec).

get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'
  /file = 'tmp7.sav'
  /file = 'tmp8.sav'
  /file = 'tmp9.sav'
  /file = 'tmp10.sav'
.

/*****************************************************************************/

if (AgedForPrimary > 0) pnar = (AttendingPrimary / AgedForPrimary) * 100.
variable labels pnar "Primary school adjusted net attendance rate (ANAR), total [1],[2]".

if (girlsAgedForPrimary > 0) pgirls = (girlsAttendingPrimary / girlsAgedForPrimary) * 100.
variable labels pgirls "Primary school adjusted net attendance rate (ANAR), girls".

if (boysAgedForPrimary > 0)  pboys  = (boysAttendingPrimary / boysAgedForPrimary) * 100.
variable labels pboys "Primary school adjusted net attendance rate (ANAR), boys".

if (pboys > 0) primaryGPI = (pgirls/pboys).
variable labels primaryGPI "Gender parity index (GPI) for primary school ANAR [3]".

if (AgedForLowSec > 0) lnar = (AttendingLowSec / AgedForLowSec) * 100.
variable labels lnar "Lower secondary school adjusted net attendance rate (ANAR), total [1],[2]".

if (girlsAgedForLowSec > 0) lgirls = (girlsAttendingLowSec / girlsAgedForLowSec) * 100.
variable labels lgirls "Lower secondary school adjusted net attendance rate (ANAR), girls".

if (boysAgedForLowSec > 0)  lboys  = (boysAttendingLowSec / boysAgedForLowSec) * 100.
variable labels lboys "Lower secondary school adjusted net attendance rate (ANAR), boys".

if (lboys > 0) lowsecondaryGPI = (lgirls/lboys).
variable labels lowsecondaryGPI "Gender parity index (GPI) for lower secondary school ANAR [3]".

if (AgedForUpSec > 0) unar = (AttendingUpSec / AgedForUpSec) * 100.
variable labels unar "Upper secondary school adjusted net attendance rate (ANAR), total [1],[2]".

if (girlsAgedForUpSec > 0) ugirls = (girlsAttendingUpSec / girlsAgedForUpSec) * 100.
variable labels ugirls "Upper secondary school adjusted net attendance rate (ANAR), girls".

if (boysAgedForUpSec > 0)  uboys  = (boysAttendingUpSec / boysAgedForUpSec) * 100.
variable labels uboys "Upper secondary school adjusted net attendance rate (ANAR), boys".

if (uboys > 0) upsecondaryGPI = (ugirls/uboys).
variable labels upsecondaryGPI "Gender parity index (GPI) for upper secondary school ANAR [3]".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Primary".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Lower secondary".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Upper secondary".

variable labels melevel "Mother's education [A]".
variable labels caretakerdis "Mother's functional difficulties [B]".

/*****************************************************************************/

* Ctables command in English.
ctables
  /format missing = "na"
  /vlabels variables = layer layer1 layer2 total
           display = none
  /table   total [c]
         + hh6[c]
         + hh7[c]
         + melevel [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]
         + orphanStatus [c]
   by
           layer [c]>(pgirls [s] [mean '' f5.1]
         + pboys [s] [mean '' f5.1]
         + pnar [s] [mean '' f5.1]
         + primaryGPI [s] [mean '' f5.2])
         + layer1 [c]>(lgirls [s] [mean '' f5.1]
         + lboys [s] [mean '' f5.1]
         + lnar [s] [mean '' f5.1]
         + lowsecondaryGPI [s] [mean '' f5.2])
         + layer2 [c]>(ugirls [s] [mean '' f5.1]
         + uboys [s] [mean '' f5.1]
         + unar [s] [mean '' f5.1]
         + upsecondaryGPI [s] [mean '' f5.2])
  /categories variables=all empty=exclude missing=exclude
  /slabels visible=no
  /titles title=
    "Table LN.2.8: Parity indices"
    "Ratio of adjusted net attendance rates of girls to boys, in primary, lower and upper secondary school, and additional parity indices, " + surveyname
  caption=
    "[1] MICS indicator LN.11b - Parity indices - primary, lower and upper secondary attendance (wealth); SDG indicator 4.5.1   "
    "[2] MICS indicator LN.11c - Parity indices - primary, lower and upper secondary attendance (area); SDG indicator 4.5.1"
    "[3] MICS indicator LN.11a - Parity indices - primary, lower and upper secondary attendance (gender); SDG indicator 4.5.1"
    "[A] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated or those age 18 at the time of interview. " +
    "The sum of cases in the disaggregate may not equal the total denominator."
    "[B] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
    "na: not applicable"
.

* Auxillary table with denominators. Uncomment when running unweighted tables (not for printing).
*ctables
   /format missing = "na"
  /vlabels variables = total
           display = none
  /table   total [c]
         + hh7[c]
         + hh6[c]
         + melevel [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]
         + orphanStatus [c]
   by
   layer [c] > (pgirls [s][mean '' f5.1] + girlsAgedForPrimary [s][sum '' f5.0]
         + pboys [s][mean '' f5.1] + boysAgedForPrimary [s][sum '' f5.0]
         + pnar [s][mean '' f5.1] + AgedForPrimary [s][sum '' f5.0]
         + primaryGPI [s][mean '' f5.2])
         + layer1 [c] > (lgirls [s][mean '' f5.1] + girlsAgedForLowSec [s][sum '' f5.0]
         + lboys [s][mean '' f5.1] + boysAgedForLowSec [s][sum '' f5.0]
         + lnar [s][mean '' f5.1] + AgedForLowSec [s][sum '' f5.0]
         + lowsecondaryGPI [s][mean '' f5.2])
         + layer2 [c] > (ugirls [s][mean '' f5.1] + girlsAgedForUpSec [s][sum '' f5.0]
         + uboys [s][mean '' f5.1] + boysAgedForUpSec [s][sum '' f5.0]
         + unar [s][mean '' f5.1] + AgedForUpSec [s][sum '' f5.0]
         + upsecondaryGPI [s][mean '' f5.2])
  /categories variables=all empty=exclude missing=exclude
  /slabels visible=no
   /titles title=
    "Table LN.2.8: Auxillary table with denominators when run unweighted (not for printing)"
    "Ratio of adjusted net attendance rates of girls to boys, in primary, lower and upper secondary school, and additional parity indices, " + surveyname
  caption=
    "[1] MICS indicator LN.11b - Parity indices - primary, lower and upper secondary attendance (wealth); SDG indicator 4.5.1   "
    "[2] MICS indicator LN.11c - Parity indices - primary, lower and upper secondary attendance (area); SDG indicator 4.5.1"
    "[3] MICS indicator LN.11a - Parity indices - primary, lower and upper secondary attendance (gender); SDG indicator 4.5.1"
    "[A] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated or those age 18 at the time of interview. " +
    "The sum of cases in the disaggregate may not equal the total denominator."
    "[B] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
    "na: not applicable"
.

/*****************************************************************************/

new file.

*delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.
erase file = 'tmp7.sav'.
erase file = 'tmp8.sav'.
erase file = 'tmp9.sav'.
erase file = 'tmp10.sav'.
