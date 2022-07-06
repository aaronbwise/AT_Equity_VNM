* MICS5 CP-15 .

* v01 - 2014-03-17.
* v02 - 2014-04-21.
* The background characteristics have been reordered to match other CP tables.

* Children age 0-17 years with at least one parent is living abroad: 
    HL12A=3 or HL14A=3 .

***.

include "surveyname.sps".

get file="hl.sav".

* select children 0-17 listed in the HL.
select if (HL6 <= 17) .

* weight data by household weight.
weight by hhweight.

* recode cases where parents are listed in the household from sysmis to 0.
recode HL12A (sysmis = 0) (else = copy).
recode HL14A (sysmis = 0) (else = copy).

compute livingAbroad = 4.
if (HL12A = 3 and HL14A <> 3) livingAbroad = 1 .
if (HL12A <> 3 and HL14A = 3) livingAbroad = 2 .
if (HL12A = 3 and HL14A = 3) livingAbroad = 3.

compute anyAbroad = 0 .
if (HL12A = 3 or HL14A = 3) anyAbroad = 100.

variable labels
   livingAbroad "Percent distribution of children age 0-17 years:"
  /anyAbroad   "Percentage of children age 0-17 years with at least one parent living abroad [1]" .
  
value labels livingAbroad
  1 "With at least one parent living abroad: Only mother abroad"
  2 "With at least one parent living abroad: Only father abroad"
  3 "With at least one parent living abroad: Both mother and father abroad" 
  4 "With neither parent living abroad".

compute numChildren = 1.
value labels numChildren 1 "Number of children age 0-17 years" .

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

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  numChildren
           display = none
  /table  total [c]
        + hl4 [c]
        + hh7 [c]
        + hh6 [c]
        + ageGroups [c]
        + windex5 [c]
        + ethnicity [c]
   by
          livingAbroad [c] [rowpct,'',f5.1] 
        + anyAbroad [s] [mean, '', f5.1]
        + numChildren [c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=livingAbroad total=yes labels="Total"
  /slabels position=column visible = no
  /title title=
     "Table CP.15: Children with parents living abroad"
  	 "Percent distribution of children age 0-17 years by residence of parents in another country, " + surveyname
   caption=
     "[1] MICS indicator 8.15 - Children with at least one parent living abroad"
  .

new file.
