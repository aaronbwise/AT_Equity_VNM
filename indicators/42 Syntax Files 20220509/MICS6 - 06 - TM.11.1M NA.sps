* Encoding: windows-1252.
 * The denominator of the table includes all men, including those who have not heard of AIDS (MHA1=2). 

 * All misconceptions about HIV transmission included in the questionnaire should be reported in this table. Three misconceptions are included here, as in the standard questionnaires: mosquito 
bites (MHA3), supernatural means (MHA6), and sharing food (MHA5). Surveys may add or replace questions on misconceptions thought to be common in the country, such as "hugging or shaking 
hands with someone who is infected" or "kissing someone who is infected" and these should also be reported.

 * The two most common misconceptions are automatically identified and included in the appropriate columns. This is done through the "define" syntax that must be customised if any additional 
misconception are added to the questionnaire. Note that the most common misconceptions are calculated based on the full sample of men. This should not be changed for the indicators relating 
to a different age group, such as age 15-24 years.

 * Men who have comprehensive knowledge about HIV prevention includes men who know of the two ways of HIV prevention (having only one faithful uninfected partner (MHA2=1) and using a condom 
every time (MHA4=1)), who know that a healthy looking person can be HIV-positive (MHA7=1), and who reject the two most common misconceptions (two most common of MHA3=2, MHA6=2, MHA5=2, 
and any other local misconception added to the questionnaire).

***.

* v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'mn.sav'.

include "CommonVarsMN.sps".

select if (MWM17 = 1).

weight by mnweight.

* include TM.M . 
include 'define\MICS6 - 06 - TM.M.sps' .

compute layerCan = 0.
variable labels layerCan "".
value labels layerCan 0 "Percentage who know transmission can be prevented by:".

compute layerCannot = 0.
variable labels layerCannot "".
value labels layerCannot 0 "Percentage who know that HIV cannot be transmitted by:".

compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

variable labels comprehensiveKnowledge "Percentage with comprehensive knowledge [1] [A]".

* ctables command in English.
ctables
  /vlabels variables = numMen layerCan layerCannot total
           display = none
  /table   total [c]
          + HH6 [c]
         + HH7 [c]
         + $mwagey [c]
         + mwelevel [c]
         + mmstatus2 [c]
         + mdisability [c]
         + ethnicity [c]
         + windex5 [c]
   by
           heardOfAIDS [s] [mean '' f5.1]
         + layerCan [c] > (
             onePartner [s] [mean '' f5.1]
           + condomUse [s] [mean '' f5.1]
           + knowBoth [s] [mean '' f5.1] )
         + healthy [s] [mean '' f5.1]
         + layerCannot [c] > (
             mosquito [s] [mean '' f5.1]
           + supernatural [s] [mean '' f5.1]
           + sharingFood [s] [mean '' f5.1] )
         + knowThree[s] [mean '' f5.1]
         + comprehensiveKnowledge [s] [mean '' f5.1]
         + numMen[c][count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /titles title=
    "Table TM.11.1M: Knowledge about HIV transmission, misconceptions about HIV, and comprehensive knowledge about HIV transmission (men)"
    "Percentage of men age 15-49 years who know the main ways of preventing HIV transmission, percentage who know that a healthy looking person can be HIV-positive, percentage who reject common misconceptions, " + 
    "and percentage who have comprehensive knowledge about HIV transmission, " + surveyname
   caption =
      "[1] MICS indicator TM.29 - Knowledge about HIV prevention among young people"
      "[A] Comprehensive knowledge about HIV prevention includes those who know of the two ways of HIV prevention (having only one faithful uninfected partner and using a condom every time), "
      "who know that a healthy-looking person can be HIV-positive and who reject the two most common misconceptions about HIV transmission"      
  .

new file.
