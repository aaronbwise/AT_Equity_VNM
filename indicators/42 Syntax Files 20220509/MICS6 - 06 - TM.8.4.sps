* Encoding: UTF-8.
 * "Children who were dried after birth are those responding 'yes' to MN26 (MN26=1).

 * Those given skin-to-skin contact are those that were placed on the mother's bare skin of the chest and were not wrapped up (MN23=1 and MN24=2).

 * The timing of first bath is distributed between those that were bathed within 6 hours (MN26=000 or MN26<106), those bathed at 6-23 hours (MN26>105 and <123) and 
   those bathed after their first day of life (MN26>201 and <997). Those never bathed (did not live long enough to be bathed) and those for whom the mother does not know or 
   remember are MN26=997 and MN26=998, respectively."										

***.
*v02. 2019-03-14.
*v03 - 2020-04-21. Table sub-title changed based on the latest tab plan. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

*select women that gave birth in two years preceeding the survey.
select if (CM17 = 1).

include 'define\MICS6 - 06 - TM.sps' .

compute driedatbirth=0.
if (MN25 = 1) driedatbirth=100.
variable labels driedatbirth "Dried (wiped) after birth [1]".

compute skintoskin=0.
if (MN23 = 1 and MN24 = 2) skintoskin=100.
variable labels skintoskin "Given skin-to-skin contact with mother [2]".

compute MN26hours=MN26U*100+MN26N.

recode MN26hours (0 thru 105=1)  (106 thru 123=2) (124 thru 996=3) (997 = 4) (998 thru highest = 9) into bathtime.
variable labels bathtime "Timing of first bath".  

value labels bathtime 1 "Less than 6 hours after birth" 2 "6-23 hours after birth" 3 "24 hours or more after birth [3]" 4 "Never bathed [A]" 9 "DK/Don't remember".
 
compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of children who were:".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Timing of first bath:".

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women with a live birth in the last 2 years".

variable labels welevel "Education".
variable labels ageAtBirth "Age at most recent live birth".
variable labels disability "Functional difficulties (age 18-49 years)".
variable labels bh3_last "Sex of newborn".

compute total = 1.
variable labels total "".
value labels total 1 "Total".
   
* ctables command in English.
ctables
  /vlabels variables =  numWomen layer1 layer2  total
           display = none
  /table   total [c]
         + bh3_last [c]
         + hh6 [c]
         + hh7 [c]
         + welevel [c]
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]   
   by
         layer1 [c] > (
             driedatbirth  [s] [mean '' f5.1]
           + skintoskin [s] [mean '' f5.1])
           + bathtime [c] [rowpct.validn '' f5.1]
         + numWomen [c] [count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /categories variables=bathtime total=yes position= after label= "Total"
  /slabels visible = no
  /titles title=
    "Table TM.8.4: Thermal care for newborns"
    "Percentage of women age 15-49 years with a live birth in the last 2 years whose most recent live-born child was dried after birth and percentage given skin to skin contact and percent distribution by timing of first bath of child, " + surveyname
   caption =
    "[1] MICS indicator TM.14 - Newborns dried"
    "[2] MICS indicator TM.15 - Skin-to-skin care"
    "[3] MICS indicator TM.16 - Delayed bathing"
    "[A] Children never bathed includes children who at the time of the survey had not yet been bathed because they were very young and children dying so young that they were never bathed".																			
  .

new file.
