* Encoding: UTF-8.

* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-21. The disaggregate of “Mother’s education” has been edited. Note C has been edited and a new note D added. Labels in French and Spanish have been removed.
* v04 - 2021-10-26. Age group added as a background characteristic.

include "surveyname.sps".

get file = 'fs.sav'.

include "CommonVarsFS.sps".

select if (FS17 = 1).

weight by fsweight.

* definitions of econcomic activity variables  (ea1more, ea14less, ea14more, ea43less, ea43more) .
include 'define\MICS6 - 09 - PR.sps' .

variable labels
   eaLess "Below the age specific threshold"
  /eaMore "At or above the age specific threshold"
  /hhcLess "Below the age specific threshold"
  /hhcMore "At or above the age specific threshold"
  /childLabor "Total child labour [1] [A]" .

compute layerEA = 1 .
compute layerHHC = 1 .
compute numChildren = 1 .

value labels
   layerEA   1 "Children involved in economic activities for a total number of hours during last week:"
  /layerHHC  1 "Children involved in household chores for a total number of hours during last week:"
  /numChildren 1 "Number of children age 5-17 years"
  .

recode CB3 (5 thru 11 = 1) (12 thru 14 = 2) (15 thru 17 = 3) into ageGroup .
variable labels ageGroup "Age" .
value labels ageGroup
1 "5-11"
2 "12-14"  
3 "15-17".
formats ageGroup (f1.0).

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels schoolAttendance "School attendance".
value labels schoolAttendance 1 "Attending [B]" 2 "Not attending" .
variable labels fsdisability "Child's functional difficulties".
variable labels melevel "Mother’s education [C]".
variable labels caretakerdis "Mother's functional difficulties [D]".

* Ctables command in English.
ctables
  /vlabels variables = numChildren layerEA layerHHC
           display = none
  /table   total [c]
         + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + ageGroup [c]
         + schoolAttendance [c]
         + melevel [c]
         + fsdisability [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]
   by
           layerEA [c] > (
             ealess[s] [mean '' f5.1]
           + eaMore[s] [mean '' f5.1] )
         + layerHHC [c] > (
             hhcLess[s] [mean '' f5.1]
           + hhcMore[s] [mean '' f5.1] )
         + childLabor [s] [mean '' f5.1]
         + numChildren [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table PR.3.3: Child labour"
      "Percentage of children age 5-17 years by involvement in economic activities or household chores during the last week and percentage engaged in child labour during the previous week, " + surveyname
   caption=
     "[1] MICS indicator PR.3 - Child labour; SDG indicator 8.7.1"
     "[A] The definition of child labour used for SDG reporting does not include hazardous working conditions. This is a change over previously defined MICS6 indicator."						
     "[B] Includes attendance to early childhood education"	
     "[C] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated."
     "[D] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
     "na: not applicable"	
  .			

new file.
