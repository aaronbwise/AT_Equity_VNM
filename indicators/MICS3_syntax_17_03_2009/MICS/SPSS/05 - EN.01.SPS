get file = 'hh.sav'.
select if (HH9 = 1).
compute hhweight = hhweight*HH11.
weight by hhweight.

recode WS1 (98,99 = 99) (else = copy) into WS1.

compute improved = 0.
if (WS1 = 11 or  WS1 = 12 or WS1 = 13 or WS1 = 21 or WS1 = 31 or WS1 = 41 or 
  WS1 = 51) improved = 100.
if ((WS2 = 11 or WS2 = 12 or WS2 = 13 or WS2 = 21 or WS2 = 31 or WS2 = 41 or 
  WS2 = 51) and WS1 = 91) improved = 100. 
variable label improved "Improved source of drinking water".

recode improved (100 = 1) (else = 2) into type.
variable label WS1 "".
variable label type "Main source of drinking water".
value label type 
	1 "Improved sources"
	2 "Unimproved sources".

tables
  /format = zero
  /observation = improved
  /ftotal = tot1 "Total" tot2 "Number of household members"
  /table = HH7 + HH6 + helevel + wlthind5 + HC1B + tot1 by 
	  type > WS1 + tot1 + improved + tot2
  /statistics
    cpct(ws1 (f5.1) '':HH7 HH6 helevel wlthind5 HC1B)
    mean(improved (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table EN.1: Use of improved water sources"
		"Percent distribution of household population according to main source of "+
		"drinking water and percentage of household members using improved "+
		"drinking water sources, Country, Year"
  /caption
    "* MICS indicator 11; MDG indicator 30".

new file.
