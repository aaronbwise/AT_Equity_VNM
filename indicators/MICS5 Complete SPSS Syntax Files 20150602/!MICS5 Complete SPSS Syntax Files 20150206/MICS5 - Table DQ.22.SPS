* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* select only children less than 25 years of age, for whom the education information were collected.
select if (HL6 < 25).

select if (schage >= 5 and schage <= 24).

if (ed3 <> 1) ed6a = -1.
if (ed3 <> 1) ed6b = 0.
if (ed5 <> 1) ed6a = -1.
if (ed5 <> 1) ed6b  = 0.
if (ed5 = 1 and (ed6a = 0 or ed6a >=3)) ed6b = 0.
if (ed5 = 1 and (ed6a = 8 or ed6a = 9)) ed6a = 98.
if (ed6b >= 97) ed6b = 98.
if (schage = 24 and HL6 = 25) ed6a = 95.
if (schage = 24 and HL6 = 25) ed6b = 0.
variable labels ed6a "".
variable labels ed6b "".
value labels ed6b 0 " ".
compute total = 1.
value labels total 1 "Number of household members".
add value labels ed6a 
	 -1 "Not attending school" 
	  1 "Primary school Grade"
	  2 "Secondary school Grade"
	  3 "Higher than secondary"
                  95 "Not able to determine"
	98 "DK/Missing".
                
add value labels ed6b 98 "DK/Missing".

add value labels schage
24 "24 [a]". 

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100 " ".

formats schage (f5.0).

ctables
 /vlabels variables = ed6a ed6b total display = none
  /table schage [c] by 
	ed6a[c] > ed6b[c][LAYERROWPCT.VALIDN,'',f5.1] + tot1 [s] [mean, '', f5.1] + total [c][count,'',f5.0]
  /categories var=all empty=exclude 
  /titles title=  "Table DQ.22: School attendance by single age" 
    "Distribution of household population age 5-24 years by "
     "educational level and and grade attended in the current (or most recent) school year, " + surveyname
  caption = "[a] Those age 25 at the time of interview who were age 24 at beginning of school year are excluded as current attendance was only collected for those age 5-24 at the time of interview".

new file.
