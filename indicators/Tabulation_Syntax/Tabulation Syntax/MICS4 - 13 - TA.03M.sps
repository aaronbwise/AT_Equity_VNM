include "surveyname.sps".

get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.

compute total = 1.
variable label total "".
value label total 1 "Number of men age 15-49 years".

* Never had one drink of alcohol.
compute noalcohol = 0.
if (MTA14 = 2 or MTA15 = 00) noalcohol = 100.
variable label noalcohol "Never had one drink of alcohol".

* Had at least one drink of alcohol before age 15.
compute alcohol15 = 0.
if (MTA15 > 00 and MTA15 < 15) alcohol15 = 100.
variable label alcohol15 "Had at least one drink of alcohol before age 15 [1]".

* Had at least one drink of alcohol on one or more days during the last one month.
compute atleast1 = 0.
if (MTA16 > 00 and MTA16 < 98) atleast1 = 100.
variable label atleast1 "Had at least one drink of alcohol on one or more days during the last one month [2]".

compute layer0 = 0.
variable label layer0 "".
value label layer0 0 "Percentage of men who:".

compute tot = 1.
variable label tot "".
value label tot 1 "Total".

ctables
  /vlabels variables =  total layer0 tot
         display = none
  /table wage [c] + hh7 [c] + hh6 [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by
	 layer0 [c] > (noalcohol [s] [mean,'',f5.1] + alcohol15 [s] [mean,'',f5.1] + atleast1 [s] [mean,'',f5.1]) + total[c][count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
	"Table TA.3M: Use of alcohol"						
	"Percentage of men age 15-49 who have never had one drink of alcohol,  " 
	"percentage who first had one drink of alcohol before age 15, "
	"and percentage of men who have had at least one drink of alcohol on one or more days during the last one month, " + surveyname						
 caption = 
     	"[1] MICS indicator TA.4"
	"[2] MICS indicator TA.3".				
														
new file.
