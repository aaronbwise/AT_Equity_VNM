* MICS5 CP-14 .

* v01 - 2014-03-18.

* Children who are not living with at least one biological parent, either because the parents live elsewhere or because the parents are dead:
    (HL11=2 or HL12=00) and (HL13=2 or HL14=00) .

* Children for whom one or both biological parents are dead:
    (HL11=2 or HL13=2) .

* Missing information on father/ mother:
    (HL11>=8 or HL13>=8) .

* The denominator in this table is children age 0-17 years in the list of household members .

***.

include "surveyname.sps".

get file="hl.sav".

select if (HL6 <= 17) .

weight by hhweight.

compute bothParents = 0 .

compute withNeitherOnlyFather = 0 .
compute withNeitherOnlyMother = 0 .
compute withNeitherBoth = 0 .
compute withNeitherNone = 0 .

compute withMotherFatherLive = 0 .
compute withMotherFatherDead = 0 .

compute withFatherMotherLive = 0 .
compute withFatherMotherDead = 0 .

compute missingInfo = 0 .

* Living with both parents .
if (HL12 > 0 and HL14 > 0) bothParents = 100 .

* Living with neither parent .
do if ((HL11 = 2 or HL12 = 00) and (HL13 = 2 or HL14 = 00)).
* Only father alive.
+ if (HL11 = 2  and HL13 = 1) withNeitherOnlyFather = 100 .
* Only mother alive.
+ if (HL11 = 1 and HL13 = 2)  withNeitherOnlyMother = 100 .
* Both alive.
+ if (HL11 = 1 and HL13 = 1) withNeitherBoth = 100 .
* Both dead.
+ if (HL11 = 2  and HL13 = 2)  withNeitherNone = 100 .
end if.

* Living with mother only (father dead or not in the HH).
do if (HL12 > 0 and (HL13 = 2 or HL14 = 0)) .
+ if (HL13 = 1) withMotherFatherLive = 100 .
+ if (HL13 = 2)  withMotherFatherDead = 100 .
end if.

* Living with father only (mother dead or not in the HH).
do if ((HL11 = 2 or HL12 = 0) and HL14 > 0) .
+ if (HL11 = 1) withFatherMotherLive = 100 .
+ if (HL11  = 2)  withFatherMotherDead = 100 .
end if.

compute missingInfo = 0.
if (HL11 >= 8 or HL13>= 8) missingInfo = 100.

* Children who are not living with at least one biological parent, either because the parents live elsewhere or because the parents are dead:.
* (HL11=2 or HL12=00) and (HL13=2 or HL14=00).
compute notWithParent = 0 .
if ((HL11 = 2 or HL12 = 0) and (HL13 = 2 or HL14 = 0)) notWithParent = 100 .

compute anyParentDead = 0 .
if (HL11 = 2 or HL13 = 2) anyParentDead = 100.

variable labels
   bothParents "Living with both parents"
  /withNeitherOnlyFather "Only father alive"
  /withNeitherOnlyMother "Only mother alive"
  /withNeitherBoth       "Both alive"
  /withNeitherNone       "Both dead"	
  /withMotherFatherLive  "Father alive"
  /withMotherFatherDead  "Father dead"		
  /withFatherMotherLive  "Mother alive"	
  /withFatherMotherDead  "Mother dead"
  /missingInfo           "Missing information on father/mother"
  /notWithParent "Living with neither biological parent [1]"
  /anyParentDead "One or both parents dead [2]" .

compute layerNither = 1 .
compute layerMother = 1 .  
compute layerFather = 1 .  

value labels 
   layerNither 1 "Living with neither biological parent"
  /layerMother 1 "Living with mother only"
  /layerFather 1 "Living with father only" .

compute numChildren = 1.
value labels numChildren 1 "Number of children age 0-17 years" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute total100 = 100.
variable labels total100 "Total".

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
  /vlabels variables = layerNither layerMother layerFather numChildren
           display = none
  /table  total [c]
        + hl4 [c]
        + hh7 [c]
        + hh6 [c]
        + ageGroups [c]
        + windex5 [c]
        + ethnicity [c]
   by
          bothParents [s] [mean,'',f5.1] 
        + layerNither [c] > (
            withNeitherOnlyFather [s] [mean,'',f5.1] 
          + withNeitherOnlyMother [s] [mean,'',f5.1] 
          + withNeitherBoth [s] [mean,'',f5.1]      
          + withNeitherNone [s] [mean,'',f5.1] )
        + layerMother [c] > (
            withMotherFatherLive [s] [mean,'',f5.1]
          + withMotherFatherDead [s] [mean,'',f5.1] ) 
        + layerFather [c] > (
            withFatherMotherLive [s] [mean,'',f5.1]
          + withFatherMotherDead [s] [mean,'',f5.1] )
        + missingInfo [s] [mean,'',f5.1]
        + total100 [s] [mean,'',f5.1]    
        + notWithParent [s] [mean,'',f5.1] 
        + anyParentDead [s] [mean,'',f5.1] 
        + numChildren [c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
     "Table CP.14: Children's living arrangements and orphanhood"
  	 "Percent distribution of children age 0-17 years according to living arrangements, percentage of children age 0-17 years "
                   "not living with a biological parent and percentage of children who have one or both parents dead, " + surveyname
   caption=
     "[1] MICS indicator 8.13 - Children’s living arrangements"
     "[2] MICS indicator 8.14 - Prevalence of children with one or both parents dead"
  .

new file.
