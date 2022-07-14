* This data quality table is only produced for surveys that have included a birth history.

include "surveyname.sps".

* Please note that the bh.sav file should be the unimputed.
get file = 'bh.sav'.

weight by wmweight.

select if (BH4Y > 1992 and BH4Y < 2013).

recode BH4Y (2008 thru 2012 = 1) (2003 thru 2007 = 2) (1998 thru 2002 = 3) (1993 thru 1997 = 4) (else = sysmis) into year.
variable labels year 'Number of years preceding the survey'.
value labels year
 1 '0-4'
 2 '5-9'
 3 '10-14'
 4 '15-19'.

do if (BH9U = 2 and BH9N < 24).
+ compute months = BH9N.
+ compute total = 1.
end if.

do if (BH9U = 1 and BH9N < 31).
+ compute months = 0.
+ compute total = 1.
end if.

do if (months < 12).
+ recode months ( 0 = 100) (else = 0) into nn.
+ compute tot = 1.
end if.

variable labels nn "Percent neonatal*".

variable labels months 'Age at death (months)'.
formats months (f2.0).

variable labels tot 'Total 0-11 months'.
value labels tot 1 ' '.
variable labels total ''.
value labels total 1 'Total 0-19'.

ctables
  /vlabels variables = total display = none
  /table months [c] [count,'',f5.0]+ tot [c] + nn [s] [mean,'',f5.1] by 
  year [c] + total [c]      
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
    "DQ.19: Reporting of age at death in months" 
		"Distribution of reported deaths under two years of age by age at death in months and the percentage of infant deaths reported to occur at " +
  "age under one month, by 5-year periods preceding the survey (weighted, unimputed), " + surveyname
  caption=
		"* <1 month / <1 year".

new file.