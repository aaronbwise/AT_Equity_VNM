* Encoding: windows-1252.
 * "Men who know of a place to get tested for HIV includes those who have already been tested (MHA24=1) or those who report that they know of a place to get tested (MHA27=1).

 * Men who have ever been tested: MHA24=1; those who know the result are MHA26=1.

 * Men who have been tested for HIV during the last 12 months includes MHA25=1; those who know the results are MHA26=1.

 * Those who have heard of test kits are those responding 'yes' to MHA28; those who have used are MHA29=1.

 * The denominator of the table includes all men, including those who have not heard of AIDS (MHA1=2). 

 * The background characteristic of Age and sexual activity in the last 12 months is the total disaggregated first by sexual activity in the last 12 months and second, for only 
   the sexually active respondents, by age. This is done to calculate MICS indicator TM.35."								
						
										

***.

* v02.2019-03-14.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.
***.

include "surveyname.sps".

get file = 'mn.sav'.

include "CommonVarsMN.sps".

select if (MWM17 = 1).

weight by mnweight.

* include TM.M . 
include 'define\MICS6 - 06 - TM.M.sps' .

compute sexuallyactive=99.
if sex12=100 sexuallyactive=1.

if sex12 = 100 magesex = MWB4.
recode magesex (15 thru 24 = 10) (25 thru 49 = 20) into mwagesex1.
recode magesex (15 thru 19 = 11) (20 thru 24 = 14) into mwagesex2.
recode magesex (15 thru 17 = 12) (18 thru 19 = 13) into mwagesex3.

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
  /mcgroup name = $mwagesex
           label = 'Age and sexual activity in the last 12 months'
           variables = sexuallyactive mwagesex1 mwagesex2 mwagesex3.


compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of men who:".

compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* ctables command in English.
ctables
  /vlabels variables =  numMen layer1  total
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + $mwagez [c]
         + $mwagesex [c]
         + mwelevel [c]
         + mmstatus2 [c]
         + mdisability [c]
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
         + numMen [c] [count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table TM.11.4M: Knowledge of a place for HIV testing (men)"
    "Percentage of men age 15-49 years who know where to get an HIV test, percentage who have ever been tested, percentage who have ever been tested and know the" +
    "result of the most recent test, percentage who have been tested in the last 12 months, and percentage who have been tested in the last 12 months and know the result, and " + 
    "percentage who have heard of HIV self-test kits and have tested themselves,"  + surveyname
   caption =
    "[1] MICS indicator TM.32 - People who know where to be tested for HIV" 								
    "[2] MICS indicator TM.33 - People who have been tested for HIV and know the results" 								
    "[3] MICS indicator TM.34 - Sexually active young people who have been tested for HIV and know the results" 								
    "[A] Having heard of or having used a test kit are not included in any MICS indicators relating to HIV testing".								
													
new file.
