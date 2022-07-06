* MICS5 ED-04.

* v01 - 2014-03-04.
* v02 - 2014-04-22.
* "Gardes" in variable names changed to "Grades".
* v03 - 2014-05-05.
* line: if (ED5 = 2) notAttendingSchoolPreschool = 100 . 
* changed to if (ED5 = 2 or ED3 = 2) notAttendingSchoolPreschool = 100  in order to include children that never attended school.

* The adjusted primary school net attendance ratio (NAR) is the percentage of children of primary school age (as of the beginning of school year) 
  who are attending primary or secondary school.
* Children of primary school age at the beginning of the school year currently attending primary or secondary school (ED6A Level=1 or 2) are 
  included in the numerator (attendance to secondary school is included to take into account early starters).
* All children of primary school age (at the beginning of the school year) are included in the denominator. 

* Ratios presented in this table are termed "adjusted" since they include not only primary school attendance,
  but also secondary school attendance in the numerator.

* The percentage of children: 
   i) Not attending school are those who did not attend school or preschool in the current school year and 
   have not completed primary school (ED5=2 and ED4<>last grade of primary school)
   ii) Attending preschool are those who in the current school year have been attending preschool school (ED6A=0)
   iii) Out of school children are the sum of i) and ii).

* Children for whom it is not known whether they are attending school 
* (ED5>2), for whom level of current attendance is not known (ED6A>3), or 
* those who are likely misclassified as attending level(s) above secondary education (ED6A>2) are not considered out of school. 
* This group should consist of very few cases (missing and inconsistent values). 
* Therefore, the results in the NAR and Out of School columns do not necessarily sum to 100.

* The age at the beginning of the school year is estimated by rejuvenating children to the first month of the (current or most recent) school year
  by using information on the date of birth (HL5), if available, and information on when the current (or most recent) school year began. 
* If the date of birth is not available, then a full year is subtracted from the current age of the child at the time of survey (HL6), 
  if the interview took place more than 6 months after the school year started. 
* If the latter is less than six months and the date of birth is not available, the current age is assumed to be the same as 
  the age at the beginning of the school year.

* The table is based on a 6-year primary school system, for ages 6 to 11. 
* This should be adapted in accordance with the country-specific primary school ages as indicated by ISCED.

***.


include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* Select children who are of primary school age; this definition is
* country-specific and should be changed to reflect the situation in your
* country.

* include definition of primarySchoolEntryAge .
include 'define/MICS5 - 08 - ED.sps' .

variable labels schage "Age at beginning of school year".

select if (schage >= primarySchoolEntryAge and schage <= primarySchoolCompletionAge).

compute primary  = 0.
if (ED6A >= 1 and ED6A <= 2) primary =  100.

* Further adjust for children that are of primary school completion age and already completed primary school, but did not attend secondary.
* Set test for "Age at the begining of school year" equal to age in last grade of primary and test for ED4B equal to the last grade of primary.
if (schage = primarySchoolCompletionAge and 
    ED4A = 1 and ED4B = primarySchoolGrades and ED5 = 2) primary  = 100.

* Not attending school are those who did not attend school or preschool in the current school year and have not 
completed primary school (ED5=2 and ED4<>last grade of primary school). 
compute notAttendingSchoolPreschool = 0 .
if (ED5 = 2 or ED3 = 2) notAttendingSchoolPreschool = 100 .
if (schage = primarySchoolCompletionAge and 
    ED4A = 1 and ED4B = primarySchoolGrades and ED5 = 2) notAttendingSchoolPreschool  = 0.

* Attending preschool are those who in the current school year have been attending preschool school (ED6A=0).
compute attendingPreschool = 0.
if (ED6A = 0) attendingPreschool = 100 .

* Out of school children are the sum attending preschol and not attending school.
compute outOfSchool = 0.
if (notAttendingSchoolPreschool = 100 or attendingPreschool = 100) outOfSchool = 100.

variable labels primary "".
variable labels HL4 "".

compute layer = 1.
value labels layer 1 "Percentage of children:".

compute numChildren = 1.

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in French.
ctables
  /vlabels variables = hl4 primary layer notAttendingSchoolPreschool 
                       attendingPreschool outOfSchool numChildren
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
             primary [s][mean,'Net attendance ratio (adjusted) [1]',f5.1] 
           + layer [c] > (
               notAttendingSchoolPreschool [s] [mean,'Not attending school or preschool',f5.1]
             + attendingPreschool [s] [mean,'Attending preschool',f5.1]
             + outOfSchool [s] [mean,'Out of school [a]',f5.1] )
           + numChildren [s] [validn,'Number of children'] )
  /categories var=all empty=exclude missing=exclude
  /categories var=hl4 total=yes position = after label = "Total"
  /slabels position=column
  /title title=
    "Table ED.4: Primary school attendance and out of school children"
    "Percentage of children of primary school age attending primary or secondary school (adjusted net attendance ratio), " +
    "percentage attending preschool, and percentage out of school, " + surveyname
   caption =
    "[1] MICS indicator 7.4; MDG indicator 2.1 - Primary school net attendance ratio (adjusted)"
    "[a] The percentage of children of primary school age out of school are those not attending school and those attending preschool"
  .

new file.
