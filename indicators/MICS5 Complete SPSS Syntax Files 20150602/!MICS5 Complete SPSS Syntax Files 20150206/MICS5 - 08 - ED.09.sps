* MICS5 ED-09.

* v01 - 2014-03-04.
* v02 - 2014-08-19.
* Out of school children calculation updated as per the latest version of tab plan.

* The percentage of out of school children can be found in tables ED_4 and ED_5 for primary and secondary school ages, respectively.
* These form the denominators of the calculation of the percentage of girls in the total out of school population of primary and secondary school ages.

* MICS standard questionnaires are designed to establish mother's/caretaker's education for all children up to and including age 14 at the time of
  interview (see List of Household Members, Household Questionaire).
* The category "Cannot be determined" includes children who were age 15 or higher at the time of the interview whose mothers were not living in the household.
* For such cases, information on their primary caretakers is not collected - therefore the educational status of the mother or the caretaker cannot be determined.

***.


include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* include definition of primarySchoolEntryAge .
include 'define/MICS5 - 08 - ED.sps' .


* Make a new category for mother's education level for children over 17 years.
* Refer to the existing melevel categories and create new one.
* Customization required.
recode melevel (5, sysmis = 5) (else = copy).
add value labels melevel
5 "Cannot be determined [a]"
.

compute total = 1.
variable labels total "".
value labels total 1 "Total".

***** Primary school .
if (schage >= primarySchoolEntryAge and schage <= primarySchoolCompletionAge) numPrimarySchoolAge = 1.
if (numPrimarySchoolAge=1) outOfPrimarySchool = 0.
if (numPrimarySchoolAge=1 and (ED5=2 or ED3 = 2 or ED6A=0)) outOfPrimarySchool = 100.
if (schage = primarySchoolCompletionAge and ED4A = 1 and ED4B = primarySchoolGrades and ED5 = 2) outOfPrimarySchool  = 0.

if (outOfPrimarySchool = 100) girlsInOutOfPrimarySchool = 0.
if (outOfPrimarySchool = 100 and HL4 = 2) girlsInOutOfPrimarySchool = 100.

if (outOfPrimarySchool = 100)  numOutOfPrimarySchool = 1.

compute layerPrimary = 1.
value labels layerPrimary 1 'Primary school'.

variable labels outOfPrimarySchool "Percentage of out of school children"
  /numPrimarySchoolAge "Number of children of primary school age"
  /girlsInOutOfPrimarySchool "Percentage of girls in the total out of school population of primary school age"
  /numOutOfPrimarySchool "Number of children of primary school age out of school" .


***** Secondary school .
if (schage >= secondarySchoolEntryAge and schage <= secondarySchoolCompletionAge) numSecondarySchoolAge = 1.
if (numSecondarySchoolAge=1) outOfSecondarySchool = 0 .
if (numSecondarySchoolAge=1 and (ED5 = 2 or ED3 = 2 or ED6A = 0)) outOfSecondarySchool = 100 .
if (schage = secondarySchoolCompletionAge and ED4A = 2 and ED4B = secondarySchoolGrades and ED5 = 2) outOfSecondarySchool  = 0.

if (outOfSecondarySchool = 100) girlsInOutOfSecondarySchool = 0.
if (outOfSecondarySchool = 100 and HL4 = 2) girlsInOutOfSecondarySchool = 100.

if (outOfSecondarySchool = 100)  numOutOfSecondarySchool = 1.

compute layerSecondary = 1.
value labels layerSecondary 1 'Secondary school'.

variable labels outOfSecondarySchool "Percentage of out of school children"
  /numSecondarySchoolAge "Number of children of secondary school age"
  /girlsInOutOfSecondarySchool "Percentage of girls in the total out of school population of secondary school age"
  /numOutOfSecondarySchool "Number of children of secondary school age out of school" .



* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total layerPrimary layerSecondary
           display = none
  /table   total [c]
         + hh7[c]
         + hh6[c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           layerPrimary [c] > (
             outOfPrimarySchool [s] [mean,'',f5.1]
           + numPrimarySchoolAge [s] [sum,'',f5.0]
           + girlsInOutOfPrimarySchool [s] [mean,'',f5.1]
           + numOutOfPrimarySchool [s] [sum,'',f5.0] )
         + layerSecondary [c] > (
             outOfSecondarySchool [s] [mean,'',f5.1]
           + numSecondarySchoolAge [s] [sum,'',f5.0]
           + girlsInOutOfSecondarySchool [s] [mean,'',f5.1]
           + numOutOfSecondarySchool [s] [sum,'',f5.0] )
  /categories var=all empty=exclude missing=exclude
  /slabels visible=no
  /title title=
    "Table ED.9: Out of school gender parity"
    "Percentage of girls in the total out of school population, in primary and secondary school, " + surveyname
  caption=
    "[a] Children age 15 or higher at the time of the interview whose mothers were not living in the household"
  .

new file.
