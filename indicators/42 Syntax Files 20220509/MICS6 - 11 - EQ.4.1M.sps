* Encoding: windows-1252.
 * The overall life satisfaction score is the average of responses to MLS2. Higher scores indicate higher satisfaction levels.

 * Happiness: Men who are very or somewhat happy (MLS1=1 or 2).

 * The syntax produces a working table that presents the weighted frequencies of single ladder steps. While the standard format of this table 
 has three clusters of ladder steps, i.e.0-3, 4-6 and 7-10, the working table should be investigated, to evaluate if any cluster of steps would be
 valuable to split, e.g. the final table presenting 0-3, 4, 5, 6, 8-10.

***.

* v02 - 2019-08-28. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-21  The first row of the age group disaggregate changed from 15-17 to 15-19. Labels in French and Spanish have been removed.
***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open men dataset.
get file = 'mn.sav'.

include "CommonVarsMN.sps".

select if (MWM17 = 1).

weight by mnweight.

* Generate total variable.
compute numMen = 1.
variable labels numMen "Number of men age 15-49 years".

*Ladder score. 
recode MLS2 (0 thru 3 =1) (4 thru 6=2) (7 thru 10=3) (99=99) into ladder. 
variable labels ladder "Ladder step reported:" .
value labels ladder 1 "0-3" 2 "4-6" 3 "7-10" 99 "Missing".

recode MLS2 (99 = sysmis) (else = copy) into averageladder .
variable labels averageladder "Average life satisfaction score [3]".

compute happy=0.
if MLS1<=2 happy=100.
variable labels happy "Percentage of men who are very or somewhat happy [4]".

do if (mwage <=2).
+compute numMen1524 = 1.
+variable labels numMen1524 "Number of men age 15-24 years".
+recode MLS2 (0 thru 3 =1) (4 thru 6=2) (7 thru 10=3) (99=99) into ladder1524. 
+variable labels ladder1524 "Ladder step reported:" .
+value labels ladder1524 1 "0-3" 2 "4-6" 3 "7-10" 99 "Missing".
+recode MLS2 (99 = sysmis) (else = copy) into averageladder1524 .
+variable labels averageladder1524 "Average life satisfaction score [1]".
+compute happy1524=0.
+if MLS1<=2 happy1524=100.
+variable labels happy1524 "Percentage of men who are very or somewhat happy [2]".
end if.

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables =  total 
         display = none
  /format missing = "na" 
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + $mwage [c]
         + mwelevel [c]
         + mmstatus2 [c]
         + mdisability [c]
         + ethnicity [c]
         + windex5 [c]
     by
           ladder1524 [c] [rowpct.validn '' f5.1]
        + averageladder1524 [s] [mean '' f5.1]
        + happy1524 [s] [mean '' f5.1]
        + numMen1524 [s] [sum, '', f5.0]
        +  ladder [c] [rowpct.totaln '' f5.1]
        + averageladder [s] [mean '' f5.1]
        + happy [s] [mean '' f5.1]
        + numMen [s] [sum, '', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=ladder1524 ladder  total=yes position= after label= "Total"
  /slabels position=column visible = no
  /titles title=
     "Table EQ.4.1M: Overall life satisfaction and happiness (men)"
     "Percentage of men age 15-24 and 15-49 years by level of overall life satisfaction, average life satisfaction score, and the percentage who are very or somewhat satisfied with their life overall, " + surveyname
  caption=
 "[1] MICS Indicator EQ.9a - Life satisfaction among men age 15-24" 
 "[2] MICS indicator EQ.10a - Happiness among men age 15-24" 
 "[3] MICS Indicator EQ.9b - Life satisfaction among men age 15-49" 
 "[4] MICS indicator EQ.10b - Happiness among men age 15-49"
 "na: not applicable".

new file.
