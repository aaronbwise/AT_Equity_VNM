* Encoding: windows-1252.
* MICS5 TC-9.1.
***.
* v02 - 2020-04-23. Table has been updated to reflect the change in salt test kits. Labels in French and Spanish have been removed.
***.
* Iodised salt is salt testing positive for any iodine content. If a household has salt, but it was not tested (SA1=6 or SA2=6), it is omitted from the denominator of the indicator.

* In mid-2019, improved salt test kits became available for use in surveys. Depending on the kit used in your survey make sure to uncomment or comment out relevant parts of syntax. 

* Note if the survey tested for both iodate and iodide, the syntax should be customised to allow positive results from all four tests.

***.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH46 = 1).

weight by hhweight.

compute numHouseholds  = 1.
value labels numHouseholds 1 "Number of households".
variable labels numHouseholds "".

* No salt in the household.
recode SA1 (4 = 100) (else = 0) into noSalt.
variable labels noSalt "Percentage of households with no salt".

* Previous kits.
recode SA1 (1,2,3 = 100) (else = 0) into saltTest.
* New kits.
*recode SA1 (1,5 = 100) (else = 0) into saltTest.
variable labels saltTest "Percentage of households in which salt was tested".

* If the improved kits (with only reaction/no reaction result) were used, then iodised salt: SA1=5 or SA2=5. If the previous kits were used (with 0/0-15/15+ result), then iodised salt: SA1=2 or 3 or SA2=2 or 3.
do if (noSalt  = 100 or saltTest  = 100).
* Previous kits.
+ recode SA1 (4 = 0)  (1 = 1) (2, 3 = 2) (else = sysmis) into testResult.
+ if (testResult = 1 and SA2 = 1) testResult = 1.
+ if (testResult = 1 and (SA2 = 2 or SA2 = 3)) testResult = 2.
* New kits.
* + recode SA1 (4 = 0)  (1 = 1) (5 = 2) (else = sysmis) into testResult.
* + if (testResult = 1 and SA2 = 1) testResult = 1.
* + if (testResult = 1 and SA2 = 5) testResult = 2.
+ compute numHouseholdsTestedOrNoSalt = 1.
variable labels numHouseholdsTestedOrNoSalt "".
value labels numHouseholdsTestedOrNoSalt 1 "Number of households in which salt was tested or with no salt".
end if.

variable labels testResult "Percentage of households with salt test result".

value labels testResult
  0 "No salt"
  1 "Salt test result: Not iodized 0 ppm"
  2 "Salt test result: Iodised >0 ppm [1]"
.

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute total100 = 100.
variable labels total100 "Total".
value labels total100 100" ".

* Ctables command in English.
ctables
  /vlabels variables = numHouseholds numHouseholdsTestedOrNoSalt
             display = none
  /table   total [c]
         + hh6[c]
         + hh7 [c]
         + windex5 [c]
   by
           saltTest [s] [mean '' f5.1]
         + numHouseholds [c] [count '' f5.0]
         + testResult [c] [rowpct.validn '' f5.1]
         + total100 [s] [mean '' f5.1]
         + numHouseholdsTestedOrNoSalt [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table TC.9.1: Iodised salt consumption"
    "Percent distribution of households by consumption of iodised salt, " + surveyname
   caption =
    "[1] MICS indicator TC.48 - Iodised salt consumption"
.

new file.
