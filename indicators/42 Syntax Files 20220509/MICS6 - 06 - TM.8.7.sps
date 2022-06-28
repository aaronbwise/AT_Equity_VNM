* Encoding: UTF-8.
***.

* v02. 2019-03-14.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

*select women that gave birth in two years preceeding the survey.
select if (CM17 = 1).

* definitions of anc, ageAtBirth .
include 'define\MICS6 - 06 - TM.sps' .

* Health check following birth while in facility or while at home.
compute healthCheck = 0.
if (PN5 = 1 or PN9 = 1) healthCheck = 100.
variable labels healthCheck "Health check following birth while in facility or at home [A]".

compute pncCheck = 0.
if (healthCheck = 100 or (pncVisitM =1 or pncVisitM = 2 or pncVisitM = 3)) pncCheck = 100.
variable labels pncCheck "Post-natal health check for the mother [1] [C]".

compute numWomen = 1.
variable labels numWomen "Number of women with a live birth in the last 2 years".
value labels  numWomen 1 "".

compute total = 1.
variable labels total "Total".
value labels  total 1 " ".

variable labels pncVisitM "PNC visit for mothers [B]".  
variable labels bh3_last "Sex of newborn".
   
* Ctables command in English.
ctables
  /table   total [c]
         + bh3_last [c]
         + hh6 [c]
         + hh7 [c]
         + welevel [c]
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + deliveryType [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]   
     by
           healthCheck [s] [mean '' f5.1]
         + pncVisitM [c] [rowpct.validn '' f5.1]
         + pncCheck [s] [mean '' f5.1]
         + numWomen[s] [count '' f5.0]
  /categories variables=all empty=exclude
  /categories variables=pncVisitM empty=exclude total=yes
  /slabels position=column visible=no
  /titles title="Table TM.8.7: Post-natal health checks for mothers"
	"Percentage of women age 15-49 years with a live birth in the last 2 years who for the most recent live birth received health checks while in facility or at home following birth, " +
                  "percent distribution who received post-natal care (PNC) visits from any health provider after birth at the time of last birth, by timing of visit, and percentage who received post-natal health checks," + surveyname
   caption=
 "[1] MICS indicator TM.20 - Post-natal health check for the mother"
 "[A] Health checks by any health provider following facility births (before discharge from facility) or following home births (before departure of provider from home)."									
 "[B] Post-natal care visits (PNC) refer to a separate visit by any health provider to check on the health of the mother and provide preventive care services. "
  "PNC visits do not include health checks following birth while in facility or at home (see note A above)."							
 "[C] Post-natal health checks include any health check performed while in the health facility or at home following birth (see note A above), as well as PNC visits (see note B above) within two days of delivery.".	
												
new file.
