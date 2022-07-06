* MICS5 HA-01.

* v02 - 2014-04-02.
* v03 - 2014-04-21.
* In title, “HIV/AIDS” has been replaced with “HIV”.
* In sub-title, columns F and J, and in comment, the wording “can have the AIDS virus” has been replaced with “can be HIV-positive”.
* In column I, “AIDS” has been replaced with “HIV”.


* The denominator of the table includes all women, including those who have not heard of AIDS (HA1=2).

* All misconceptions about HIV transmission included in the questionnaire should be reported in this table.
* Three misconceptions are included here, as in the standard questionnaires: mosquito bites (HA5), supernatural means (HA3), and sharing sharingFood (HA6).
* Surveys may add or replace questions on misconceptions thought to be common in the country, such as "hugging or shaking hands with someone who is infected"
  or "kissing someone who is infected" and these should also be reported.

* Table HA_1 must be customised based on the results of a first run of this table, so that the two most prevalent misconceptions are used in
  the calculation of the comprehensive knowledge indicator.
* Above the table, the tabulation syntax prints the two misconceptions used in the calculation.
* This is done for easy reference when reviewing the tabulations.

* Women who have comprehensive knowledge about HIV prevention includes women who know of the two ways of HIV prevention (having only one faithful
  uninfected partner (HA2=1) and using a condomUse every time (HA4=1)), who know that a healthy looking person can be HIV-positive (HA7=1), and
  who reject the two most common misconceptions (two most common of HA3=2, HA5=2, HA6=2, and any other local misconception added to the questionnaire).

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

* include HA . 
include 'define\MICS5 - 10 - HA.sps' .

compute layerCan = 0.
variable labels layerCan "".
value labels layerCan 0 "Percentage who know transmission can be prevented by:".

compute layerCannot = 0.
variable labels layerCannot "".
value labels layerCannot 0 "Percentage who know that HIV cannot be transmitted by:".

recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status".
add value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode wage (1 = 2) (2 = 3) into wageAux .

recode wage (1, 2 = 1) (3 = 4) (4, 5 = 5) (6, 7 = 6).
variable labels wage "Age".
value labels wage
 1 "15-24 [1]"
 2 "    15-19"
 3 "    20-24"
 4 "25-29"
 5 "30-39"
 6 "40-49" .

mrsets
  /mcgroup name=$wage
   label='Age'
   variables=wage wageAux .

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women age 15-49".

compute total = 1.
variable label total "".
value label total 1 "Total".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = numWomen layerCan layerCannot total
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
           heardOfAIDS [s] [mean,'',f5.1]
         + layerCan [c] > (
             onePartner [s] [mean,'',f5.1]
           + condomUse [s] [mean,'',f5.1]
           + knowBoth [s] [mean,'',f5.1] )
         + healthy [s] [mean,'',f5.1]
         + layerCannot [c] > (
             mosquito [s] [mean,'',f5.1]
           + supernatural [s] [mean,'',f5.1]
           + sharingFood [s] [mean,'',f5.1] )
         + knowThree[s] [mean,'',f5.1]
         + comprehensiveKnowledge [s] [mean,'',f5.1]
         + numWomen[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
    "Table HA.1: Knowledge about HIV transmission, misconceptions about HIV, and comprehensive knowledge about HIV transmission (women)"
    "Percentage of women age 15-49 years who know the main ways of preventing HIV transmission, percentage who know that a healthy looking person " +
	"can be HIV-positive, percentage who reject common misconceptions, and percentage who have comprehensive knowledge about HIV transmission, " + surveyname
   caption =
      "[1] MICS indicator 9.1; MDG indicator 6.3 - Knowledge about HIV prevention among young women"
  .

new file.
