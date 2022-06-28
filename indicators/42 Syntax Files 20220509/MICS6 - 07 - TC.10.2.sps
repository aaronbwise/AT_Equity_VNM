* Encoding: windows-1252.
* MICS6 TC-10.2.

* v02 - 2020-04-14. Labels in French and Spanish have been removed.

 * MICS indicator 6.5: (EC1>=3 and EC1<=10)

 * MICS indicator 6.6: EC2: Two or more "Yes" responses to questions EC2 [A] to [C]

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* open children dataset.
get file = 'ch.sav'.

include "CommonVarsCH.sps".

* Select completed interviews.
select if (UF17  = 1).

* Weight the data by the children weight.
weight by chweight.

* compute indicators.
compute ind65 = (EC1>=3 and EC1<=10)*100 .
compute ten   = (EC1=10)*100 .
compute ind66 = ((ec2a=1) + (ec2b=1) + (ec2c=1) >= 2) * 100 .

recode ec2a ec2b ec2c
  (1 = 100)
  (else = 0).

* Generate totals.
compute total = 1.
compute numChildren = 1.
compute layer1 = 1.
compute layer2 = 1.

variable labels
    total "Total"
  /ind65 "3 or more children's books [1]"
  /ten   "10 or more children's books"
  /ind66 "Two or more types of playthings [2]"
  /ec2a  "Homemade toys"
  /ec2b  "Toys from a shop/manufactured toys"
  /ec2c  "Household objects/objects found outside"
  .

value labels
  /total   1 " "
  /layer1 1 "Percentage of children living in households that have for the child:"
  /layer2 1 "Percentage of children who play with:"
  /numChildren   1 "Number of children"
  .

* Ctables command in English.
ctables
  /vlabels variables = numChildren layer1 layer2 
           display = none
  /table  total[c]
        + hl4 [c]
        + hh6 [c]
        + hh7 [c]
        + ageGr [c]
        + melevel [c]
        + cdisability [c]
        + ethnicity [c]
        + windex5[c]
   by
          layer1[c] > ( 
            ind65 [s] [mean f5.1]
          + ten [s] [mean f5.1])
        + layer2[c] > ( 
            ec2a    [s][mean f5.1]
          + ec2b  [s][mean f5.1]
          + ec2c  [s][mean f5.1]
          + ind66 [s][mean f5.1])
        + numChildren [c][count]
  /categories variables=all empty=exclude missing=exclude
  /slabels visible=no
  /titles title=
     "Table TC.10.2: Learning materials"
     "Percentage of children under age 5 by numbers of children's books present in the household, and by playthings that child plays with, " + surveyname
   caption=
     "[1] MICS indicator TC.50 - Availability of children's books"
     "[2] MICS indicator TC.51 - Availability of playthings" .

new file.
