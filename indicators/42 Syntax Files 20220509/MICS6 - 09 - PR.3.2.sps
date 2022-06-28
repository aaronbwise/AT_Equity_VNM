* Encoding: windows-1252.

* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-14. Note C has been inserted. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'fs.sav'.

include "CommonVarsFS.sps".

select if (FS17 = 1).

weight by fsweight.

* definitions of econcomic activity variables  (ea1more, ea14less, ea14more, ea43less, ea43more) .
include 'define\MICS6 - 09 - PR.sps' .

variable labels
   hhc21less "Household chores less than 21 hours"
  /hhc21more "Household chores for 21 hours or more"
.	

if (CB3<=11) numChildren5_11 = 1 .
if (any(CB3, 12, 13, 14)) numChildren12_14 = 1 .

compute layerPercent5_11 = numChildren5_11 .
compute layerPercent12_14 = numChildren12_14 .

value labels
   numChildren5_11   1 "Number of children age 5-11 years"
  /numChildren12_14  1 "Number of children age 12-14 years"
  /layerPercent5_11  1 "Percentage of children age 5-11 years involved in:"
  /layerPercent12_14 1 "Percentage of children age 12-14 years involved in:"
  .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels schoolAttendance "School attendance".
value labels schoolAttendance 1 "Attending [B]" 2 "Not attending" .
variable labels fsdisability "Child's functional difficulties".
variable labels caretakerdis "Mother's functional difficulties [C]".

* Ctables command in English.
ctables
  /format missing = "na" 
  /vlabels variables = numChildren5_11 numChildren12_14 layerPercent5_11 layerPercent12_14 
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
           layerPercent5_11 [c] > (
             hhc21less[s] [mean '' f5.1]
           + hhc21more[s] [mean '' f5.1] )
         + numChildren5_11 [c] [count '' f5.0]
         + layerPercent12_14 [c] > (
             hhc21less[s] [mean '' f5.1]
           + hhc21more[s] [mean '' f5.1] )
         + numChildren12_14 [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table PR.3.2: Children's involvement in household chores"
  	 "Percentage of children age 5-14 yeasr by involvement in household chores [A] during the previous week, by age groups, " + surveyname
   caption=			
     "[A] Note that the threshold of number of hours was changed during MICS6 implementation, due to a change in the SDG indicator definition: " +
     "From 28 to 21 hours for both children age 5-11 and 12-14 years. In the new definition, there is no longer a maximum number of hours for chores of children age 15-17 years."						
     "[B] Includes attendance to early childhood education"
     "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
     "na: not applicable" .							

new file.

