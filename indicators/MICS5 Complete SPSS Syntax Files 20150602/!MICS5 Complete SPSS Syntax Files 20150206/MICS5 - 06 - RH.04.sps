* MICS5 RH-04.

* v01 - 2013-11-11.

* Figures in the total row are based on women age 15-49 and 20-49 for live births before age 15 and age 18, respectively.

* For the calaulation of ages of women at the time of first birth, see note below Table RH.3 .

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

recode CM10 (sysmis = 0) .

compute birthBefore15 = 0.
if ((wdobfc - wdob)/12 < 15) birthBefore15 = 100.
variable labels birthBefore15 " ".

do if (WB2 >= 20).
+ compute birthBefore18 = 0.
+ if ((wdobfc - wdob)/12 < 18) birthBefore18 = 100.
end if.
variable labels birthBefore18 " ".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /vlabels variables = HH6 birthBefore15 birthBefore18
           display = none
  /table   total [c]
         + wage [c]
   by
           HH6 [c] > (
             birthBefore15 [s] [mean,"Percentage of women with a live birth before age 15",f5.1,
                                validn,"Number of women age 15-49 years",f5.0]
           + birthBefore18 [s] [mean,"Percentage of women with a live birth before age 18",f5.1,
                                validn,"Number of women age 20-49 years",f5.0] )
  /categories var=HH6 total=yes position=after label='All'
  /title title=
     "Table RH.4: Trends in early childbearing"
     "Percentage of women who have had a live birth, by age 15 and 18, by area and age group, " + surveyname.

new file.
