* Encoding: windows-1252.
* MICS6 SR.11.2.

* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-09. Several changes made in line with the latest tab plan. Labels in French and Spanish have been removed.

** Children age 0-17 years with at least one parent living elsewhere: HL15=1, 2, 3, or 4 or HL19=1, 2, 3, or 4.

** Children age 0-17 years with at least one parent living abroad: HL15=1 or HL19=1.

***.

include "surveyname.sps".

get file="hl.sav".

sort cases by hh1 hh2 hl1.

* select children 0-17 listed in the HL.
select if (HL6 <= 17) .

* weight data by household weight.
weight by hhweight.

* Calculate child's orphanhood status.
compute oStatus = 9.
if (HL12 = 1 and HL16 = 1) oStatus = 1.
if (HL12 = 1 and HL16 = 2) oStatus = 2.
if (HL12 = 2 and HL16 = 1) oStatus = 3.
if (HL12 = 2 and HL16 = 2) oStatus = 4.
if (HL12 >=8 or HL16 >= 8) oStatus = 9.
variable labels oStatus "Orphanhood status".
value labels oStatus
1 "Both parents alive"
2 "Only mother alive"
3 "Only father alive"
4 "Both parents deceased"
9 "Unknown".

if (HL15 = 1 or HL15 = 2 or HL15 = 3 or HL15 = 4)  pElse = 1 .
if (HL19 = 1 or HL19 = 2 or HL19 = 3 or HL19 = 4)  pElse = 2 .
if ((HL15 = 1 or HL15 = 2 or HL15 = 3 or HL15 = 4) and (HL19 = 1 or HL19 = 2 or HL19 = 3 or HL19 = 4)) pElse = 3.
variable labels pElse " ".
value labels pElse 
1 "Mother is living elsewhere [A]"
2 "Father is living elsewhere [A]"
3 "Both mother and father are living elsewhere [A]".

compute anyElse = 0 .
if (pElse = 1 or pElse = 2 or pElse = 3) anyElse = 100.

if (HL15 = 1) pAbroad = 1.
if (HL19 = 1) pAbroad = 2.
if (HL15 = 1 and HL19 = 1) pAbroad = 3.
value labels pAbroad
  1 "Mother living abroad"
  2 "Father living abroad"
  3 "Mother and father living abroad".

compute anyAbroad = 0.
if (pAbroad = 1 or pAbroad = 2 or pAbroad = 3) anyAbroad = 100.

variable labels
   anyElse "At least one parent living elsewhere [A]"
  /anyAbroad   "At least one parent living abroad [1]" .
  
compute numChildren = 1.
value labels numChildren 1 "Number of children age 0-17 years" .

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of children age 0-17 years with:".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

recode HL6
  ( 0 thru  4 = 1)
  ( 5 thru  9 = 2)
  (10 thru 14 = 3)
  (15 thru 17 = 4) into ageGroups .
variable labels ageGroups "Age".
value labels ageGroups
  1 "0-4"
  2 "5-9"
  3 "10-14"
  4 "15-17" .

* Ctables command in English.
ctables
  /vlabels variables =  numChildren layer pElse pAbroad
           display = none
  /table  total [c]
        + hl4 [c]
        + hh6 [c]
        + hh7 [c]
        + ageGroups [c]
        + oStatus [c]
        + ethnicity [c]
        + windex5 [c]
   by
         layer [c] > ( pElse[c] [rowpct.totaln '' f5.1] 
        + anyElse [s] [mean, '', f5.1]
        + pAbroad [c] [rowpct.totaln '' f5.1] 
        + anyAbroad [s] [mean, '', f5.1])
        + numChildren [c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table SR.11.2: Children's living arrangements and co-residence with parents"
  	 "Percentage of children age 0-17 years by coresidence of parents, " + surveyname
   caption=
     "[1] MICS indicator SR.20 - Children with at least one parent living abroad"
     "[A] Includes parent(s) living abroad as well as those living elsewhere in the country"
     "na: not applicable".
  .

new file.