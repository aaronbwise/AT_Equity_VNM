* MICS5 MHA-02M.

* v01 - 2014-03-17.
* v02 - 2014-04-23.
* background variable "religion" replaced by "ethnicity" in ctable command.
*+ knowForTransmision [s] [mean,'',f5.1]  removed from the table as per latest tab plan.

* The denominator includes all men, including those who have not heard of AIDS (MHA1=2).

* Men who knowForTransmision all allThree means of transmission are men who answered ‘yes’ to all allThree ways 
   (MHA8[A]=1 and MHA8[B]=1 and MHA8[C]=1).
* The column labeled ‘Did not knowForTransmision any of the specific means’ should include men who did not respond 'yes' to any specific way 
  (including those who responded "Don't knowForTransmision") 
    (MHA8[A]<>1 and MHA8[B]<>1 and MHA8[C]<>1).

***.


include "surveyname.sps".

get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.

* include HA . 
include 'define/MICS5 - 10 - HA.M.sps' .

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of men age 15-49 who have heard of AIDS and:".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Know HIV can be transmitted from mother to child:".

recode mmstatus (1,2 = 1) (3 = 2).
variable labels mmstatus "Marital status".
add value labels mmstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode mwage (1 = 2) (2 = 3) into mwageAux .

recode mwage (1, 2 = 1) (3 = 4) (4, 5 = 5) (6, 7 = 6).
variable labels mwage "Age".
value labels mwage
 1 "15-24 [1]"
 2 "    15-19"
 3 "    20-24"
 4 "25-29"
 5 "30-39"
 6 "40-49" .

mrsets
  /mcgroup name=$mwage
   label='Age'
   variables=mwage mwageAux .
   
compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men age 15-49".

compute total = 1.
variable labels total "".
value labels total 1 "Total".


* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  numMen layer0 layer1 total 
           display = none
  /table   total [c] 
         + hh7 [c]
         + hh6 [c]
         + $mwage [c]
         + mmstatus [c]
         + mwelevel [c]
         + windex5 [c]
         + ethnicity [c]       
   by 
          layer0 [c] > (
              layer1 [c] > (
              duringPregnancy [s] [mean,'',f5.1]
              + duringDelivery [s] [mean,'',f5.1] 
              + byBreastfeeding [s] [mean,'',f5.1] 
              + atLeastOne [s] [mean,'',f5.1]
              + allThree [s] [mean,'',f5.1] )
         + none [s] [mean,'',f5.1])
         + numMen[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /title title=
    "Table HA.2M: Knowledge of mother-to-child HIV transmission (men)"
    "Percentage of men age 15-49 years who correctly identify means of HIV transmission from mother to child, " + surveyname
   caption = 
    "[1] MICS indicator 9.2 - Knowledge of mother-to-child transmission of HIV "
  .

new file.
