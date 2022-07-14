get file = 'hh.sav'.
select if (HH9 = 1).
compute hhweight = hhweight*HH11.
weight by hhweight.

recode WS7 (11,12,13,21,22,31 = 1) (else = 2) into type.
variable label type "Type of toilet facility used by household".
value label type 
	1 "Improved sanitation facility" 
	2 "Unimproved sanitation facility".

select if  (type  = 1).
recode WS9 (97,99 = 99) (sysmis=1) (else = copy) into WS9.
variables labels ws9 "Number of households using the improved sanitation facility".

compute total = 1.
variable label total "Number of household members using improved sanitation facilities".
value label total 1 "".

tables
  /format = zero 
  /ftotal = tot1 "Total" 
 /table = WS7+HH7 + HH6 + helevel + wlthind5 + HC1B + tot1 by 
	   WS9 + tot1 + total 
  /statistics
    cpct(WS9 (f5.1) '': WS7 HH7 HH6 helevel wlthind5 HC1B)  
    count(total (f5.0) '')
  /title
    "Table EN.5w: Shared use of improved sanitation facilities (working table)"+
		"Percent distribution of household population using improved sanitation facilities by number"+
                        " of the households using the facility, Country, Year".
new file.

