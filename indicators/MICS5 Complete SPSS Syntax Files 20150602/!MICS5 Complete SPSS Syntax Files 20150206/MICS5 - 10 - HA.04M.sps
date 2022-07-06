* MICS5 HA-04M.

* v01 - 2014-03-18.
* v02 - 2014-06-09.
* Table title changed.
* v03 - 2014-08-19.
* added 15-49 to Number of men label.

* Men who know of a place to get tested for HIV includes those who have already been tested (MHA24=1)
  and those who report that they know of a place to get tested (MHA27=1).

* Men who have ever been tested: MHA24=1.

* Men who have been tested for HIV during the last 12 months includes MHA25=1; those who have been told the results are MHA26=1.

* The denominator of the table includes all men, including those who have not heard of AIDS (MHA1=2).

* The background characteristic of Age and sexual activity in the last 12 months is the total disaggregated first by sexual activity in the last 12 months and second, for only the sexually active respondents, by age.
* This is done to calculate MICS indicator 9_6 .

***.


include "surveyname.sps".

get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.

* include HA . 
include 'define\MICS5 - 10 - HA.M.sps' .

recode mmstatus (1,2 = 1) (3 = 2).
variable labels mmstatus "Marital status".
add value labels mmstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode mwage (1 = 2) (2 = 3) into mwageAux2 .

recode mwage (1, 2 = 1) (3 = 4) (4, 5 = 5) (6, 7 = 6) into mwageAux1 .
variable labels mwageAux1 "Age".
value labels mwageAux1
 1 "15-24"
 2 "    15-19"
 3 "    20-24"
 4 "25-29"
 5 "30-39"
 6 "40-49" .

mrsets
  /mcgroup name=$mwage
   label='Age'
   variables=mwageAux1 mwageAux2 .

compute sexActiveAux1 = 6 .
if ((MSB3U=1 and MSB3N<365) or
    (MSB3U=2 and MSB3N<52)  or
    (MSB3U=3 and MSB3N<12) ) sexActiveAux1 = 1 .
do if (sexActiveAux1 = 1) .
+ recode mwage (1 = 3) (2 = 4) into sexActiveAux3 .
+ recode mwage (1, 2 = 2) (3, 4, 5, 6, 7 = 5) into sexActiveAux2 .
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
value labels layer 0 "Percent of men who:".

compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men age 15-49" .

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = numMen total layer display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + $mwage [c]
         + $sexActive [c]
         + mmstatus [c]
         + mwelevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           layer [c]  > (
             knowPlace [s] [mean,'',f5.1]
           + beenTested [s] [mean,'',f5.1]
           + toldResult [s] [mean,'',f5.1]
           + tested12 [s] [mean,'',f5.1]
           + toldResult12 [s] [mean,'',f5.1] )
         + numMen[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table HA.4M: Knowledge of a place for HIV testing (men)"
    "Percentage of men age 15-49 years who know where to get an HIV test, " +
    "know the result of the most recent test, percentage who have been tested in the last 12 months, " + 
    "and percentage who have been tested in the last 12 months and know the result, " + surveyname
  caption =
      "[1] MICS indicator 9.4 - Men who know where to be tested for HIV"
      "[2] MICS indicator 9.5 - Men who have been tested for HIV and know the results"
      "[3] MICS indicator 9.6 - Sexually active young men who have been tested for HIV and know the results"
  .

new file.
