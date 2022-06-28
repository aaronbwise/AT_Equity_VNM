* Encoding: windows-1252.
* MICS6 SR.5.1M.

* v01 - 2017-09-21.
* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-09. Table sub-title changed based on the latest tab plan. Labels in French and Spanish have been removed.

** Total weighted and unweighted numbers of men should be equal when normalized sample weights are used.


***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open men data file.
get file = 'mn.sav'.

include "CommonVarsMN.sps".

* Select only interviewed men.
select if (MWM17 = 1).

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
 9 "DK/Missing".

*Change the labels on the disaggregate of “Health insurance” have been changed to “Has coverage” and “Has no coverage”.
add value labels minsurance 
 1 "Has coverage"
 2 "Has no coverage" 
 9 "DK/Missing".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute wp = 0.
variable labels wp " ".
compute nmm = 0.
variable labels nmm "Number of men".
 
* Ctables command in English.
ctables
  /vlabels variables = wp display = none
  /table  total [c]
         + hh6 [c]
         + hh7 [c]
         + $mwage [c]
         + mwelevel [c]
         + mstatus1 [c]
         + fstatus [c]
         + minsurance [c]
         + mdisability [c]
         + ethnicity[c]
         + windex5 [c]
   by
          wp [s] [colpct.count,'Weighted percent' f5.1]
        + nmm [s] [count, 'Weighted', f5.0, ucount, 'Unweighted', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /titles title =
     "Table SR.5.1M: Men's background characteristics"
     "Percent and frequency distribution of men age 15-49 years, " + surveyname
  .

new file.
