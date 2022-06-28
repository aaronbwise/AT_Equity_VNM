* Encoding: windows-1252.
* Figures in the total row are based on women age 15-49 and 20-49 for live births before age 15 and age 18, respectively.

* For the calaulation of ages of women at the time of first birth, see note below Table TM.2.2W.

* v02 - 2020-04-14. Table sub-title changed based on the latest tab plan. Labels in French and Spanish have been removed.

***.

include "surveyname.sps".

get file = 'wm.sav'.

select if (WM17 = 1).

include "CommonVarsWM.sps".

weight by wmweight.

recode CM11 (sysmis = 0) .

compute birthBefore15 = 0.
if ((wdobfc - wdob)/12 < 15) birthBefore15 = 100.
variable labels birthBefore15 " ".

do if (WB4 >= 20).
+ compute birthBefore18 = 0.
+ if ((wdobfc - wdob)/12 < 18) birthBefore18 = 100.
end if.
variable labels birthBefore18 " ".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

* Ctables command in English.
ctables
  /format missing = "na"
  /vlabels variables = birthBefore15 birthBefore18 hh6
           display = none
  /table   total [c]
         + $wage [c]
   by
           hh6 [c] > (
             birthBefore15 [s] [mean,"Percentage of women with a live birth before age 15",f5.1,
                                validn,"Number of women age 15-49 years",f5.0]
           + birthBefore18 [s] [mean,"Percentage of women with a live birth before age 18",f5.1,
                                validn,"Number of women age 20-49 years",f5.0] )
  /categories variables=hh6 total=yes position=after label='All'
  /titles title=
     "Table TM.2.3W: Trends in early childbearing (women)"														
     "Percentage of women who have had a live birth, by age 15 and 18, by area of residence, " + surveyname
  caption = "na: not applicable".
  
new file.
