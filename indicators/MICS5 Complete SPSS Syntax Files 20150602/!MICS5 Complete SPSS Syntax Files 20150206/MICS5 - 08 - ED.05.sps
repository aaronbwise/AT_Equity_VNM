* MICS5 ED-05.

* v01 - 2014-03-04.
* v02 - 2014-04-22.
* "Gardes" in variable names changed to "Grades".

* The adjusted secondary school net attendance ratio (NAR) is the percentage of children of secondary school age (as of the beginning
  of the current or most recent school year) who are attending secondary school or higher (higher levels are included to take early starters
  into account).
* Children of secondary school age currently attending secondary school or higher (ED6A Level=2 or 3) are included in the numerator.
* All children of secondary school age at the beginning of the school year are included in the denominator.

* Ratios presented in this table are termed "adjusted" since they include not only secondary school attendance, but also attendance to
  higher levels of education.

* The percentage of children of secondary school age who are attending primary school should be used to complete the analysis for
  secondary school age children, including the adjusted secondary school net attendance ratio and the percentage of children of secondary
  school age out of school.

* The percentage of children out of school are those who are not attending secondary school or higher and those who are not attending primary
  school: ED6A=0 or ED6A>3 or ED5=2 .

* The age at the beginning of the school year is estimated by rejuvenating children to the first month of the (current or most recent) school
  year by using information on the date of birth (HL5), if available, and information on when the current (or most recent) school year began.
* If the date of birth is not available, then a full year is subtracted from the current age of the child at the time of survey (HL6), if the
  interview took place more than 6 months after the school year started.
* If the latter is less than six months and the date of birth is not available, the current age is assumed to be the same as the age at the
  beginning of the school year.

* MICS standard questionnaires are designed to establish mother's/caretaker's education for all children up to and including age 14 at the time
  of interview (see List of Household Members, Household Questionaire).
* The category "Cannot be determined" includes children who were age 15 or higher at the time of the interview whose mothers were not living
  in the household.
* For such cases, information on their primary caretakers is not collected - therefore the educational status of the mother or the caretaker
  cannot be determined.

* The table is based on a 6-year secondary school system, for ages 12 to 17.
* This should be adapted in accordance with the country-specific secondary school ages as indicated by ISCED.

***.


include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* include definition of primarySchoolEntryAge .
include 'define/MICS5 - 08 - ED.sps' .

variable labels schage "Age at beginning of school year".

* Select children who are of secondary school age.
select if (schage >= secondarySchoolEntryAge and schage <= secondarySchoolCompletionAge).

* Make a new category for mother's education level for children over 17 years.
* Refer to the existing melevel categories and create new one.
recode melevel (5, sysmis = 5) (else = copy).
add value labels melevel
  5 "Cannot be determined [b]"
.

compute secondary  = 0.
if (ED6A >= 2 and ED6A <= 3) secondary =  100.
* Set test for "Age at the begining of school year" equal to age in last grade of secondary and test for ED4B equal to the last grade of secondary.
if (schage = secondarySchoolCompletionAge and 
	ED4A = 2 and ED4B = secondarySchoolGrades and ED5 = 2) secondary  = 100.

compute primary  = 0.
if (ED6A = 1) primary =  100.

* The percentage of children out of school are those who are not attending secondary school or higher, 
those who are not attending primary school, and those who have not already completed secondary school: 
ED6A=0 or (ED5=2 and ED4<>last grade of secondary school).
compute outOfSchool = 0 .
if (ED5 = 2 or ED3 = 2 or ED6A = 0) outOfSchool = 100.
if (schage = secondarySchoolCompletionAge and 
	ED4A = 2 and ED4B = secondarySchoolGrades and ED5 = 2) outOfSchool  = 0.


variable labels primary "".
variable labels secondary "".
variable labels outOfSchool "".
variable labels HL4 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = hl4 secondary primary outOfSchool
           display = none
  /table   total [c]
         + hh7[c]
         + hh6[c]
         + schage [c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           hl4 [c] > (
             secondary [s] [mean,'Net attendance ratio (adjusted) [1]',f5.1]
           + primary   [s] [mean,'Percentage of children: Attending primary school',f5.1]
           + outOfSchool [s] [mean,'Percentage of children: Out of school [a]',f5.1]
           + secondary [s] [validn,'Number of children',f5.0] )
  /categories var=all empty=exclude missing=exclude
  /categories var=hl4 total=yes position = after label = "Total"
  /slabels position=column
  /title title=
    "Table ED.5: Secondary school attendance and out of school children"
      "Percentage of children of secondary school age attending secondary school or higher (adjusted net attendance ratio), " +
    "percentage attending primary school, and percentage out of school, " + surveyname
   caption =
    "[1] MICS indicator 7.5 - Secondary school net attendance ratio (adjusted)"
    "[a] The percentage of children of secondary school age out of school are those who are not attending primary, secondary, or higher education"
    "[b] Children age 15 or higher at the time of the interview whose mothers were not living in the household"
  .

new file.
