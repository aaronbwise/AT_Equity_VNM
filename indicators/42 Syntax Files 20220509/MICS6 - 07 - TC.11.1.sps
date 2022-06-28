* Encoding: windows-1252.
***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
***.


 * Responses to questions EC6-EC15 are used to determine whether children are developmentally on track in four domains: 
   Literacy-numeracy: Developmentally on track if at least two of the following are true: 
  EC6=1 (Can identify/name at least ten letters of the alphabet), 
  EC7=1 (Can read at least four simple, popular words), 
  EC8=1 (Knows the name and recognizes the symbol of all numbers from 1 to 10).
 * Physical: Developmentally on track if one or both of the following is true: 
  EC9=1 (Can pick up a small object with two fingers, like a stick or a rock from the ground), 
  EC10=2 (Is not sometimes too sick to play).
 * Social-emotional: Developmentally on track if at least two of the following are true: 
  EC13=1 (Gets along well with other children), 
  EC14=2 (Does not kick, bite, or hit other children), 
  EC15=2 (Does not get distracted easily).
 * Learning: Developmentally on track if one or both of the following is true: 
  EC11=1 (Follows simple directions on how to do something correctly), 
 EC12=1 (When given something to do, is able to do it independently).

 * MICS indicator TC.53 is calculated as the percentage of children who are developmentally on track in at least three of the four component domains (literacy-numeracy, physical, social-emotional, and learning).

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* open children dataset.
get file = 'ch.sav'.

include "CommonVarsCH.sps".

* Select completed interviews.
select if (UF17 = 1).

* Select children 36+ months old.
select if (UB2 >= 3).

* Weight the data by the children weight.
weight by chweight.

* Generate number of children age 36-59 months.
compute numChildren = 1.
value labels numChildren  1 "".
variable labels numChildren "Number of children age 3-4 years".

* Compute indicators.
recode EC6 (1 = 100) (else = 0).
recode EC7 (1 = 100) (else = 0).
recode EC8 (1 = 100) (else = 0).

count langcog = EC8 EC7 EC6 (100).

recode langcog (2,3 = 100) (0,1 = 0) into langcog2.
variable labels langcog2 "Literacy-numeracy".

recode EC9  (1 = 100) (else = 0).
recode EC10 (2 = 100) (else = 0).

count physical = EC10 EC9 (100).

recode physical (1,2 = 100) (0 = 0) into physical2.
variable labels physical2 "Physical".

recode EC13 (1 = 100) (else = 0).
recode EC14 (2 = 100) (else = 0).
recode EC15 (2 = 100) (else = 0).

count socemo = EC15 EC14 EC13 (100).

recode socemo (2,3 = 100) (0,1 = 0) into socemo2.
variable labels socemo2 "Social-Emotional".

recode EC11 (1 = 100) (else = 0).
recode EC12 (1 = 100) (else = 0).

count learn = EC12 EC11 (100).

recode learn (1,2 = 100) (0 = 0) into learn2.
variable labels learn2 "Learning".

count develop = langcog2 physical2 socemo2 learn2 (100).

recode develop (3,4 = 100) (0,1,2 = 0)  into target.

variable labels target "Early child development index score [1]".

recode UB8 (1 = 1) (9 = 8) (else = 2).
variable labels UB8 "Attendance to early childhood education".
value labels UB8
  1 "Attending"
  2 "Not attending "
  8 "Missing".
										  
variable labels ub2 "Age".
value labels ub2 3 "3" 4 "4".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of children age 3-4 years who are developmentally on track for indicated domains".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

variable labels cdisability "Functional difficulties".

* Ctables command in English.
ctables
  /vlabels variables = layer
           display = none
  /table   total [c]
         + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + ub2 [c]
         + ub8 [c]
         + melevel [c]
         + cdisability [c]
        + ethnicity [c]
        + windex5[c]
   by
          layer [c] > ( 
             langcog2 [s] [mean '' f5.1]
           + physical2 [s] [mean '' f5.1]
           + socemo2 [s] [mean '' f5.1]
           + learn2 [s] [mean '' f5.1] )
         + target[s] [mean '' f5.1]
         + numChildren [s] [sum '' f5.0]
  /categories variables=all empty=exclude
  /slabels position=column visible = no
  /titles title=
     "Table TC.11.1: Early child development index"
     "Percentage of children age 3-4 years who are developmentally on track in literacy-numeracy, physical, " +
     "social-emotional, and learning domains, and the early child development index score, " + surveyname
   caption=
     "[1] MICS indicator TC.53 - Early child development index"
  .

new file.
