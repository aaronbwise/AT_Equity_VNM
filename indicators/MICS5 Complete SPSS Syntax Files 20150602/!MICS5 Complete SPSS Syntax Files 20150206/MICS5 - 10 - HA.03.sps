* MICS5 HA-03.

* v02 - 2014-04-02.
* v03 - 2014-04-21.
* In title, “HIV/AIDS” has been replaced with “HIV”.
* In sub-title, “HIV/AIDS” has been replaced with “HIV”.
* In column B, the wording “the AIDS virus” has been replaced with “AIDS”.
* In column C, the wording “who has the AIDS virus” has been replaced with “who is HIV-positive”.
* In column D, the wording “female teacher with the AIDS virus” has been replaced with “female teacher who is HIV-positive”.
* In column E, the wording “family member got infected with the AIDS virus” has been replaced with “family member is HIV-positive”.


* Those with accepting attitudes are respondents who answered 'yes' to HA9, HA10, and HA12 and 'no' to HA11 (HA9=1, HA10=1, HA11=2, and HA12=1).
* The column for those agreeing with at least one accepting attitude includes those in at least one of the first four columns.
* The percentage expressing accepting attitudes on all four indicators are: HA9=1 and HA10=1 and HA11=2 and HA12=1.

* The denominator includes only women who have heard of AIDS (HA1=1).


***.


include "surveyname.sps".

get file = 'wm.sav'.

* completed questionnaires and heard of AIDS.
select if (WM7 = 1 and HA1 = 1).

weight by wmweight.


* include HA . 
include 'define\MICS5 - 10 - HA.sps' .

recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status".
add value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode wage (1 = 2) (2 = 3) into wageAux .

recode wage (1, 2 = 1) (3 = 4) (4, 5 = 5) (6, 7 = 6).
variable labels wage "Age".
value labels wage
 1 "15-24"
 2 "    15-19"
 3 "    20-24"
 4 "25-29"
 5 "30-39"
 6 "40-49" .

mrsets
  /mcgroup name=$wage
   label='Age'
   variables=wage wageAux .

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percent of women who:".

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women who have heard of AIDS".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  numWomen layer total
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
           layer [c] > (
             care [s] [mean,'',f5.1]
           + food [s] [mean,'',f5.1]
           + teacher [s] [mean,'',f5.1]
           + secret [s] [mean,'',f5.1]
           + onePlus [s] [mean,'',f5.1]
           + all4Attitudes [s] [mean,'',f5.1] )
         + numWomen [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /title title=
    "Table HA.3: Accepting attitudes toward people living with HIV (women)"
    "Percentage of women age 15-49 years who have heard of AIDS who express an accepting attitude towards people living with HIV, " + surveyname
   caption =
    "[1] MICS indicator 9.3 - Accepting attitudes towards people living with HIV"
  .

new file.
