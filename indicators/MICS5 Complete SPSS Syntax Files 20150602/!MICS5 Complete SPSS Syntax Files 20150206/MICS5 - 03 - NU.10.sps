* MICS5 NU-10.

* v02 - 2014-03-05.

* Adequately iodized salt is defined as salt that contains at least 15 parts per million of iodine (SI1=3).
* If a household has salt, but it was not tested (SI1=5), it is omitted from the denominator of the indicator.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

compute numHouseholds  = 1.
value labels numHouseholds 1 "Number of households".
variable labels numHouseholds "".

recode SI1 (4 = 100) (else = 0) into noSalt.
variable labels noSalt "Percent of households with no salt".

recode SI1 (1,2,3 = 100) (else = 0) into saltTest.
variable labels saltTest "Percent of households in which salt was tested".

recode SI1 (4 = 0)  (1, 2, 3 = copy) (else = sysmis) into testResult.
variable labels testResult "Percent of households with salt test result".
value labels testResult
  0 "Percent of households with no salt"
  1 "Not iodized 0 PPM"
  2 ">0 and <15 PPM"
  3 "15+ PPM [1]".

do if (noSalt  = 100 or saltTest  = 100).
compute numHouseholdsTestedOrNoSalt = 1.
variable labels numHouseholdsTestedOrNoSalt "".
value labels numHouseholdsTestedOrNoSalt 1 "Number of households in which salt was tested or with no salt".
end if.

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute total100 = 100.
variable labels total100 "Total".
value labels total100 100" ".


* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = numHouseholds numHouseholdsTestedOrNoSalt
             display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + windex5 [c]
   by
           saltTest [s] [mean,'',f5.1]
         + numHouseholds [c] [count,'',f5.0]
         + testResult [c] [rowpct.validn,'',f5.1]
         + total100 [s] [mean,'',f5.1]
         + numHouseholdsTestedOrNoSalt [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table NU.10: Iodized salt consumption"
    "Percent distribution of households by consumption of iodized salt, " + surveyname
   caption =
    "[1] MICS indicator 2.19 - Iodized salt consumption".

new file.
