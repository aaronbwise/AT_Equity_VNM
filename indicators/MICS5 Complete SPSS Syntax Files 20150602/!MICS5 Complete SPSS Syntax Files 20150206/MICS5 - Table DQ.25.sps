* v02 - 2014-05-08.
* syntax simplified.

***.

* This data quality table is only produced for surveys that have included a birth history.

include "surveyname.sps".

* Please note that the bh.sav file should be the unimputed.
get file = 'bh.sav'.

weight by wmweight.

compute period = trunc((wdoi-BH4C)/60).
variable labels period "Number of years preceding the survey".
value labels period 0 '0-4' 1 '5-9' 2 '10-14' 3 '15-19'.

select if (BH9U = 1 and BH9N < 99 and period<=3).

compute tot30 = (BH9N<=31).

compute total = 1.
value labels total 1 "Total 0-19".
compute tot1 = 1.
value labels tot1 1 "Total 0-30".
value labels BH9N 0 "0".
recode BH9N (0 thru 6=100)(7 thru hi=0) into neonat.
variable labels neonat "Percent early neonatal*".

ctables
  /vlabels variables = total bh9n tot1  display = none
  /table (bh9n + tot1) [c][count comma5.0]  + neonat [s][mean f5.1] by (period + total) [c] 
  /categories var = all empty = exclude missing = exclude
  /slabels position = row visible = no
  /titles title=
   "Table DQ.25: Reporting of age at death in days" 
   "Distribution of reported deaths under one month of age by age at death in days and the percentage of neonatal deaths reported to occur at " +
   "ages 0-6 days, by 5-year periods preceding the survey (imputed), " + surveyname
  corner="Age at death (days)"
  caption=
	"* Deaths during the first 7 days (0-6), divided by deaths during the first month (0-30 days)".
					
new file.