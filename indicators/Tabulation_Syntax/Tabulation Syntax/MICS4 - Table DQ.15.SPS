* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

select if (schage >= 5 and schage <= 24).
if (ed5 <> 1) ed6a = -1.
if (ed5 <> 1) ed6b  = 0.
if (ed5 = 1 and (ed6a = 8 or ed6a = 9)) ed6a = 8.
if (ed5 = 1 and (ed6a = 0 or ed6a >=3)) ed6b = 0.
if (ed6a = 8 and (missing(ed6b))) ed6b = 98.
if (ed3 =  2 and (missing(ed6a))) ed6a = -1.
if (ed3 =  2 and (missing(ed6b))) ed6b = 0.
variable label ed6a "".
variable label ed6b "".
value label ed6b 0 " ".
compute total = 1.
value label total 1 "Number of household members".
add value label ed6a  -1 "Not attending school" 98 "DK".
add value label ed6b 98 "DK".
add value label ed6b 99 "Missing".

compute tot1 = 100.
variable label tot1 "Total".
value label tot1 100 " ".

format schage (f5.0).

*tables
  /format = zero
  /ftotal = tot1 "Total"
  /table = schage+ tot1 by ed6a > ed6b + tot1 + total
  /statistics
    cpct(ed6b (f5.1) '':schage)
  /title
    "School attendance by single age" 
    "Distribution of household population age 5-24 by educational level and grade attended in the current year, " + surveyname.

ctables
 /vlabels variables = ed6a ed6b total display = none
  /table schage [c] by 
	ed6a[c] > ed6b[c][LAYERROWPCT.VALIDN,'',f5.1] + tot1 [s] [mean, '', f5.1] + total [c][count,'',f5.0]
  /categories var=all empty=exclude 
  /titles title=  "Table DQ.15: School attendance by single age" 
    "Distribution of household population age 5-24 by educational level and educational level and grade attended in the current (or most recent) school year, " + surveyname.

new file.
