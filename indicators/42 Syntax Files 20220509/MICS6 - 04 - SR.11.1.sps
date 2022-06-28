* Encoding: windows-1252.
* MICS6 SR.11.1.

* v03 - 2020-04-09. Labels in French and Spanish have been removed.

** Children who are not living with at least one biological parent, either because the parents live elsewhere or because the parents are dead:
(HL12=2 or HL13=2) and (HL16=2 or HL17=2)

** Children for whom one or both biological parents are dead:
(HL12=2 or HL16=2)

** Missing information on mother/father:
(HL12>=8 or HL16>=8)

** The denominator in this table is children age 0-17 years in the list of household members.

***.

include "surveyname.sps".


get file="hl.sav".

sort cases by hh1 hh2 hl1.

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
if (HL14 > 0 and HL18 > 0) bothParents = 100 .

* Living with neither parent .
do if ((HL12 = 2 or HL13 = 2) and (HL16 = 2 or HL17 = 2)).
* Only father alive.
+ if (HL12 = 2  and HL16 = 1) withNeitherOnlyFather = 100 .
* Only mother alive.
+ if (HL12 = 1 and HL16 = 2)  withNeitherOnlyMother = 100 .
* Both alive.
+ if (HL12 = 1 and HL16 = 1) withNeitherBoth = 100 .
* Both dead.
+ if (HL12 = 2  and HL16 = 2)  withNeitherNone = 100 .
end if.

* Living with mother only (father dead or not in the HH).
do if (HL14 > 0 and (HL16 = 2 or HL17 = 2)) .
+ if (HL16 = 1) withMotherFatherLive = 100 .
+ if (HL16 = 2)  withMotherFatherDead = 100 .
end if.

* Living with father only (mother dead or not in the HH).
do if ((HL12 = 2 or HL13 = 2) and HL18 > 0) .
+ if (HL12  = 1) withFatherMotherLive = 100 .
+ if (HL12  = 2)  withFatherMotherDead = 100 .
end if.

compute missingInfo = 0.
if (HL12 >= 8 or HL13 >= 8 or HL16 >= 8 or HL17 >= 8) missingInfo = 100.

*Children who are not living with at least one biological parent, either because the parents live elsewhere or because the parents are dead:
*(HL12=2 or HL13=2) and (HL16=2 or HL17=2).
compute notWithParent = 0 .
if ((HL12 = 2 or HL13 = 2) and (HL16 = 2 or HL17 = 2)) notWithParent = 100.

*Not living with biological mother.
compute notWithMother= 0 .
if (HL12 <> 1 or HL13 <> 1) notWithMother = 100.
 
compute anyParentDead = 0 .
if (HL12 = 2 or HL16 = 2) anyParentDead = 100.

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
  /notWithMother       "Not living with biological mother"
  /notWithParent "Living with neither biological parent [1]"
  /anyParentDead "One or both parents dead [2]" .

compute layerNeither = 1 .
compute layerMother = 1 .  
compute layerFather = 1 .  

value labels 
   layerNeither 1 "Living with neither biological parent"
  /layerMother 1 "Living with mother only"
  /layerFather 1  "Living with father only" .

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
  
* Ctables command in English.
ctables
  /vlabels variables = layerNeither layerMother layerFather numChildren
           display = none
  /table  total [c]
        + hl4 [c]
        + hh6 [c]
        + hh7 [c]
        + ageGroups [c]
        + ethnicity [c]
        + windex5 [c]
   by
          bothParents [s] [mean '' f5.1] 
        + layerNeither [c] > (
            withNeitherOnlyFather [s] [mean '' f5.1] 
          + withNeitherOnlyMother [s] [mean '' f5.1] 
          + withNeitherBoth [s] [mean '' f5.1]      
          + withNeitherNone [s] [mean '' f5.1] )
        + layerMother [c] > (
            withMotherFatherLive [s] [mean '' f5.1]
          + withMotherFatherDead [s] [mean '' f5.1] ) 
        + layerFather [c] > (
            withFatherMotherLive [s] [mean '' f5.1]
          + withFatherMotherDead [s] [mean '' f5.1] )
        + missingInfo [s] [mean '' f5.1]
        + total100 [s] [mean '' f5.1]    
        + notWithMother [s] [mean '' f5.1]
        + notWithParent [s] [mean '' f5.1] 
        + anyParentDead [s] [mean '' f5.1] 
        + numChildren [c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table SR.11.1: Children's living arrangements and orphanhood"
  	 "Percent distribution of children age 0-17 years according to living arrangements, " +
                   "percentage of children age 0-17 years not living with a biological parent and percentage of children who have one or both parents dead,  " + surveyname
   caption=
     "[1] MICS indicator SR.18 - Children’s living arrangements"
     "[2] MICS indicator SR.19 - Prevalence of children with one or both parents dead"
   .

new file.

