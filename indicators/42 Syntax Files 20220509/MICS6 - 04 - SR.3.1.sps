* Encoding: windows-1252.
* MICS6 SR.3.1.

* v01 - 2017-11-02.
* v03 - 2020-04-09. Table sub-title changed based on the latest tab plan. Labels in French and Spanish have been removed.

** Total weighted and unweighted numbers of households should be equal when normalized sample weights are used.

** Tables SR.3.1 and the four SR.5 tables present main background characteristics of the household, women's, men's, under-5 and 5-17 samples, 
   and should be produced and finalized before the rest of tables are produced, to ensure that the categories adopted for presentation in the tables will include sufficiently sized denominators. 
** The selected characteristics used in these tables are those used as background characteristics in the topical tables in the following sections.

** Ethnicity of household head should be constructed from information collected in the Household Questionnaire, in questions HC1A, HC1B, and HC2. 
** In most surveys, some combination of these three questions will be used as the final variable that best describes the main socio-cultural or ethnic groups in the country.


***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hl.sav".
sort cases by hh1 hh2 hl1.

compute mem017 = 0.
if (HL6 < 18) mem017 = 1.
compute men1549  = 0.
if (HL6 >= 15 and HL6 <= 49 and HL4 = 1) men1549 = 1.
compute mem50 = 0.
if (HL6 < 50) mem50 = 1.
compute adult18 = 0.
if (HL6 >= 18 and HL6 <= 99) adult18 = 1.

aggregate 
 /outfile = "aggr.sav"
 /break hh1 hh2
 /hhage = first (HL6)
 /mem017 = sum (mem017)
 /men1549 = sum (men1549)
 /mem50 = sum (mem50)
 /adult18 = sum (adult18).


* Open household members data file.
get file = 'hh.sav'.

sort cases by hh1 hh2.

* add household listing data.
match files
  /file = *
  /table = 'aggr.sav'
  /by HH1 HH2.

* Select completed households.
select if (HH46  = 1).

* Weight the data by the household weight.
weight by hhweight.

* Recode total number of household members.
recode HH48 (lo thru 6 = copy) (7 thru hi = 7) into hhmember.
variable labels hhmember "Number of household members".
value labels hhmember 7 "7+".
formats hhmember (f1.0).

* Age of household head.
recode hhage (0 thru 17 = 1) (18 thru 34 = 2) (35 thru 64 = 3) (65 thru 84 = 4) (85 thru 97 = 5) (else = 9) into hhage1.
variable labels hhage1 "Age of household head".
value labels hhage1
1 "<18"
2 "18-34"
3 "35-64"
4 "65-84"
5 "85+"
9 "DK/Missing".

recode HH51 (0 = sysmis) (else = 1) into c05.
recode mem017 (0 = sysmis) (else = 1) into c17.
recode HH52 (0 = sysmis) (else = 1) into c517.
recode HH49 (0 = sysmis) (else = 1) into w1549.
recode men1549 (0 = sysmis) (else = 1) into m1549.
recode mem50 (0 = 1) (else = sysmis) into m50.
recode adult18 (0 = 1) (else = sysmis) into a18.

variable labels c05 "At least one child under age 5 years".
variable labels c517 "At least one child age 5-17 years".
variable labels c17 "At least one child age <18 years".
variable labels w1549 "At least one woman age 15-49 years".
variable labels m1549 "At least one man age 15-49 years".
variable labels m50 "No member age <50".
variable labels a18 "No adult (18+) member".

mrsets 
  /mdgroup name=$hhC label='Households with [A]:' variables=c05 c517 c17 w1549 m1549 m50 a18 value = 1.

variable labels HH48 "Mean household size".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute wp = 0.
variable labels wp " ".
compute nhh = 0.
variable labels nhh "Number of households".
value labels nhh 0 "Number of households".

* Ctables command in English.
ctables
  /vlabels variables = wp 
           display = none
  /table   total[c]
         + hhsex [c]
         + hhage1 [c]
         + hh6 [c]
         + hh7 [c]
         + helevel [c]
         + hhmember [c]
         + ethnicity [c]
         + $hhC [c]
   by
           wp [s] [colpct.count,'Weighted percent' f5.1]
         + nhh [s] [count, 'Weighted', f5.0, ucount, 'Unweighted', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /titles title=
     "Table SR.3.1: Household composition"
     "Percent and frequency distribution of households, " + surveyname
   caption=
     "[A] Each proportion is a separate characteristic based on the total number of households."
  .

ctables
  /vlabels variables = nhh display = none
  /table  HH48 [s] [mean,'Weighted percent',f5.1,
                    validn,'Weighted',f5.0,
                    uvalidn,'Unweighted',f5.0]
   by
          nhh [c]
  /categories variables=all empty=exclude missing=exclude
  /titles title=
     "Table SR.3.1: Household composition"
     "Percent and frequency distribution of households, " + surveyname
   caption=
     "[A] Each proportion is a separate characteristic based on the total number of households.".

new file.

erase file = "aggr.sav".

