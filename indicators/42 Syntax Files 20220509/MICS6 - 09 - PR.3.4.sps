* Encoding: windows-1252.

* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-21. Column labels have been updated. Footnotes have been updated and additional footnotes added. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'fs.sav'.

include "CommonVarsFS.sps".

select if (FS17 = 1).

weight by fsweight.

* definitions of econcomic activity variables  (ea1more, ea14less, ea14more, ea43less, ea43more) .
include 'define\MICS6 - 09 - PR.sps' .

variable labels
   eaMore "Economic activities above age specific threshold"
  /hhcMore "Household chores above age specific threshold"
  /hazardConditions "Total hazardous work"
  /includeHaz "Percentage of children engaged in economic activities or household chores above thresholds, or working under hazardous conditions [A]".

* recode hazardous work.
recode CL4 (1 = 100)(else = 0) into CL4r.
recode CL5 (1 = 100)(else = 0) into CL5r.
recode CL6A (1 = 100)(else = 0) into CL6Ar.
recode CL6B (1 = 100)(else = 0) into CL6Br.
recode CL6C (1 = 100)(else = 0) into CL6Cr.
recode CL6D (1 = 100)(else = 0) into CL6Dr.
recode CL6E (1 = 100)(else = 0) into CL6Er.
recode CL6X (1 = 100)(else = 0) into CL6Xr.
variable labels CL4r "Carrying heavy loads".
variable labels CL5r "Working with dangerous tools or operating heavy machinery".
variable labels CL6Ar "Exposed to dust, fumes or gas".
variable labels CL6Br "Exposed to extreme cold, heat or humidity".
variable labels CL6Cr "Exposed to loud noise or vibration".
variable labels CL6Dr "Working at heights".
variable labels CL6Er "Working with chemicals or explosives".
variable labels CL6Xr "Exposed to other unsafe or unhealthy things, processes or conditions".

compute layer1 = 1 .
compute layer2 = 1 .
compute numChildren = 1 .

value labels
   layer1  1 "Percentage of children engaged in:"
  /layer2  1 "Percentage of children working under hazardous conditions"
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
  /vlabels variables = numChildren layer1 layer2
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
           layer1 [c] > (
             eaMore[s] [mean '' f5.1]
           + hhcMore[s] [mean '' f5.1] )
         + layer2 [c] > (
                CL4r [s] [mean '' f5.1] 
             + CL5r [s] [mean '' f5.1]  
             + CL6Ar [s] [mean '' f5.1]  
             + CL6Br [s] [mean '' f5.1]  
             + CL6Cr [s] [mean '' f5.1]  
             + CL6Dr [s] [mean '' f5.1]  
             + CL6Er [s] [mean '' f5.1] 
             + CL6Xr [s] [mean '' f5.1] 
           + hazardConditions [s] [mean '' f5.1] )
         + includeHaz [s] [mean '' f5.1]
         + numChildren [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table PR.3.4: Hazardous work"
      "Percentage of children age 5-17 years engaged in economic activities or household chores above the age specific thresholds, percentage working under hazardous conditions, " +
      "by type of work, and percentage of children engaged in economic activities or household chores above thresholds or working under hazardous conditions during the previous week, " + surveyname
   caption=
   "[A] The definition of child labour used for SDG reporting does not include hazardous working conditions. This is a change over previously defined MICS6 indicator. " +
         "This column presents a definition comparable to the previous indicator. The SDG indicator is presented in Table PR.3.3."												
   "[B] Includes attendance to early childhood education"													
   "[C] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated."													
   "[D] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."																						
   "na: not applicable"												
  .			

new file.
