* MICS5 WS-10.

* v01 - 2014-03-03.
* v02 - 2014-08-19.
* Variable label "soap" and table title updated.

* Households with soap anywhere in the dwelling are those where soap was observed by the interviewer at the place for handwashing (HW3=A, B, C or D) 
* and those households where soap was not observed at the place for handwashing but soap was shown to the interviewer (HW5=A, B, C, or D)

*Soap includes bar soap, powder, liquid or paste detergent and liquid soap; other cleansing agents include ash, mud or sand (if used in the country).



* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

compute total = 1.
variable labels total "".
value labels total 1 "Number of households".

compute observed = 2.
if (HW1 = 1) observed = 1.
variable labels observed "".
value labels observed
  1 "Place for handwashing observed"
  2 "Place for handwashing not observed".

compute sshown = 9.
if (HW3BA = "A" or HW3BB = "B" or HW3BC = "C" or HW3BD = "D") sshown = 1.
if (sshown = 9 and HW4 = 1 and (HW5BA  = "A" or HW5BB = "B" or HW5BC = "C" or HW5BD = "D")) sshown  = 2.
if (sshown = 9 and HW4 <> 1) sshown  = 3.
if (sshown = 9 and HW4 = 1 and HW5A <> 1) sshown  = 4.
variable labels sshown "".
value labels sshown
  1 "Soap or other cleansing agent observed"
  2 "Soap or other cleansing agent not observed: Soap  or other cleansing agent shown"
  3 "Soap or other cleansing agent not observed at place for handwashing: No soap or other cleansing agent in household"
  4 "Soap or other cleansing agent not observed at place for handwashing: Not able/Does not want to show cleansing agent"
  9 "Missing".
* Please include entire label for value 4 "Soap or other cleansing agent not observed at place for handwashing: Not able/Does not want to show soap or other cleansing agent" in the tab plan.
* part >soap or other< excluded as label command exceeds 120 characters in length.

compute soap = 0.
if (HW3BA = "A" or HW3BB = "B" or HW3BC = "C" or HW3BD = "D"or HW5BA  = "A" or HW5BB = "B" or HW5BC = "C" or HW5BD = "D") soap = 100.
variable labels soap "Percentage of households with soap or other cleansing agent anywhere in the dwelling [1]".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot observed sshown
         display = none
 /table   tot [c]
         + hh7 [c]
         + hh6 [c]
         + helevel [c]
         + windex5 [c]
         + ethnicity [c] by
   	observed [c] > sshown [c] [layerrowpct.validn,'',f5.1] + tot1 [s] [mean,'',f5.1] + soap [s] [mean,'',f5.1]  + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table WS.10: Availability of soap or other cleansing agent"
		"Percent distribution of households by availability of soap or other cleansing agent in the dwelling, " + surveyname
  caption =
   "[1] MICS indicator 4.6 - Availability of soap or other cleansing agent".

new file.
