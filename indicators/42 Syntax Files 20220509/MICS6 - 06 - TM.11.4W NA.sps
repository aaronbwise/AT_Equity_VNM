* Encoding: windows-1252.
 * "Women who know of a place to get tested for HIV includes those who have already been tested (HA14=1 or HA19=1 or HA22=1 or HA24=1) or those who report that they know of a place to get tested (HA27=1).

 * Women who have ever been tested includes HA14=1 or HA19=1 or HA22=1 or HA24=1; those who know the result of the most recent test are (a) HA22=2 and (HA15=1 or HA20=1) or (b) HA26=1.

 * Women who have been tested for HIV during the last 12 months includes HA23=1 or HA25=1; those who know the results are (a) HA23=1 and (HA15=1 or HA20=1) or (b) HA25=1 and HA26=1.

 * Those who have heard of test kits are those responding 'yes' to HA28; those who have used are HA29=1.

 * The denominator of the table includes all women, including those who have not heard of AIDS (HA1=2). 

 * The background characteristic of Age and sexual activity in the last 12 months is the total disaggregated first by sexual activity in the last 12 months and second, for only the sexually active 
   respondents, by age. This is done to obtain MICS indicator TM.35."								
										

***.
* v02.2019-03-14.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

include 'define\MICS6 - 06 - TM.sps' .

compute sexuallyactive=99.
if sex12=100 sexuallyactive=1.

if sex12 = 100 agesex = WB4.
recode agesex (15 thru 24 = 10) (25 thru 49 = 20) into wagesex1.
recode agesex (15 thru 19 = 11) (20 thru 24 = 14) into wagesex2.
recode agesex (15 thru 17 = 12) (18 thru 19 = 13) into wagesex3.

value labels sexuallyactive
     1  "Sexually active"
    10 "15-24 [3]"
    11 "   15-19"
    12 "      15-17"
    13 "      18-19"
    14 "   20-24"
    20 "25-49"
    99  "Sexually inactive".

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $wagesex
           label = 'Age and sexual activity in the last 12 months'
           variables = sexuallyactive wagesex1 wagesex2 wagesex3.

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of women who:".

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* ctables command in English.
ctables
  /vlabels variables =  numWomen layer1  total
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + $wagez [c]
         + $wagesex [c]
         + welevel [c]
         + mstatus2 [c]
         + disability [c]
         + ethnicity [c]
         + windex5 [c]
   by
         layer1 [c] > (
             knowPlace  [s] [mean '' f5.1]
           + beenTested [s] [mean '' f5.1]
           + toldResult [s] [mean '' f5.1]
           + tested12 [s] [mean '' f5.1]
           + toldResult12 [s] [mean '' f5.1]
           + testkit [s] [mean '' f5.1] 
           + selftestkit [s] [mean '' f5.1])
         + numWomen [c] [count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table TM.11.4W: Knowledge of a place for HIV testing (women)"
    "Percentage of women age 15-49 years who know where to get an HIV test, percentage who have ever been tested, percentage who have ever been tested and know the " + 
    "result of the most recent test, percentage who have been tested in the last 12 months, percentage who have been tested in the last 12 months and know the result, and " + 
    "percentage who have heard of HIV self-test kits and have tested themselves, " + surveyname
   caption =
    "[1] MICS indicator TM.32 - People who know where to be tested for HIV" 								
    "[2] MICS indicator TM.33 - People who have been tested for HIV and know the results" 								
    "[3] MICS indicator TM.34 - Sexually active young people who have been tested for HIV and know the results" 								
    "[A] Having heard of or having used a test kit are not included in any MICS indicators relating to HIV testing".								

new file.
