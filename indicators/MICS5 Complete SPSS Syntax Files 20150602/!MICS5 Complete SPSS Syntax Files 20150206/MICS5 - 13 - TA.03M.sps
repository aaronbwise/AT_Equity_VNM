* MICS5 TA-03M.

* v01 - 2013-06-22.
* v02 - 2014-04-22.
* The indicator notes have been swapped, so that note 1 now identifies indicator 12.4 and note 2 indicator 12.3.

* REMARK: Changed <98 to <97 in TA16<98

* Men who have never had an alcoholic drink: 
      MTA14=2 or (MTA14=1 and MTA15=00).

* Men who had at least one alcoholic drink before age 15: 
      MTA15>00 and MTA15<15.

* Men who have had at least one alcoholic drink at any time during the last one month: 
      MTA16>00 and MTA16<97.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open men dataset.
get file = 'mn.sav'.

* Select completed interviews.
select if (MWM7 = 1).

* Weight the data by the men weight.
weight by mnweight.

* Generate numMen variable.
compute numMen = 1.
variable labels numMen "Number of men age 15-49 years".

* Generate indicators.

* Men who have never had an alcoholic drink: MTA14=2 or (MTA14=1 and MTA15=00).
compute noalcohol = 0.
if (MTA14 = 2 or (MTA14=1 and MTA15=0)) noalcohol = 100.
variable labels noalcohol "Never had an alcoholic drink".

* Had at least one drink of alcohol before age 15.
* MTA15>00 and MTA15<15.
compute alcohol15 = 0.
if (MTA15 > 0 and MTA15 < 15) alcohol15 = 100.
variable labels alcohol15 "Had at least one alcoholic drink before age 15 [1]".

* Had at least one drink of alcohol on one or more days during the last one month.
* MTA16>00 and MTA16<98.
compute atLeastOne = 0.
if (MTA16 > 0 and MTA16 < 97) atLeastOne = 100.
variable labels atLeastOne "Had at least one alcoholic drink at any time during the last one month [2]".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of men who:".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

ctables
  /vlabels variables =  layer0 total
         display = none
  /table   total [c]
         + mwage [c] 
         + hh7 [c] 
         + hh6 [c] 
         + mwelevel [c] 
         + windex5 [c] 
         + ethnicity [c] 
   by
           layer0 [c] > ( 
             noalcohol [s] [mean,'',f5.1] 
           + alcohol15 [s] [mean,'',f5.1] 
           + atLeastOne [s] [mean,'',f5.1]) 
         + numMen [s][sum,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
     "Table TA.3M: Use of alcohol (men)"                        
     "Percentage of men age 15-49 years who have never had an alcoholic drink, " +
     "percentage who first had an alcoholic drink before age 15, and percentage of " +
     "men who have had at least one alcoholic drink at any time during the last one month, " + surveyname                        
   caption = 
     "[1] MICS indicator 12.4 - Use of alcohol  before age 15 [M]"
     "[2] MICS indicator 12.3 - Use of alcohol [M]"
  .                
                                                        
new file.
