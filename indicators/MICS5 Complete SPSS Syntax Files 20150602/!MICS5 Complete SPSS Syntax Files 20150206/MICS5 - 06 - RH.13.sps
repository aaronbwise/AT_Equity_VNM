* MICS5 RH-13.

* v01 - 2014-03-19.
* v02 - 2014-04-21.
* Table note b has been changed to include the additional text “by any health provider” in the first sentence.
* The comment describing “No PNC visit” has been updated.

* v03 - 2015-04-21.
* "2 days" added to condition: if (healthCheck = 100 or (pncVisitC = 1 or pncVisitC = 2 or pncVisitC = 3)) pncCheck = 100.

* Health check following birth while in facility: PN3=1
  Health check following birth while at home: PN7=1
  No PNC visit: PN9><1 and PN10><1
  PNC visit within 2 days of birth: PN12A, PN12B= 100 through 199, 201, 202 (not to include 298, 299) AND PN13=A through G .

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

* select women that gave birth in two years preceeding the survey.
select if (CM13 = "Y" or CM13 = "O" or CM13 = "S").

* definitions of anc, ageAtBirth .
include 'define\MICS5 - 06 - RH.sps' .

* Health check following birth while in facility or while at home.
compute healthCheck = 0.
if (PN3 = 1 or PN7 = 1) healthCheck = 100.
variable labels healthCheck "Health check following birth while in facility or at home [a]".

compute pncCheck = 0.
if (healthCheck = 100 or (pncVisitC = 1 or pncVisitC = 2 or pncVisitC = 3)) pncCheck = 100.
variable labels pncCheck "Post-natal health check for the newborn [1], [c]".

compute numBirths = 1.
variable labels numBirths "Number of last live births in the last two years".
value labels numBirths 1 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

variable labels pncVisitC "PNC visit for newborns [b]".

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]        
   by
           healthCheck [s] [mean,'',f5.1]
         + pncVisitC [c] [rowpct.validn,'',f5.1]
         + pncCheck [s] [mean,'',f5.1]
         + numBirths[s] [count,'',f5.0]
  /categories var=all empty=exclude
  /categories var=pncVisitC total=yes label='Total'
  /slabels position=column visible=no
  /titles title=
	"Table RH.13: Post-natal health checks for newborns"
	"Percentage of women age 15-49 years with a live birth in the last two years whose last live birth received health "
	"checks while in facility or at home following birth, percent distribution whose last live birth received post-natal care (PNC) visits "
	 "from any health provider after birth, by timing of visit, and percentage who received post natal health checks, "									
	 + surveyname
  caption=
     "[1] MICS indicator 5.11 - Post-natal health check for the newborn"
     "[a]  Health checks by any health provider following facility births (before discharge from facility) or following home births (before departure of provider from home)."
     "[b] Post-natal care visits (PNC) refer to a separate visit by any health provider to check on the health of the newborn and provide preventive care services. "
           "PNC visits do not include health checks following birth while in facility or at home (see note a above)."
     "[c] Post-natal health checks include any health check performed while in the health facility or at home following birth (see note a above), as well as PNC visits (see note b above) within two days of delivery."
  .


new file.
