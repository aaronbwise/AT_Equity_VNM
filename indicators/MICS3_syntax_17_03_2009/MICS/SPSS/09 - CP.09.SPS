get files="wm.sav".

select if (WM7 = 1).

weight by wmweight.

compute total = 1.
value label total 1 "".
variable label total "Number of women aged 15-49 years".

compute goesout = 0.
if (DV1A = 1) goesout = 100.
variable label goesout "When she goes out without telling him".

compute neglects = 0.
if (DV1B = 1) neglects = 100.
variable label neglects "When she neglects the children".

compute argues = 0.
if (DV1C = 1) argues = 100.
variable label argues "When she argues with him".

compute refuses = 0.
if (DV1D = 1) refuses = 100.
variable label refuses "When she refuses sex with him".

compute burns = 0.
if (DV1E = 1) burns = 100.
variable label burns "When she burns the food".

compute any = 0.
if (goesout = 100 or neglects = 100 or argues = 100 or refuses = 100 or 
  burns = 100) any = 100.
variable label any "For any of these reasons*".

compute layer = 0.
variable label layer "".
value label layer 0 "Percentage of women aged 15-49 years who believe a husband is justified in beating his wife/partner:".

tables
  /format = zero
  /observation = goesout neglects argues refuses burns any   
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + mstatus + melevel + wlthind5 + HC1B + tot1 by 
	  layer > (goesout + neglects + argues + refuses + burns + any) + total
  /statistics
    mean(goesout (f5.1) '')
    mean(neglects (f5.1) '')
    mean(argues (f5.1) '')
    mean(refuses (f5.1) '')
    mean(burns (f5.1) '')
    mean(any (f5.1) '')
    count(total (f5.0) '')
 /title
    "Table CP.9: Attitudes toward domestic violence"
		"Percentage of women aged 15-49 years who believe a husband is justified in beating his "+
		"wife/partner in various circumstances, Country, Year"
  /caption                                                                                                                                                                          
    "* MICS Indicator 100".

new file.
