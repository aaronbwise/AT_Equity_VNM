* v02 - 2014-05-08.
* syntax simplified.

* This data quality table is only produced for surveys that have included a birth history.

include "surveyname.sps".

* Please note that the bh.sav file should be the unimputed.
get file = 'bh.sav'.

weight by wmweight.

compute period = trunc((wdoi-BH4C)/60).
variable labels period "Number of years preceding the survey".
value labels period 0 '0-4' 1 '5-9' 2 '10-14' 3 '15-19'.

select if (((BH9U <= 2 and BH9N < 99) or (BH9U=3 and BH9N=1)) and period<=3).

compute total = 1.
value labels total 1 "Total 0-19".
if (BH9U=1) BH9N=0.
if (BH9N<=11 and BH9U<=2)  tot1 = 1.
value labels tot1 1 "Total 0-11".
if (BH9U=1) BH9N=0.
if (BH9U=3 and BH9N=1) BH9N = 97.
value labels BH9N 97 "Reported as 1 year".
recode BH9N (0=100)(1 thru 11=0)(else=sysmis) into neonat.
variable labels neonat "Percent neonatal [b]".

add value labels bh9n 0 "0 [a]".

ctables
  /vlabels variables = total bh9n tot1  display = none
  /table (bh9n + tot1) [c][count comma5.0]  + neonat [s][mean f5.1] by (period + total) [c] 
  /slabels position=row visible = no
  /titles title=
    "Table DQ.26: Reporting of age at death in months" 
  	"Distribution of reported deaths under two years of age by age at death in months and the percentage of infant deaths reported to occur at " +
 	"age under one month, by 5-year periods preceding the survey (imputed), " + surveyname
  corner="Age at death (months)"
  caption=
		"[a] Includes deaths under one month reported in days"
		"[b] Deaths under one month, divided by deaths under one year".

new file.