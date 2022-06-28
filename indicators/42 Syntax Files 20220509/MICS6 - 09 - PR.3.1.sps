* Encoding: windows-1252.
***.
* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-14. The disaggregates of “Mother’s education” and “Mother’s functional difficulties” have been edited. Note B has been edited and a new note C added. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'fs.sav'.

include "CommonVarsFS.sps".

select if (FS17 = 1).

weight by fsweight.

* definitions of econcomic activity variables  (ea1more, ea14less, ea14more, ea43less, ea43more) .
include 'define\MICS6 - 09 - PR.sps' .

variable labels
   ea1more  "Percentage of children age 5-11 years involved in economic activity for at least one hour"
  /ea14less "Economic activity less than 14 hours"
  /ea14more "Economic activity for 14 hours or more" 
  /ea43less "Economic activity less than 43 hours"
  /ea43more "Economic activity for 43 hours or more" .

compute layerPercentage12_14 = numChildren12_14 . 
compute layerPercentage15_17 = numChildren15_17 . 

value labels
   numChildren5_11      1 "Number of children age 5-11 years"
  /numChildren12_14     1 "Number of children age 12-14 years"
  /numChildren15_17     1 "Number of children age 15-17 years"
  /layerPercentage12_14 1 "Percentage of children age 12-14 years involved in:"
  /layerPercentage15_17 1 "Percentage of children age 15-17 years involved in:" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels schoolAttendance "School attendance".
value labels schoolAttendance 1 "Attending [A]" 2 "Not attending" .

variable labels fsdisability "Child's functional difficulties".
variable labels melevel "Mother’s education [B]".
variable labels caretakerdis "Mother's functional difficulties [C]".
  
* Ctables command in English.
ctables
  /format missing = "na" 
  /vlabels variables = numChildren5_11 numChildren12_14 numChildren15_17 layerPercentage12_14 layerPercentage15_17
           display = none
  /table   total [c]
         + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + schoolAttendance [c]
         + melevel [c]
         + fsdisability [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]
   by
           ea1more[s] [mean '' f5.1]
         + numChildren5_11 [c] [count '' f5.0]
         + layerPercentage12_14 [c] > (
             ea14less [s] [mean '' f5.1]
           + ea14more [s] [mean '' f5.1] )
         + numChildren12_14 [c] [count '' f5.0]
         + layerPercentage15_17 [c] > (
             ea43less [s] [mean '' f5.1]
           + ea43more [s] [mean '' f5.1] )
         + numChildren15_17 [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table PR.3.1: Children's involvement in economic activities"
  	 "Percentage of children age 5-17 years by involvement in economic activities during the previous week, by age groups, " + surveyname
   caption=
     "[A] Includes attendance to early childhood education"						
     "[B] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated."		
     "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."				
     "na: not applicable".

new file.
