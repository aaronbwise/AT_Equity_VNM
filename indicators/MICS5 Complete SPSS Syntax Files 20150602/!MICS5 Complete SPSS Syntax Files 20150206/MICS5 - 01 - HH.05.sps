* MICS5 HH-05.

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

get file = 'hl.sav'.

sort cases hh1 hh2 hl1.

save outfile='tmp.sav'
  /keep = hh1 hh2 hl1 hl12
  /rename = (hl1=ln).

* Open children data file.
get file = 'ch.sav'.

* sort cases in order to perform mergeing.
sort cases hh1 hh2 ln.

* merging with tmp file with mother's line number.
match files
 /file=*
 /table='tmp.sav'
 /by hh1 hh2 ln.

recode HL12 (sysmis = 0) (else = copy).
if (HL12 = UF6)  respondentToQ = 1.
if (HL12 ~= UF6) respondentToQ = 2.

variable labels respondentToQ 'Respondent to the under-5 questionnaire'.
value labels respondentToQ
  1 'Mother'
  2 'Other primary caretaker'.

* Select interviewed children.
select if (UF9 = 1).

* Weight the data by the under-5 weight.
weight by chweight.

* in order to add 'months' at the end of lablel.
value labels cage_6
  1 "0-5 months"
  2 "6-11 months"
  3 "12-23 months"
  4 "24-35 months"
  5 "36-47 months"
  6 "48-59 months" .

* In order to add * in melevel label.
variable labels melevel "Mother’s education*".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute wp = 0.
variable labels wp " ".
compute numChildren = 0.
variable labels numChildren "Number of children".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable = wp display = none
  /table  total [c]
        + hl4 [c]
        + hh7 [c]
        + hh6 [c]
        + cage_6 [c]
        + respondentToQ [c]
        + melevel [c]
        + windex5[c]
        + ethnicity[c]
   by
          wp [s] [colpct.count,'Weighted percent' f5.1]
        + numChildren [s] [count, 'Weighted', f5.0, 
                           ucount, 'Unweighted', f5.0]
  /categories var=all empty=exclude missing = exclude
  /title title =
     "Table HH.5: Under-5's background characteristics"
     "Percent and frequency distribution of children under five years of age by selected characteristics, " + surveyname
   caption =
     "* In this table and throughout the report, mother's education refers to educational attainment of mothers as well as caretakers of children under 5," +
     " who are the respondents to the under-5 questionnaire if the mother is deceased or is living elsewhere.".

new file.

erase file = 'tmp.sav'.
