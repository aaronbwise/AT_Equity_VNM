* MICS5 MT-02M.

* v01 - 2014-03-13.

* Columns include all men age 15-24 irrespective of whether a computer or internet has
  ever been used.

* Ever use of computers and the internet is calculated as MMT6=1 and MMT9=1, respectively.

* Use of a computer during the last 12 months: MMT7=1.

* Use of the internet during the last 12 months: MMT10=1.

* Use of a computer and the internet at least once a week includes
       (MMT8=1 or 2) and (MMT11=1 or 2), respectively.

***.



* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open men dataset.
get file = 'mn.sav'.

* Select completed interviews.
select if (MWM7 = 1).

* Select men aged 15-24.
select if (mwage = 1 or mwage = 2).

* Weight the data by the men weight.
weight by mnweight.

* Generate numMen variable.
compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men age 15-24 years".

* Generate indicators.
recode MMT6 (1 = 100) (else = 0) into compev.
variable labels compev "Ever used a computer".

recode MMT7 (1 = 100) (else = 0) into comp12.
variable labels comp12 "Used a computer during the last 12 months [1]".

recode MMT8 (1, 2 = 100) (else = 0) into comp1w.
variable labels comp1w "Used a computer at least once a week during the last one month".

recode MMT9 (1 = 100) (else = 0) into intev.
variable labels intev "Ever used the internet".

recode MMT10 (1 = 100) (else = 0) into int12.
variable labels int12 "Used the internet during the last 12 months [2]".

recode MMT11 (1, 2 = 100) (else = 0) into int1w.
variable labels int1w "Used the internet at least once a week during the last one month".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of men age 15-24 who have:".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

ctables
  /vlabels variables =  numMen layer0 total
         display = none
  /table   total [c]
         + mwage [c]
         + hh7 [c]
         + hh6 [c]
         + mwelevel [c]
         + windex5 [c]
         + ethnicity [c]
      by
           layer0 [c] > ( compev [s] [mean,'',f5.1]
                        + comp12 [s] [mean,'',f5.1]
                        + comp1w [s] [mean,'',f5.1]
                        + intev [s] [mean,'',f5.1]
                        + int12 [s] [mean,'',f5.1]
                        + int1w [s] [mean,'',f5.1])
         + numMen[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
     "Table MT.2M: Use of computers and internet (men)"
     "Percentage of young men age 15-24 years who have ever used a computer and the internet, " +
     "percentage who have used during the last 12 months, and percentage who have used at least " +
     "once weekly during the last one month, " + surveyname
   caption =
     "[1] MICS indicator 10.2 - Use of computers [M]"
     "[2] MICS indicator 10.3 - Use of internet [M]".

new file.
