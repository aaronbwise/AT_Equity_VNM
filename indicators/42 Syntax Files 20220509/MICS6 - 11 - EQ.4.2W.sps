* Encoding: windows-1252.
 * "Women who think that their life has improved during the last one year: LS3=1.
 * Women who expect that their life will get better after one year: LS4=1.
 * Women who think their life has been improving and will continue to improve: (LS3=1 and LS4=1)."									

***.

* v02 - 2019-08-28. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-21  Labels in French and Spanish have been removed.

include "surveyname.sps".

get file="wm.sav".

include "CommonVarsWM.sps".

select if (WM17 = 1).

* Weight the data by the women weight.
weight by wmweight.

* Generate total variable.
compute numWomen = 1.
variable labels numWomen "Number of women age 15-49 years".

compute lifeimproved=0.
if LS3=1 lifeimproved=100.
variable labels lifeimproved "Improved during the last one year".

compute lifebetter=0.
if LS4=1 lifebetter=100.
variable labels lifebetter "Will get better after one year".

compute lifeboth=0.
if (LS3=1 and LS4=1) lifeboth=100.
variable labels lifeboth "Both [2]".


do if (wage <=2).
+compute numWomen1524 = 1.
+variable labels numWomen1524 "Number of women age 15-24 years".
+ compute lifeimproved1524=0.
+ if LS3=1 lifeimproved1524=100.
+ compute lifebetter1524=0.
+ if LS4=1 lifebetter1524=100.
+ compute lifeboth1524=0.
+ if (LS3=1 and LS4=1) lifeboth1524=100.
end if.

variable labels lifeimproved1524 "Improved during the last one year".
variable labels lifebetter1524 "Will get better after one year".
variable labels lifeboth1524 "Both [1]".

compute layer1 = 1.
variable labels layer1 "".
value labels layer1 1 "Percentage of women age 15-24 years who think that their life".
compute layer2 = 1.
variable labels layer2 "".
value labels layer2 1 "Percentage of women age 15-49 years who think that their life".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables =  total layer1 layer2
         display = none
  /format missing = "na" 
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + $wage [c]
         + welevel [c]
         + mstatus2 [c]
         + disability [c]
         + ethnicity [c]
         + windex5 [c]
     by
          layer1 [c] > 
           (lifeimproved1524 [s] [mean '' f5.1]
        + lifebetter1524 [s] [mean '' f5.1]
        + lifeboth1524 [s] [mean '' f5.1]) 
        + numWomen1524 [s] [sum, '', f5.0]
        + layer2 [c] > 
           (lifeimproved [s] [mean '' f5.1]
        + lifebetter [s] [mean '' f5.1]
        + lifeboth [s] [mean '' f5.1])
        + numWomen [s] [sum, '', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table EQ.4.2W: Perception of a better life (women)"
     "Percentage of women age 15-24 and 15-49 years who think that their lives improved during the last one year and those who expect that their lives will get better after one year, " + surveyname
   caption=
 "[1] MICS indicator EQ.11a - Perception of a better life among women age 15-24 years" 
 "[2] MICS indicator EQ.11b - Perception of a better life among women age 15-49 years" 
 "na: not applicable".							

new file.
