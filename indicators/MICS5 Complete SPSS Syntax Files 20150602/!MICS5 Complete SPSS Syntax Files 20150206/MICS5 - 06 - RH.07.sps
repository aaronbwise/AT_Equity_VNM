* MICS5 RH-07.

* v01 - 2013-11-11.
* v03 - 2014-02-22.
* v04 - 2015-04-21.
* A note b has been added on column “Any skilled provider”.


* Only the most qualified provider is considered for the construction of the table, for cases where more than one provider has been mentioned
  in MN2.

* The response codes to MN2 need to be customized at the country level.
* Specifically, the "auxiliary midwife" will have been customised and replaced by the local term used in the country.
* Normally, skilled providers will include doctors, midwives and nurses (MN2=A, B).
* The locally adapted category equivalent to auxiliary midwife may or may not be considered skilled personnel .

***.


get file = 'wm.sav'.

select if (WM7 = 1).

include "surveyname.sps".

weight by wmweight.

* select women that gave birth in two years preceeding the survey.
select if (CM13 = "Y" or CM13 = "O" or CM13 = "S").

* definitions of anc, ageAtBirth .
include 'define\MICS5 - 06 - RH.sps' .

compute skilledPersonnel = 0.
if (any(anc, 11, 12)) skilledPersonnel = 100.
variable labels skilledPersonnel "Any skilled provider [1][b]".

compute numWomen = 1.
value labels numWomen 1 "".
variable labels numWomen "Number of women with a live birth in the last two years".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute total100 = 100.
variable labels total100 "Total".
value labels total100 100" ".

variable labels anc "Provider of antenatal care [a]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + ageAtBirth [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]        
   by
             anc [c] [rowpct.validn,'',f5.1]
         + total100 [s] [mean,'',f5.1]
         + skilledPersonnel [s] [mean,'',f5.1]
         + numWomen [s] [count,'',f5.0]
  /categories var=all empty=exclude
  /slabels position=column visible=no
  /titles title=
     "Table RH.7: Antenatal care coverage"
     "Percent distribution of women age 15-49 years with a live birth in the last two years by antenatal care provider during the pregnancy for the last birth, " + surveyname
   caption=
     "[1] MICS indicator 5.5a; MDG indicator 5.5 - Antenatal care coverage"
     "[a] Only the most qualified provider is considered in cases where more than one provider was reported."
     "[b] Skilled providers include Medical doctor and Nurse/Midwife."
  .

new file.

