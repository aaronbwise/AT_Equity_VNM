* Encoding: windows-1252.
* MICS5 TA-03.

* v01 - 2013-06-22.
* v02 - 2014-04-22.
* v03 - 2019-03-14.
*The indicator notes have been swapped, so that note 1 now identifies indicator 12.4 and note 2 indicator 12.3.
* v03 - 2020-04-09. Labels in French and Spanish have been removed.

* REMARK: Changed <98 to <97 in TA16<98

* Women who have never had an alcoholic drink: 
      TA14=2 or (TA14=1 and TA15=00).

* Women who had at least one alcoholic drink before age 15: 
      TA15>00 and TA15<15.

* Women who have had at least one alcoholic drink at any time during the last one month: 
      TA16>00 and TA16<97.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open women dataset.
get file = 'wm.sav'.
sort cases by hh1 hh2 ln.

include "CommonVarsWM.sps".

* Select completed interviews.
select if (WM17 = 1).

* Weight the data by the women weight.
weight by wmweight.

* Generate numWomen variable.
compute numWomen = 1.
variable labels numWomen "Number of women".

* Generate indicators.

* Women who have never had an alcoholic drink: TA14=2 or (TA14=1 and TA15=00).
compute noalcohol = 0.
if (TA14 = 2 or (TA14=1 and TA15=0)) noalcohol = 100.
variable labels noalcohol "Never had an alcoholic drink".

* Had at least one drink of alcohol before age 15.
* TA15>00 and TA15<15.
compute alcohol15 = 0.
if (TA15 > 0 and TA15 < 15) alcohol15 = 100.
variable labels alcohol15 "Had at least one alcoholic drink before age 15 [1]".

* Had at least one drink of alcohol on one or more days during the last one month.
* TA16>00 and TA16<98.
compute atLeastOne = 0.
if (TA16 > 0 and TA16 < 97) atLeastOne = 100.
variable labels atLeastOne "Had at least one alcoholic drink at any time during the last one month [2]".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of women who:".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables =  layer0 total
         display = none
  /table   total [c]
        + hh6 [c]
        + hh7 [c]
        + $wage [c]
        + welevel [c]
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
   by
           layer0 [c] > ( 
             noalcohol [s] [mean '' f5.1] 
           + alcohol15 [s] [mean '' f5.1] 
           + atLeastOne [s] [mean '' f5.1]) 
         + numWomen [s] [sum '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table SR.10.3W: Use of alcohol (women)	"                        
     "Percentage of women age 15-49 years who have never had an alcoholic drink, " +
     "percentage who first had an alcoholic drink before age 15, and percentage of " +
     "women who have had at least one alcoholic drink at any time during the last one month, " + surveyname                        
   caption = 
     "[1] MICS indicator SR.17 - Use of alcohol  before age 15"
     "[2] MICS indicator SR.16 - Use of alcohol"
  .                

new file.
