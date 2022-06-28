* Encoding: windows-1252.
***.

*v01.2019-03-14.
*v02 - 2020-04-14. Labels in French and Spanish have been removed.

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

* select women that gave birth in two years preceeding the survey. 
select if (CM17 = 1).

include "surveyname.sps".

weight by wmweight.

* definitions of anc, ageAtBirth .
include 'define\MICS6 - 06 - TM.sps' .

variable labels skilledPersonnel "Percentage of women who were attended at least once by skilled health personnel [1],[B]".

compute numWomen = 1.
value labels numWomen 1 "".
variable labels numWomen "Number of women with a live birth in the last 2 years".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute total100 = 100.
variable labels total100 "Total".
value labels total100 100" ".

variable labels anc "Provider of antenatal care [A]".

* Ctables command in English.
ctables
  /table total [c]
         + HH6 [c]
         + hh7 [c]
         + welevel [c]
         + ageAtBirth [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]         
   by
             anc [c] [rowpct.validn '' f5.1]
         + total100 [s] [mean '' f5.1]
         + skilledPersonnel [s] [mean '' f5.1]
         + numWomen [s] [count '' f5.0]
  /categories variables=all empty=exclude
  /slabels position=column visible=no
  /titles title=
     "Table TM.4.1: Antenatal care coverage"									
      "Percent distribution of women age 15-49 years with a live birth in the last 2 years by antenatal care provider during the pregnancy of the most recent live birth, "+ surveyname
   caption=
    "[1] MICS indicator TM.5a - Antenatal care coverage (at least once by skilled health personnel)"
    "[A] Only the most qualified provider is considered in cases where more than one provider was reported."									
    "[B] Skilled providers include Medical doctor, Nurse/Midwife and Other qualified.".							

new file.

