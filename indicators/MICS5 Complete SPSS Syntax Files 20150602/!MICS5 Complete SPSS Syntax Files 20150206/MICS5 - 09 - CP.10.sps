* MICS5 CP-10 .

* v01 - 2014-03-18.

* Women age 15-49 reporting they had any type of female genital mutilation/cutting 
    (FG3=1) .
    
* Individual forms of FGM/C include the removal of flesh from the genital area 
    (FG4=1), 
  the nicking of the flesh of the genital area 
    (FG5=1) 
  and sewing closed the genital area 
    (FG6=1) .

***.


get file = "wm.sav".

select if (WM7 = 1).

weight by wmweight.

compute anyFgm = 0 .
if (FG3 = 1) anyFgm = 100 .
variable labels anyFgm "Percentage who had any form of FGM/C [1]".

do if (FG3 = 1) .
+ compute fgmType = 4 .
+ if (FG4 = 1) fgmType = 1 .
+ if (FG5 = 1) fgmType = 2 .
+ if (FG6 = 1) fgmType = 3 .
end if .
variable labels fgmType "Percent distribution of women age 15-49 years who had FGM/C:".
value labels  fgmType 
  1 "Had flesh removed" 
  2 "Were nicked" 
  3 "Were sewn closed" 
  4 "Form of FGM/C not determined" .

if (FG3 = 1) numFgm = 1 .
value labels numFgm 1 "Number of women age 15-49 years who had FGM/C" .

compute numWomen = 1 .
value labels numWomen 1 "Number of women age 15-49 years" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /vlabels variables = numWomen numFgm
           display = none
  /table  total [c]
        + hh7 [c] 
        + hh6 [c] 
        + wage [c]
        + welevel [c]
        + windex5 [c]
        + ethnicity [c]
   by 
 	       anyFgm [s] [mean,'',f5.1]
         + numWomen [c] [count,'',f5.0]
         + fgmType [c] [rowpct.validn,'',f5.1]
         + numFgm [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=fgmType total=yes
  /slabels position=column visible = no
  /title title=
     "Table CP.10: Female genital mutilation/cutting (FGM/C) among women"
	 "Percentage of women age 15-49 years by FGM/C status and percent distribution of women who had FGM/C by type of FGM/C, " + surveyname
   caption =
     "[1] MICS indicator 8.10 - Prevalence of FGM/C among women"
  .

new file.
