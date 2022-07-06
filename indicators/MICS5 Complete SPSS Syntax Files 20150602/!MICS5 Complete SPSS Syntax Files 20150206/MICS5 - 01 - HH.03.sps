* MICS5 HH-03.

* v02 - 2014-02-14.
* v03 - 2014-08-18.
* Subtitle updated.

* Total weighted and unweighted numbers of households should be equal when normalized sample
   weights are used.

* Tables HH.3, HH.4, HH.4M and HH.5 present main background characteristics of the household,
  women's, men's and under-5 samples, and should be produced and finalized before the rest of
  tables are produced, to ensure that the categories adopted for presentation in the tables will
  include sufficiently sized denominators.
* The selected characteristics used in these tables are those used as background characteristics
  in the typical tables in the following sections.

* Religion/Language/Ethnicity of household head should be constructed from information collected
  in the Household Questionnaire, in questions HC1A, HC1B, and HC1C.
* In most surveys, some combination of these three questions will be used as the final variable
  that best describes the main socio-cultural or ethnic groups in the country.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get file = 'hh.sav'.

* Select completed households.
select if (HH9  = 1).

* Weight the data by the household weight.
weight by hhweight.

* Recode total number of household members.
recode HH11 (lo thru 9 = copy) (10 thru hi = 10) into hhmember.
variable labels hhmember "Number of household members".
value labels hhmember 10 "10+".
formats hhmember (f2.0).

variable labels HH11 "Mean household size".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute wp = 0.
variable labels wp " ".
compute nhh = 0.
variable labels nhh "Number of households".
value labels nhh 0 "Number of households".


* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable = wp 
           display = none
  /table   total[c]
         + hhsex [c]
         + hh7 [c]
         + hh6 [c]
         + hhmember [c]
         + helevel [c]
         + ethnicity [c]
   by
           wp [s] [colpct.count,'Weighted percent' f5.1]
         + nhh [s] [count, 'Weighted', f5.0, ucount, 'Unweighted', f5.0]
  /categories var=all empty=exclude missing=exclude
  /title title=
     "Table HH.3: Household composition"
     "Percent and frequency distribution of households by selected characteristics, " + surveyname
  .

ctables
  /vlabels variable = nhh display = none
  /table  hh11 [s] [mean,'Weighted percent',f5.1,
                    validn,'Weighted',f5.0,
                    uvalidn,'Unweighted',f5.0]
   by
          nhh [c]
  /categories var=all empty=exclude missing=exclude
  /title title=
     "Table HH.3: Household composition"
     "Percent and frequency distribution of households by selected characteristics, " + surveyname
  .

new file.


