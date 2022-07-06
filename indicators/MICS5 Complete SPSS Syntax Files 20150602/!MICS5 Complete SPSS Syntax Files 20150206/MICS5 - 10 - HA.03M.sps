* MICS5 HA-03M.

* v02 - 2014-04-02.
* v03 - 2014-04-21.
* In title, “HIV/AIDS” has been replaced with “HIV”.
* In sub-title, “HIV/AIDS” has been replaced with “HIV”.
* In column B, the wording “the AIDS virus” has been replaced with “AIDS”.
* In column C, the wording “who has the AIDS virus” has been replaced with “who is HIV-positive”.
* In column D, the wording “female teacher with the AIDS virus” has been replaced with “female teacher who is HIV-positive”.
* In column E, the wording “family member got infected with the AIDS virus” has been replaced with “family member is HIV-positive”.


* Those with accepting attitudes are respondents who answered 'yes' to MHA9, MHA10, and MHA12 and 'no' to MHA11 (MHA9=1, MHA10=1, MHA11=2, and MHA12=1).
* The column for those agreeing with at least one accepting attitude includes those in at least one of the first four columns.
* The percentage expressing accepting attitudes on all four indicators are: MHA9=1 and MHA10=1 and MHA11=2 and MHA12=1.

* The denominator includes only men who have heard of AIDS (MHA1=1).


***.


include "surveyname.sps".

get file = 'mn.sav'.

* Completed questionnaires and heard of AIDS.
select if (MWM7 = 1 and MHA1 = 1).

weight by mnweight.


* include HA . 
include 'define\MICS5 - 10 - HA.M.sps' .


compute layer = 0.
variable labels layer "".
value labels layer 0 "Percent of men who:".

recode mmstatus (1,2 = 1) (3 = 2).
variable labels mmstatus "Marital status".
add value labels mmstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode mwage (1 = 2) (2 = 3) into mwageAux .

recode mwage (1, 2 = 1) (3 = 4) (4, 5 = 5) (6, 7 = 6).
variable labels mwage "Age".
value labels mwage
 1 "15-24"
 2 "    15-19"
 3 "    20-24"
 4 "25-29"
 5 "30-39"
 6 "40-49" .

mrsets
  /mcgroup name=$mwage
   label='Age'
   variables=mwage mwageAux .

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men who have heard of AIDS".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  numMen layer total
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + $mwage [c]
         + mmstatus [c]
         + mwelevel [c]
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
         + numMen [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /title title=
    "Table HA.3M: Accepting attitudes toward people living with HIV (men)"
    "Percentage of men age 15-49 years who have heard of AIDS who express an accepting attitude towards people living with HIV, " + surveyname
   caption =
    "[1] MICS indicator 9.3 - Accepting attitudes towards people living with HIV"
  .

new file.
