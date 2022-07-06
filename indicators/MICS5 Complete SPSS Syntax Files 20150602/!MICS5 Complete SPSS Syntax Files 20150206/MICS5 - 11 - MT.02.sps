* MICS5 MT-02.

* v01 - 2014-03-13.

* Columns include all women age 15-24 irrespective of whether a computer or internet has
  ever been used.

* Ever use of computers and the internet is calculated as MT6=1 and MT9=1, respectively.

* Use of a computer during the last 12 months: MT7=1.

* Use of the internet during the last 12 months: MT10=1.

* Use of a computer and the internet at least once a week includes
       (MT8=1 or 2) and (MT11=1 or 2), respectively.

***.



* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open women dataset.
get file = 'wm.sav'.

* Select completed interviews.
select if (WM7 = 1).

* Select women aged 15-24.
select if (wage = 1 or wage = 2).

* Weight the data by the women weight.
weight by wmweight.

* Generate numWomen variable.
compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women age 15-24 years".

* Generate indicators.
recode MT6 (1 = 100) (else = 0) into compev.
variable labels compev "Ever used a computer".

recode MT7 (1 = 100) (else = 0) into comp12.
variable labels comp12 "Used a computer during the last 12 months [1]".

recode MT8 (1, 2 = 100) (else = 0) into comp1w.
variable labels comp1w "Used a computer at least once a week during the last one month".

recode MT9 (1 = 100) (else = 0) into intev.
variable labels intev "Ever used the internet".

recode MT10 (1 = 100) (else = 0) into int12.
variable labels int12 "Used the internet during the last 12 months [2]".

recode MT11 (1, 2 = 100) (else = 0) into int1w.
variable labels int1w "Used the internet at least once a week during the last one month".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of women age 15-24 who have:".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

ctables
  /vlabels variables =  numWomen layer0 total
         display = none
  /table   total [c]
         + wage [c]
         + hh7 [c]
         + hh6 [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]
      by
           layer0 [c] > ( compev [s] [mean,'',f5.1]
                        + comp12 [s] [mean,'',f5.1]
                        + comp1w [s] [mean,'',f5.1]
                        + intev [s] [mean,'',f5.1]
                        + int12 [s] [mean,'',f5.1]
                        + int1w [s] [mean,'',f5.1] )
         + numWomen[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
     "Table MT.2: Use of computers and internet (women)"
     "Percentage of young women age 15-24 years who have ever used a computer and the internet, " +
     "percentage who have used during the last 12 months, and percentage who have used at least " +
     "once weekly during the last one month, " + surveyname
   caption =
     "[1] MICS indicator 10.2 - Use of computers"
     "[2] MICS indicator 10.3 - Use of internet".

new file.
