* MICS5 ED-08.

* v01 - 2014-03-04.
* v02 - 2014-04-22.

* The gender parity index (GPI) is the ratio of female to male adjusted net attendance ratios (primary or secondary).
* The primary and secondary adjusted net attendance ratios are presented in more detail in tables ED_4 and ED_5.

* The numerators and denominators of all of the ratios in this table can be found in Tables ED_4 and ED_5.
* The unweighted denominators in those tables should be checked before this table is produced.
* Detailed information on reporting conventions regarding numerators and denominators of ratios can be found at childinfo_org.

* MICS standard questionnaires are designed to establish mother's/caretaker's education for all children up to and including age 14 at
  the time of interview (see List of Household Members, Household Questionaire).
* The category "Cannot be determined" includes children who were age 15 or higher at the time of the interview whose mothers were not living in
  the household.
* For such cases, information on their primary caretakers is not collected - therefore the educational status of the mother or the caretaker
  cannot be determined.

***.


include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* include definition of primarySchoolEntryAge .
include 'define/MICS5 - 08 - ED.sps' .

* Make a new category for mother's education level for children over 17 years.
recode melevel (5, sysmis = 5) (else = copy).
add value labels melevel
5 "Cannot be determined [a]"
.

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute boysAgedForPrimary = 0.
if (HL4 = 1 and schage >= primarySchoolEntryAge and schage <= primarySchoolCompletionAge ) boysAgedForPrimary = 1.
variable labels boysAgedForPrimary "Number of primary school age boys".

compute boysAttendingPrimary = 0.
if (boysAgedForPrimary = 1 and ED5 = 1 and ED6A >= 1 and ED6A <= 2) boysAttendingPrimary = 1.
if (HL4 = 1 and schage = primarySchoolCompletionAge and ED4A = 1 and ED4B = primarySchoolGrades and ED5 =  2) boysAttendingPrimary  = 1.
variable labels boysAttendingPrimary "Number of primary school age boys attending primary school".

compute girlsAgedForPrimary = 0.
if (HL4 = 2 and schage >= primarySchoolEntryAge and schage <= primarySchoolCompletionAge) girlsAgedForPrimary = 1.
variable labels girlsAgedForPrimary "Number of primary school age girls".

compute girlsAttendingPrimary = 0.
if (girlsAgedForPrimary = 1 and ED5 = 1 and ED6A >= 1 and ED6A <= 2) girlsAttendingPrimary = 1.
if (HL4 = 2 and schage = primarySchoolCompletionAge and ED4A = 1 and ED4B = primarySchoolGrades and ED5 =  2) girlsAttendingPrimary  = 1.
variable labels girlsAttendingPrimary "Number of primary school age girls attending primary school".

compute boysAgedForSecondary = 0.
if (HL4 = 1 and schage >= secondarySchoolEntryAge and schage <= secondarySchoolCompletionAge) boysAgedForSecondary = 1.
variable labels boysAgedForSecondary "Number of secondary school age boys".

compute boysAttendingSecondary = 0.
if (boysAgedForSecondary = 1 and ED5 = 1 and ED6A >= 2 and ED6A <= 3) boysAttendingSecondary = 1.
if (HL4 = 1 and schage = secondarySchoolCompletionAge and ED4A = 2 and ED4B = secondarySchoolGrades and ED5 = 2) boysAttendingSecondary = 1.
variable labels boysAttendingSecondary "Number of secondary school age boys attending secondary school".

compute girlsAgedForSecondary = 0.
if (HL4 = 2 and schage >= secondarySchoolEntryAge and schage <= secondarySchoolCompletionAge) girlsAgedForSecondary = 1.
variable labels girlsAgedForSecondary "Number of secondary school age girls".

compute girlsAttendingSecondary  = 0.
if (girlsAgedForSecondary = 1 and ED5 = 1 and ED6A >= 2 and ED6A <= 3) girlsAttendingSecondary =  1.
if (HL4 = 2 and schage = secondarySchoolCompletionAge and ED4A = 2 and ED4B = secondarySchoolGrades and ED5 = 2) girlsAttendingSecondary = 1.
variable labels girlsAttendingSecondary "Number of secondary school age girls attending secondary school".

aggregate outfile = 'tmp1.sav'
  /break   = total
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /boysAgedForSecondary    = sum(boysAgedForSecondary)
  /boysAttendingSecondary  = sum(boysAttendingSecondary)
  /girlsAgedForSecondary   = sum(girlsAgedForSecondary)
  /girlsAttendingSecondary = sum(girlsAttendingSecondary).

aggregate outfile = 'tmp2.sav'
  /break   = HL4
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /boysAgedForSecondary    = sum(boysAgedForSecondary)
  /boysAttendingSecondary  = sum(boysAttendingSecondary)
  /girlsAgedForSecondary   = sum(girlsAgedForSecondary)
  /girlsAttendingSecondary = sum(girlsAttendingSecondary).

aggregate outfile = 'tmp3.sav'
  /break   = HH7
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /boysAgedForSecondary    = sum(boysAgedForSecondary)
  /boysAttendingSecondary  = sum(boysAttendingSecondary)
  /girlsAgedForSecondary   = sum(girlsAgedForSecondary)
  /girlsAttendingSecondary = sum(girlsAttendingSecondary).

aggregate outfile = 'tmp4.sav'
  /break   = HH6
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /boysAgedForSecondary    = sum(boysAgedForSecondary)
  /boysAttendingSecondary  = sum(boysAttendingSecondary)
  /girlsAgedForSecondary   = sum(girlsAgedForSecondary)
  /girlsAttendingSecondary = sum(girlsAttendingSecondary).

aggregate outfile = 'tmp5.sav'
  /break   = melevel
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /boysAgedForSecondary    = sum(boysAgedForSecondary)
  /boysAttendingSecondary  = sum(boysAttendingSecondary)
  /girlsAgedForSecondary   = sum(girlsAgedForSecondary)
  /girlsAttendingSecondary = sum(girlsAttendingSecondary).

aggregate outfile = 'tmp6.sav'
  /break   = windex5
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /boysAgedForSecondary    = sum(boysAgedForSecondary)
  /boysAttendingSecondary  = sum(boysAttendingSecondary)
  /girlsAgedForSecondary   = sum(girlsAgedForSecondary)
  /girlsAttendingSecondary = sum(girlsAttendingSecondary).

aggregate outfile = 'tmp7.sav'
  /break   = ethnicity
  /boysAgedForPrimary      = sum(boysAgedForPrimary)
  /boysAttendingPrimary    = sum(boysAttendingPrimary)
  /girlsAgedForPrimary     = sum(girlsAgedForPrimary)
  /girlsAttendingPrimary   = sum(girlsAttendingPrimary)
  /boysAgedForSecondary    = sum(boysAgedForSecondary)
  /boysAttendingSecondary  = sum(boysAttendingSecondary)
  /girlsAgedForSecondary   = sum(girlsAgedForSecondary)
  /girlsAttendingSecondary = sum(girlsAttendingSecondary).

get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'
  /file = 'tmp7.sav'.

if (girlsAgedForPrimary > 0) pgirls = (girlsAttendingPrimary / girlsAgedForPrimary) * 100.
variable labels pgirls "Primary school adjusted net attendance ratio (NAR), girls".

if (boysAgedForPrimary > 0)  pboys  = (boysAttendingPrimary / boysAgedForPrimary) * 100.
variable labels pboys "Primary school adjusted net attendance ratio (NAR), boys".

if (pboys > 0) primaryGPI = (pgirls/pboys).
variable labels primaryGPI "Gender parity index (GPI) for primary school adjusted NAR [1]".

if (girlsAgedForSecondary > 0) sgirls = (girlsAttendingSecondary / girlsAgedForSecondary) * 100.
variable labels sgirls "Secondary school adjusted net attendance ratio (NAR), girls".

if (boysAgedForSecondary > 0)  sboys  = (boysAttendingSecondary / boysAgedForSecondary) * 100.
variable labels sboys "Secondary school adjusted net attendance ratio (NAR), boys".

if (sboys > 0) secondaryGPI = (sgirls/sboys).
variable labels secondaryGPI "Gender parity index (GPI) for  secondary school adjusted NAR [2]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total
           display = none
  /table   total [c]
         + hh7[c]
         + hh6[c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           pgirls [s] [mean,'',f5.1]
         + pboys [s] [mean,'',f5.1]
         + primaryGPI [s] [mean,'',f5.2]
         + sgirls [s] [mean,'',f5.1]
         + sboys [s] [mean,'',f5.1]
         + secondaryGPI [s] [mean,'',f5.2]
  /categories var=all empty=exclude missing=exclude
  /slabels visible=no
  /title title=
    "Table ED.8: Education gender parity"
    "Ratio of adjusted net attendance ratios of girls to boys, in primary and secondary school, " + surveyname
  caption=
    "[1] MICS indicator 7.9; MDG indicator 3.1 - Gender parity index (primary school)"
    "[2] MICS indicator 7.10; MDG indicator 3.1 - Gender parity index (secondary school)"
    "[a] Children age 15 or higher at the time of the interview whose mothers were not living in the household"
  .

* Auxillary table with denominators when run unweighted (not for printing).
ctables
  /vlabels variables = total
           display = none
  /table   total [c]
         + hh7[c]
         + hh6[c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           pgirls [s] [mean,'',f5.1]      + girlsAgedForPrimary [s][sum,'',f5.0]
         + pboys [s] [mean,'',f5.1]       + boysAgedForPrimary [s][sum,'',f5.0]
         + primaryGPI [s] [mean,'',f5.2]
   + sgirls [s] [mean,'',f5.1]      + girlsAgedForSecondary [s][sum,'',f5.0]
         + sboys [s] [mean,'',f5.1]       + boysAgedForSecondary [s][sum,'',f5.0]
         + secondaryGPI [s] [mean,'',f5.2]
  /categories var=all empty=exclude missing=exclude
  /slabels visible=no
  /title title=
    "Table ED.8.AUX: Auxillary table with denominators when run unweighted (not for printing)".

new file.
*delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.
erase file = 'tmp7.sav'.

