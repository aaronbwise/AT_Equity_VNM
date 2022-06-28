* Encoding: windows-1252.
* Figures in the total row are based on women age 15-49 and 20-49 for live births before age 15 and age 18, respectively.

* For the calaulation of ages of women at the time of first birth, see note below Table TM.2.2W.

* v03 - 2020-04-14. Table sub-title changed based on the latest tab plan. Labels in French and Spanish have been removed.

***.

include "surveyname.sps".

get file = 'mn.sav'.

do if (MCM17<98).
+ compute mdobfc = MCM17*12+mwdob.
end if.

do if (sysmis(MCM17) and MCM18M<99 and MCM18Y<9999).
+ compute mdobfc = (MCM18Y-1900)*12+MCM18M.
end if.

select if (MWM17 = 1).

include "CommonVarsMN.sps".

weight by mnweight.

recode MCM11 (sysmis = 0) .

compute birthBefore15 = 0.
if ((mdobfc - mwdob)/12 < 15) birthBefore15 = 100.
variable labels birthBefore15 " ".

do if (MWB4 >= 20).
+ compute birthBefore18 = 0.
+ if ((mdobfc - mwdob)/12 < 18) birthBefore18 = 100.
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
         + $mwage [c]
   by
           hh6 [c] > (
             birthBefore15 [s] [mean,"Percentage of men fathering a live birth before age 15",f5.1,
                                validn,"Number of men age 15-49 years",f5.0]
           + birthBefore18 [s] [mean,"Percentage of men fathering a live birth before age 18",f5.1,
                                validn,"Number of men age 20-49 years",f5.0] )
  /categories variables=hh6 total=yes position=after label='All'
  /titles title=
     "Table TM.2.3M: Trends in early fatherhood (men)"														
     "Percentage of men who have fathered a live birth, by age 15 and 18, by area of residence, " + surveyname
  caption = "na: not applicable".

new file.
