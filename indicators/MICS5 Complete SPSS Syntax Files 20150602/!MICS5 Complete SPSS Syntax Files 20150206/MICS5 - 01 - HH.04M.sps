* MICS5 HH-04M.

* v02 - 2014-03-18. 
* Background variable fatherhood status added.

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

* Open men data file.
get file = 'mn.sav'.

* Select only interviewed men.
select if (MWM7 = 1).

* Weight the data by the men weight.
weight by mnweight.

* Create marital status with separate groups for formerly married.
do if (MMA1 = 1 or MMA1 = 2).
+ compute mstatus1 = 1.
else if (MMA5 = 1 or MMA5 = 2).
+ compute mstatus1 = MMA6+1.
+ if (MMA6 = 9) mstatus1 = 9.
else if (MMA5 = 3).
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

* Fatherhood status: Has at least one living child/Has no living children.
recode MCM1 (1 = 1) (8, 9 = 9) (else = 2) into fstatus.
variable labels fstatus "Fatherhood status".
value labels fstatus 
 1 "Has at least one living child"
 2 "Has no living children"
 9 "Missing/DK".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute wp = 0.
variable labels wp " ".
compute nmm = 0.
variable labels nmm "Number of men".


* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable = wp display = none
  /table  total [c]
        + hh7 [c]
        + hh6 [c]
        + mwage [c]
        + mstatus1 [c]
        + fstatus [c]
        + mwelevel [c]
        + windex5 [c]
        + ethnicity [c]
   by
          wp [s] [colpct.count,'Weighted percent' f5.1]
        + nmm [s] [count, 'Weighted', f5.0, ucount, 'Unweighted', f5.0]
  /categories var=all empty=exclude missing=exclude
  /title title =
     "Table HH.4M: Men's background characteristics"
     "Percent and frequency distribution of men age 15-49 years by selected background characteristics, " + surveyname
  .

new file.
