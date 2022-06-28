* Encoding: windows-1252.
* MICS6 SR.5.1W.

* v01 - 2017-09-21.
* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-09. Table sub-title changed based on the latest tab plan. Labels in French and Spanish have been removed.

** Total weighted and unweighted numbers of women should be equal when normalized sample weights are used.


***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open women data file.
get file = 'wm.sav'.

include "CommonVarsWM.sps".

* Select only interviewed women.
select if (WM17 = 1).

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
recode CM1 (1 = 2) (9 = 29) (else = 1) into everbirth.
if (CM1 = 2 and CM8 = 1) everbirth = 2.

* Recode births in last 2 years.
if (cm17 = 1) bl2y = 21.
if (cm17 = 0 and everbirth = 2) bl2y = 22.

value labels everbirth
   1 "Never gave birth"
   2 "Ever gave birth"
  21 "   Gave birth in last two years"
  22 "   No birth in last two years"
  29 "   Missing".

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $mrb
           label = 'Motherhood and recent births'
           variables = everbirth bl2y.

*Change the labels on the disaggregate of “Health insurance” have been changed to “Has coverage” and “Has no coverage”.
add value labels insurance 
 1 "Has coverage"
 2 "Has no coverage" 
 9 "DK/Missing".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute wp = 0.
variable labels wp " ".
compute nwm = 0.
variable labels nwm "Number of women".


* Ctables command in English.
ctables
  /vlabels variables = wp display = none
  /table   total [c]
         + hh6 [c]
         + hh7 [c]
         + $wage [c]
         + welevel [c]
         + mstatus1 [c]
         + $mrb [c]
         + insurance [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]
   by
           wp [s] [colpct.count,'Weighted percent',f5.1]
         + nwm [s] [count,'Weighted', f5.0, 
                    ucount, 'Unweighted', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /titles title=
    "Table SR.5.1W: Women's background characteristics"
    "Percent and frequency distribution of women age 15-49 years, " + surveyname
  .

new file.
