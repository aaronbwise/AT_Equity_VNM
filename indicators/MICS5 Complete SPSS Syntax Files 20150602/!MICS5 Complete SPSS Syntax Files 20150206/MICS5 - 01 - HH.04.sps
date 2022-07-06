* MICS5 HH-04.

* v01 - 2014-02-14.

* Total weighted and unweighted numbers of households should be equal when normalized sample
   weights are used.

* Tables HH.3, HH.4, HH.4M and HH.5 present main background characteristics of the household,
  women's, men's and under-5 samples, and should be produced and finalized before the rest of
  tables are produced, to ensure that the categories adopted for presentation in the tables will
  include sufficiently sized denominators.
* The selected characteristics used in these tables are those used as background characteristics
  in the tipical tables in the following sections.

* Religion/Language/Ethnicity of household head should be constructed from information collected
  in the Household Questionnaire, in questions HC1A, HC1B, and HC1C.
* In most surveys, some combination of these three questions will be used as the final variable
  that best describes the main socio-cultural or ethnic groups in the country."

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open women data file.
get file = 'wm.sav'.

* Select only interviewed women.
select if (WM7 = 1).

* Weight the data by the women weight.
weight by wmweight.

* Create marital status with separate groups for formerly married.
do if (MA1 = 1 or MA1 = 2).
+ compute mstatus1 = 1.
else if (MA5 = 1 or MA5 = 2).
+ compute mstatus1 = MA6+1.
+ if (MA6 = 9) mstatus1 = 9.
else if (MA5 = 3).
+ compute mstatus1 = 5.
else.
+ compute mstatus1 = 9.
end if.
variable labels mstatus1 "Marital/Union status".
value labels mstatus1
    1 "Currently married/in union"
    2 "Widowed"
    3 "Divorced"
    4 "Separated"
    5 "Never married/in union"
    9 "Missing".

* Rename question cm1 and rename value labels.
recode CM1 (1 = 2) (9 = 29) (else = 1) .

* Recode births in last 2 years.
if (cm13 = 'Y' or cm13 = 'O' or cm13 = "S") bl2y = 21.
if (cm13 = 'N' and CM1 = 2) bl2y = 22.

value labels CM1
   1 "Never gave birth"
   2 "Ever gave birth"
  21 "   Gave birth in last two years"
  22 "   No birth in last two years"
  29 "   Missing".

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $mrb
           label = 'Motherhood and recent births'
           variables = CM1 bl2y.

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute wp = 0.
variable labels wp " ".
compute nwm = 0.
variable labels nwm "Number of women".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable = wp display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + wage [c]
         + mstatus1 [c]
         + $mrb [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           wp [s] [colpct.count,'Weighted percent',f5.1]
         + nwm [s] [count,'Weighted', f5.0, 
                    ucount, 'Unweighted', f5.0]
  /categories var=all empty=exclude missing=exclude
  /title title=
    "Table HH.4: Women's background characteristics"
    "Percent and frequency distribution of women age 15-49 years by selected background characteristics, " + surveyname
  .

new file.
