* MICS5 CD-05.

* v02 - 2014-03-09.
* v03 - 2014-04-22.
* v04 - 2014-06-09.
* recoding of missing variables ED13 and ED14 to system missing removed (8,9 = sysmis).
* A column has been deleted: “Percentage of children not on track in any of the four domains”.

* Responses to questions EC8-EC17 are used to determine whether children are developmentally
  on track in four domains:
     Literacy-numeracy: Developmentally on track if at least two of the following are true:
         EC8 =1 (Can identify/name at least ten letters of the alphabet),
         EC9 =1 (Can read at least four simple, popular words),
         EC10=1 (Knows the name and recognizes the symbol of all numbers from 1 to 10)
     Physical: Developmentally on track if one or both of the following is true:
         EC11=1 (Can pick up a small object with two fingers, like a stick or a rock from the ground)
         EC12=2 (Is not sometimes too sick to play)
     Social-emotional: Developmentally on track if at least two of the following are true:
         EC15=1 (Gets along well with other children),
         EC16=2 (Does not kick, bite, or hit other children),
         EC17=2 (Does not get distracted easily)
     Learning: Developmentally on track if one or both of the following is true:
         EC13=1 (Follows simple directions on how to do something correctly),
         EC14=1 (When given something to do, is able to do it independently).

* MICS indicator 6.8 is calculated as the percentage of children who are developmentally
  on track in at least three of the four component domains (literacy-numeracy, physical,
  social-emotional, and learning).

* The percentage of children not on track in any of the four domains are those children that for
    i) Literacy-numeracy, at least two of the following are true: EC8=2, EC9=2, EC10=2; and
   ii) Physical, both EC11=2 and EC12=1; and
  iii) Social-emotional, at least two of the following are true: EC15=2, EC16=1, EC17=1; and
   iv) Learning, both EC13=2 and EC14=2.

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* open children dataset.
get file = 'ch.sav'.

* Select completed interviews.
select if (UF9 = 1).

* Select children 36+ months old.
select if (cage >= 36).

* Weight the data by the children weight.
weight by chweight.

* Generate number of children age 36-59 months.
compute numChildren = 1.
value labels numChildren  1 "".
variable labels numChildren "Number of children age 36-59 months".

* Compute indicators.
recode EC8  (1 = 100) (else = 0).
recode EC9  (1 = 100) (else = 0).
recode EC10 (1 = 100) (else = 0).

count langcog = EC8 EC9 EC10 (100).

recode langcog (2,3 = 100) (0,1 = 0) into langcog2.
variable labels langcog2 "Literacy-numeracy".

recode EC11 (1 = 100) (else = 0).
recode EC12 (2 = 100) (else = 0).

count physical = EC11 EC12 (100).

recode physical (1,2 = 100) (0 = 0) into physical2.
variable labels physical2 "Physical".

recode EC15 (1 = 100) (else = 0).
recode EC16 (2 = 100) (else = 0).
recode EC17 (2 = 100) (else = 0).

count socemo = EC15 EC16 EC17 (100).

recode socemo (2,3 = 100) (0,1 = 0) into socemo2.
variable labels socemo2 "Social-Emotional".

recode EC13 (1 = 100) (else = 0).
recode EC14 (1 = 100) (else = 0).

count learn = EC13 EC14 (100).

recode learn (1,2 = 100) (0 = 0) into learn2.
variable labels learn2 "Learning".

count develop = langcog2 physical2 socemo2 learn2 (100).

recode develop (3,4 = 100) (0,1,2 = 0)  into target.

variable labels target "Early child development index score [1]".

recode cage (36 thru 47 = 1) (else = 2) into age2.
variable labels age2 "Age".
value labels age2 1 "36-47 months" 2 "48-59 months".

compute ece = 2.
if (EC5 = 1) ece = 1.
variable labels ece "Attendance to early childhood education".
value labels ece
  1 "Attending"
  2 "Not attending ".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of children age 36-59 months who are developmentally on track for indicated domains".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer
           display = none
  /table   total [c]
         + hl4 [c]
         + hh7 [c]
         + hh6 [c]
         + age2 [c]
         + ece [c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
          layer [c] > ( 
             langcog2 [s] [mean,'',f5.1]
           + physical2 [s] [mean,'',f5.1]
           + socemo2 [s] [mean,'',f5.1]
           + learn2 [s] [mean,'',f5.1] )
         + target[s] [mean,'',f5.1]
         + numChildren [s] [sum,'',f5.0]
  /categories var=all empty=exclude
  /slabels position=column visible = no
  /titles title=
     "Table CD.5: Early child development index"
     "Percentage of children age 36-59 months who are developmentally on track in literacy-numeracy, physical, " +
     "social-emotional, and learning domains, and the early child development index score, " + surveyname
   caption=
     "[1] MICS indicator 6.8 - Early child development index"
  .

new file.
