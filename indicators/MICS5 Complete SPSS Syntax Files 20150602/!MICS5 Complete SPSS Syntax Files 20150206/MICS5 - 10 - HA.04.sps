* MICS5 HA-04.

* v01 - 2014-03-18.
* v02 - 2014-04-21.
* An extra column has been inserted (D).
* Subtitle has changed to include description of the result.
* An extra comment has been inserted to describe the algorithm.
* v03 - 2014-08-19.
* added 15-49 to Number of women label.


* Women who know of a place to get tested for HIV includes those who have already been tested
   (HA16=1 or HA20=1 or HA22=1 or HA24=1) and those who report that they know of a place to get tested (HA27=1).

* Women who have ever been tested includes HA16=1 or HA20=1 or HA22=1 or HA24=1.

* Women who have been tested for HIV during the last 12 months includes HA23=1 or HA25=1; those who have been told the results are
   (a) HA23=1 and (HA17=1 or HA21=1) or
   (b) HA25=1 and HA26=1.

* The denominator of the table includes all women, including those who have not heard of AIDS (HA1=2).

* The background characteristic of Age and sexual activity in the last 12 months is the total disaggregated first by sexual activity in the last
  12 months and second, for only the sexually active respondents, by age.
* This is done to obtain MICS indicator 9_6 .

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.


* include HA . 
include 'define\MICS5 - 10 - HA.sps' .

recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status".
add value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode wage (1 = 2) (2 = 3) into wageAux2 .

recode wage (1, 2 = 1) (3 = 4) (4, 5 = 5) (6, 7 = 6) into wageAux1 .
variable labels wageAux1 "Age".
value labels wageAux1
 1 "15-24"
 2 "    15-19"
 3 "    20-24"
 4 "25-29"
 5 "30-39"
 6 "40-49" .

mrsets
  /mcgroup name=$wage
   label='Age'
   variables=wageAux1 wageAux2 .

compute sexActiveAux1 = 6 .
if ((SB3U=1 and SB3N<365) or
    (SB3U=2 and SB3N<52)  or
    (SB3U=3 and SB3N<12) ) sexActiveAux1 = 1 .
do if (sexActiveAux1 = 1) .
+ recode wage (1 = 3) (2 = 4) into sexActiveAux3 .
+ recode wage (1, 2 = 2) (3, 4, 5, 6, 7 = 5) into sexActiveAux2 .
end if.

value labels sexActiveAux1
  1 "Sexually active"
  2 "15-24 [3]"
  3 "    15-19"
  4 "    20-24"
  5 "25-49"
  6 "Sexually inactive" .

mrsets
  /mcgroup name=$sexActive
   label='Age and sexual activity in the last 12 months'
   variables=sexActiveAux1 sexActiveAux2 sexActiveAux3 .

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percent of women who:".

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women age 15-49".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = numWomen total layer 
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + $wage [c]
         + $sexActive [c]
         + mstatus [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           layer [c]  > (
             knowPlace [s] [mean,'',f5.1]
           + beenTested [s] [mean,'',f5.1]
           + toldResult [s] [mean,'',f5.1]
           + tested12 [s] [mean,'',f5.1]
           + toldResult12 [s] [mean,'',f5.1] )
         + numWomen[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /title title=
    "Table HA.4: Knowledge of a place for HIV testing (women)"
    	"Percentage of women age 15-49 years who know where to get an HIV test, percentage who have ever been tested, " +
    	"percentage who have ever been tested and know the result of the most recent test, percentage who have been tested in the last 12 months, " 
    	"and percentage who have been tested in the last 12 months and know the result, " + surveyname
  caption =
      "[1] MICS indicator 9.4 - Women who know where to be tested for HIV"
      "[2] MICS indicator 9.5 - Women who have been tested for HIV and know the results"
      "[3] MICS indicator 9.6 - Sexually active young women who have been tested for HIV and know the results"
  .

new file.
