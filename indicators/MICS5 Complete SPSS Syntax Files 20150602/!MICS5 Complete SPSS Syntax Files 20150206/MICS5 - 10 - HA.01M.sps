* MICS5 HA-01M.

* v02 - 2014-04-02.
* v03 - 2014-04-21.
* In title, “HIV/AIDS” has been replaced with “HIV”.
* In sub-title, columns F and J, and in comment, the wording “can have the AIDS virus” has been replaced with “can be HIV-positive”.
* In column I, “AIDS” has been replaced with “HIV”.
* v04 - 2014-08-19.
* Line 88:        +mwage [c] changed to:  + mmstatus [c]



* The denominator of the table includes all men, including those who have not heard of AIDS (MHA1=2).

* All misconceptions about HIV transmission included in the questionnaire should be reported in this table.
* Three misconceptions are included here, as in the standard questionnaires: mosquito bites (MHA5), supernatural means (MHA3), and sharing sharingFood (MHA6).
* Surveys may add or replace questions on misconceptions thought to be common in the country, such as "hugging or shaking hands with someone who is infected"
  or "kissing someone who is infected" and these should also be reported.

* Table MHA_1 must be customised based on the results of a first run of this table, so that the two most prevalent misconceptions are used in
  the calculation of the comprehensive knowledge indicator.
* Above the table, the tabulation syntax prints the two misconceptions used in the calculation.
* This is done for easy reference when reviewing the tabulations.

* Men who have comprehensive knowledge about HIV prevention includes men who know of the two ways of HIV prevention (having only one faithful
  uninfected partner (MHA2=1) and using a condomUse every time (MHA4=1)), who know that a healthy looking person can be HIV-positive (MHA7=1), and
  who reject the two most common misconceptions (two most common of MHA3=2, MHA5=2, MHA6=2, and any other local misconception added to the questionnaire).

***.


include "surveyname.sps".

get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.


* include HA . 
include 'define\MICS5 - 10 - HA.M.sps' .

compute layerCan = 0.
variable labels layerCan "".
value labels layerCan 0 "Percentage who know transmission can be prevented by:".

compute layerCannot = 0.
variable labels layerCannot "".
value labels layerCannot 0 "Percentage who know that HIV cannot be transmitted by:".

recode mmstatus  (1,2 = 1) (3 = 2).
variable labels mmstatus  "Marital status".
add value labels mmstatus 
  1 "Ever married/in union"
  2 "Never married/in union".

recode mwage (1 = 2) (2 = 3) into mwageAux .

recode mwage (1, 2 = 1) (3 = 4) (4, 5 = 5) (6, 7 = 6).
variable labels mwage "Age".
value labels mwage
 1 "15-24 [1]"
 2 "    15-19"
 3 "    20-24"
 4 "25-29"
 5 "30-39"
 6 "40-49" .

mrsets
  /mcgroup name=$mwage
   label='Age'
   variables=mwage mwageAux .

compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men age 15-49".

compute total = 1.
variable labels total "".
value labels total 1 "Total".


* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = numMen layerCan layerCannot total
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
         + numMen[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
    "Table HA.1M: Knowledge about HIV transmission, misconceptions about HIV, and comprehensive knowledge about HIV transmission (men)"
    "Percentage of men age 15-49 years who know the main ways of preventing HIV transmission, percentage who know that a healthy looking person " +
	"can be HIV-positive, percentage who reject common misconceptions, and percentage who have comprehensive knowledge about HIV transmission, " + surveyname
   caption =
      "[1] MICS indicator 9.1; MDG indicator 6.3 - Knowledge about HIV prevention among young men"
  .

new file.
