* MICS5 ED-07.

* v01 - 2014-03-04.
* v02 - 2014-04-22.
* "Gardes" in variable names changed to "Grades".

* The primary completion rate is the ratio of the total number of students, regardless of age, entering the last grade of primary school for
  the first time, to the number of children of the primary graduation age at the beginning of the current (or most recent) school year, calculated as:
    Primary completion rate = 100 * (number of children attending the last grade of primary school - repeaters) /
      (number of children of primary school completion age at the beginning of the school year).

* Children attending the last grade of primary school are those with ED6A Level=1 and ED6B Grade=last grade of primary.

* Repeaters are those in the last grade of primary in both ED6 and ED8 (ED6A Level=1 and ED6B Grade=the last grade of primary and
  ED8A Level=1 and ED8B Level=the last grade of primary) .
* The denominator are children whose age at the beginning of the school year is equal to the age corresponding to the last grade of primary school.

* The transition rate to secondary education is the percentage of children who were in the last grade of primary school during the previous school
  year and who are attending the first grade of secondary school in the current (or most recent) school year, calculated as:
    Transition rate to secondary education = 100 * (number of children in the first grade of secondary school who were in the
      last grade of primary school the previous year) / (number of children in the last grade of primary school the previous year).

* Children attending secondary school who were in primary school the year before the survey are those with
   ED6A Level=2 and ED8A Level=1, ED8B Grade=last grade of primary.
* The denominator is children who were in the last grade of primary the previous year (ED8A Level=1 and ED8B Grade=last grade of primary).

* The effective transition rate is similar to the transition rate, except that the denominator also excludes repeaters.
* The calculation is: 100 * (number of children in the first grade of secondary school who were in the last grade of primary school the
    previous year) / (number of children in the last grade of primary school the previous year who are not repeating the last grade of
      primary school in the current year).

***.


include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* include definition of primarySchoolEntryAge .
include 'define/MICS5 - 08 - ED.sps' .


* number of children o primary school completion age.
compute denominator = 0.
if (schage = primarySchoolCompletionAge) denominator  = 1.

* number of repeaters.
compute repeaters = 0.
if ((ED6A = 1 and ED6B = primarySchoolGrades)  and ED8A = ED6A and ED8B  = ED6B) repeaters = 1.

* number of children in last primary grade.
compute inLastGrade = 0.
if ((ED6A = 1 and ED6B = primarySchoolGrades) and repeaters = 0) inLastGrade  = 1.

* number of children in first secondary grade who were in primary last year.
compute inSecondary = 0.
if (ED6A = 2 and ED8A = 1 and ED8B = primarySchoolGrades) inSecondary  = 1.

* number of children who were in the last grade of primary school the previous year.
compute inLastPrimaryGrade = 0.
if (ED8A = 1 and ED8B = primarySchoolGrades) inLastPrimaryGrade  = 1.

compute total = 1.
variable labels total "".
value labels total 1 "Total".

aggregate outfile = 'tmp1.sav'
  /break    = total
  /inLastGrade           = sum(inLastGrade)
  /denominator           = sum(denominator)
  /inSecondary           = sum(inSecondary)
  /inLastPrimaryGrade    = sum(inLastPrimaryGrade)
  /repeaters             = sum(repeaters).

aggregate outfile = 'tmp2.sav'
  /break    = HL4
  /inLastGrade           = sum(inLastGrade)
  /denominator           = sum(denominator)
  /inSecondary           = sum(inSecondary)
  /inLastPrimaryGrade    = sum(inLastPrimaryGrade)
  /repeaters             = sum(repeaters).

aggregate outfile = 'tmp3.sav'
  /break    = HH7
  /inLastGrade           = sum(inLastGrade)
  /denominator           = sum(denominator)
  /inSecondary           = sum(inSecondary)
  /inLastPrimaryGrade    = sum(inLastPrimaryGrade)
  /repeaters             = sum(repeaters).

aggregate outfile = 'tmp4.sav'
  /break    = HH6
  /inLastGrade           = sum(inLastGrade)
  /denominator           = sum(denominator)
  /inSecondary           = sum(inSecondary)
  /inLastPrimaryGrade    = sum(inLastPrimaryGrade)
  /repeaters             = sum(repeaters).

aggregate outfile = 'tmp5.sav'
  /break    = melevel
  /inLastGrade           = sum(inLastGrade)
  /denominator           = sum(denominator)
  /inSecondary           = sum(inSecondary)
  /inLastPrimaryGrade    = sum(inLastPrimaryGrade)
  /repeaters             = sum(repeaters).

aggregate outfile = 'tmp6.sav'
  /break    = windex5
  /inLastGrade           = sum(inLastGrade)
  /denominator           = sum(denominator)
  /inSecondary           = sum(inSecondary)
  /inLastPrimaryGrade    = sum(inLastPrimaryGrade)
  /repeaters             = sum(repeaters).

aggregate outfile = 'tmp7.sav'
  /break    = ethnicity
  /inLastGrade           = sum(inLastGrade)
  /denominator           = sum(denominator)
  /inSecondary           = sum(inSecondary)
  /inLastPrimaryGrade    = sum(inLastPrimaryGrade)
  /repeaters             = sum(repeaters).



get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'
  /file = 'tmp7.sav'.

if (denominator > 0) primarySchoolCompletionRate = (inLastGrade / denominator)*100.

if (inLastPrimaryGrade > 0) transitionRateToSecondary = (inSecondary / inLastPrimaryGrade)*100.

compute adjInLastPrimaryGrade = inLastPrimaryGrade - repeaters .

if (inLastPrimaryGrade > 0) transitionRateToSecondary = (inSecondary / inLastPrimaryGrade)*100.

if (adjInLastPrimaryGrade > 0) effectiveTransitionRateToSecondary = (inSecondary / adjInLastPrimaryGrade)*100.

variable labels
  inLastGrade            "Number of children attending the last grade of primary"
  /denominator           "Number of children of primary school completion age"
  /inSecondary           "Number of children in first secondary grade who were in primary last year"
  /inLastPrimaryGrade    "Number of children who were in the last grade of primary school the previous year"
  /primarySchoolCompletionRate        "Primary school completion rate [1]"
  /transitionRateToSecondary          "Transition rate to secondary school [2]"
  /effectiveTransitionRateToSecondary "Effective transition rate to secondary school"
  /adjInLastPrimaryGrade              "Number of children who were in the last grade of primary school the previous year and are not repeating that grade in the current school year"  .



* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total
           display = none
  /table   total [c]
         + hl4 [c]
         + hh7 [c]
         + hh6 [c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           primarySchoolCompletionRate [s] [mean,'',f5.1]
         + denominator [s] [sum,'',f5.0]
         + transitionRateToSecondary [s] [mean,'',f5.1]
         + inLastPrimaryGrade [s] [sum,'',f5.0]
         + effectiveTransitionRateToSecondary [s] [mean,'',f5.1]
         + adjInLastPrimaryGrade [s] [sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels visible=no
  /title title=
    "Table ED.7: Primary school completion and transition to secondary school"
    "Primary school completion rates and transition and effective transition rates to secondary school, " + surveyname
   caption=
    "[1] MICS indicator 7.7 - Primary completion rate"
    "[2] MICS indicator 7.8 - Transition rate to secondary school"
  .

new file.

* delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.
erase file = 'tmp7.sav'.
