* MICS5 RH-15.

* v01 - 2014-03-19.
* v02 - 2014-04-21.
* Table note b has been changed to include the additional text “by any health provider” in the first sentence.
* The comment describing “No PNC visit” has been updated.

* v03 - 2015-04-21.
* "2 days" added to condition: if (healthCheck = 100 or (pncVisitM = 1 or pncVisitM = 2 or pncVisitM = 3)) pncCheck = 100.


* Health check following birth while in facility: PN4=1
  Health check at home following birth: PN8=1
  No PNC visit: PN16><1 AND PN18><1 AND PN19><1
  PNC visit within 2 days of birth: PN21A or PN21B= 100 through 199, 201, 202 (not to include 298, 299) AND PN22=A through G .

***.
include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

* select women that gave birth in two years preceeding the survey.
select if (CM13 = "Y" or CM13 = "O").

* definitions of anc, ageAtBirth .
include 'define\MICS5 - 06 - RH.sps' .

* Health check following birth while in facility or while at home.
compute healthCheck = 0.
if (PN4 = 1 or PN8 = 1) healthCheck = 100.
variable labels healthCheck "Health check following birth while in facility or at home [a]".

compute pncCheck = 0.
if (healthCheck = 100 or (pncVisitM =1 or pncVisitM = 2 or pncVisitM = 3)) pncCheck = 100.
variable labels pncCheck "Post-natal health check for the mother [1], [c]".

compute numWomen = 1.
variable labels numWomen "Number of women who gave birth in the two years preceding the survey".
value labels  numWomen 1 "".

compute total = 1.
variable labels total "Total".
value labels  total 1 " ".

variable labels pncVisitM "PNC visit for mothers [b]".

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + deliveryType [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]
     by
           healthCheck [s] [mean,'',f5.1]
         + pncVisitM [c] [rowpct.validn,'',f5.1]
         + pncCheck [s] [mean,'',f5.1]
         + numWomen[s] [count,'',f5.0]
  /categories variables=all empty=exclude
  /categories variables=pncVisitM empty=exclude total=yes
  /slabels position=column visible=no
  /titles title="Table RH.15: Post-natal health checks for mothers"
	"Percentage of women age 15-49 years with a live birth in the last two years who received health checks "+
	"while in facility or at home following birth, percent distribution who received post-natal care (PNC) visits from "+
	"any health provider after birth at the time of last birth, by timing of visit, and percentage who received post natal health checks, " + surveyname
   caption=
 "[1] MICS indicator 5.12 - Post-natal health check for the mother"
 "[a] Health checks by any health provider following facility births (before discharge from facility) or following home births (before departure of provider from home)."									
 "[b] Post-natal care visits (PNC) refer to a separate visit by any health provider to check on the health of the mother and provide preventive care services. "
  "PNC visits do not include health checks following birth while in facility or at home (see note a above)."							
 "[c] Post-natal health checks include any health check performed while in the health facility or at home following birth (see note a above), as well as PNC visits (see note b above) within two days of delivery.".						
									
new file.
