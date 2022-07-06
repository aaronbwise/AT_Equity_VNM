* MICS5 HA-07.

* v02 - 2014-04-02.
* v03 - 2014-04-22.
* An extra column has been inserted (E).
* In title, “HIV/AIDS” has been replaced with “HIV and AIDS”.
* In sub-title, “HIV/AIDS” has been replaced with “HIV and AIDS”.
* In column C, the word “from” was repeated and one has been deleted.
* In column J, “HIV/AIDS” has been replaced with “HIV”. A table note has been inserted.
* The table note for “na” has been deleted and replaced by “a Refer to Table HA.3 for the four indicators.”
* v04 - 2014-05-08.
*** “include 'define\MICS5 - 10 - HA.sps' .” moved above age selection, 
to ensure same most common misconceptions for all women (15-49) are taken into account when calculating indicator “Comprehensive knowledge”.



* All columns in this table are presenting disaggregated information for women age 15-24 years that is already described in the respective tables
  for women age 15-49 years. 
* Please refer to these tables for detailed information on calculations:
    Comprehensive knowledge: HA_1
    Know means of HIV transmission from mother to child: HA_2
    Know a place to get tested for HIV: HA_4
    Tested for HIV in the last 12 months and have been told result (all women and those sexually active): HA_4
    Sex in the last 12 months: HA_6
    Accepting atitudes: HA_3 .

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

*** include HA . 
include 'define\MICS5 - 10 - HA.sps' .

select if (wage = 1 or wage = 2) .

* relabeling variables to delete [1] of the indicator from variable knowPlace in define HA syntax.
variable labels knowPlace "Know a place to get tested for HIV".

* relabeling variables to correspond to tab plan.
variable labels comprehensiveKnowledge "Have comprehensive knowledge [1]".
variable labels toldResult12 "Have been tested for HIV in the last 12 months and know the result".
variable labels allThree "Know all three means of HIV transmission from mother to child".

if (HA1 ~= 1) all4Attitudes = $sysmis .
variable labels all4Attitudes "Percentage who express accepting attitudes towards people living with HIV on all four indicators [a]".

recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status".
add value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode wage (1 = 1) (2 = 4) into wageAux1 .
recode WB2
 (15 thru 17 = 2)
 (18 thru 19 = 3)
 (20 thru 22 = 5)
 (23 thru 24 = 6) into wageAux2 .

variable labels wageAux1 "Age".
value labels wageAux1
1 "15-19"
2 "    15-17"
3 "    18-19"
4 "20-24"
5 "    20-22"
6 "    23-24" .

mrsets
  /mcgroup name=$wage
   label='Age'
   variables=wageAux1 wageAux2 .

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women age 15-24 years who:".

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women age 15-24 years".

compute numSex12 = sex12 / 100 .
variable labels numSex12 "Number of women age 15-24 years who had sex in the last 12 months " .

compute numHeardOfAIDS = heardOfAIDS / 100 .
variable labels numHeardOfAIDS "Number of women age 15-24 years who have heard of AIDS" .

do if (sex12 = 100).
+ compute toldResultActive = toldResult12.
end if.
variable labels toldResultActive "Percentage of sexually active young women who have been tested for HIV in the last 12 months and know the result [2]" .

* remove indicator number from variable toldResult12.
variable labels toldResult12 "Have been tested in the last 12 months and know the result".


* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total numWomen layer numWomenMorePartners
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + $wage [c]
         + mstatus [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           layer [c]  > (
             comprehensiveKnowledge [s] [mean,'',f5.1]
           + allThree [s] [mean,'',f5.1]
           + knowPlace [s] [mean,'',f5.1]
           + toldResult [s] [mean,'',f5.1]
           + toldResult12 [s] [mean,'',f5.1]
           + sex12 [s] [mean,'',f5.1] )
         + numWomen [c] [count,'',f5.0]
         + toldResultActive [s] [mean,'',f5.1] 
         + numSex12 [s] [sum,'',f5.0]
         + all4Attitudes [s] [mean,'',f5.1] 
         + numHeardOfAIDS [s] [sum,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /title title=
    "Table HA.7: Key HIV and AIDS indicators (young women)"
    "Percentage of women age 15-24 years by key HIV and AIDS indicators, " + surveyname
   caption=
    "[1] MICS indicator 9.1; MDG indicator 6.3 - Knowledge about HIV prevention among young women"
    "[2] MICS indicator 9.6 - Sexually active young women who have been tested for HIV and know the results"
    "[a] Refer to Table HA.3 for the four indicators."
  .

new file.
