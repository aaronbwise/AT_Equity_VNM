get file = 'hh.sav'.
select if (HH9 = 1).
compute hhweight = hhweight*HH11.
weight by hhweight.

recode WS7 (11,12,13,21,22,31 = 1) (else = 2) into type.
variable label type "Type of toilet facility used by household".
value label type 
	1 "Improved sanitation facility" 
	2 "Unimproved sanitation facility".

recode WS7 (97,99 = 99) (else = copy) into WS7.
variable label WS7 "".

recode type (1 = 100) (else = 0) into sanitary.
variable label sanitary "Percentage of population using sanitary means of excreta disposal *".

tables
  /format = zero 
  /ftotal = tot1 "Total"  tot2 "Number of household members"
 /observations=sanitary
  /table = HH7 + HH6 + helevel + wlthind5 + HC1B + tot1 by 
	  type > WS7 + tot1 + sanitary + tot2 
  /statistics
    cpct(WS7 (f5.1) '':HH7 HH6 helevel wlthind5 HC1B)  
    mean(sanitary  (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table EN.5: Use of sanitary means of excreta disposal"
		"Percent distribution of household population according to type of toilet used by "+
		"the household and the percentage of household members using sanitary "+
		"means of excreta disposal, Country, Year"
  /caption
    "* MICS Indicator 12; MDG Indicator 31".

new file.
