get file = 'hh.sav'.
select if (HH9 = 1).
compute hhweight = hhweight*HH11.
weight by hhweight.

compute total  = 1.
value label total 1 "".
variable label total "Number of housholds".

compute improved = 0.
if (WS1 = 11 or  WS1 = 12 or WS1 = 13 or WS1 = 21 or WS1 = 31 or WS1 = 41 or 
  WS1 = 51) improved = 100.
if ((WS2 = 11 or WS2 = 12 or WS2 = 13 or WS2 = 21 or WS2 = 31 or WS2 = 41 or 
  WS2 = 51) and WS1 = 91) improved = 100. 
variable label improved "Percentage of household population using improved sources of drinking water *".

recode WS7 (11,12,13,21,22,31 = 100) (else = 0) into sanitary.
variable label sanitary "Percentage of household population using sanitary means of excreta disposal **".

compute imwims = 0.
if (improved = 100 and sanitary = 100) imwims = 100.
variable label imwims "Percentage of household population using improved sources"+
  " of drinking water and using sanitary means of excreta disposal".

tables
  /format = zero
  /observation = improved sanitary imwims
  /ftotal = tot1 "Total" tot2 "Number of household members"
  /table = HH7 + HH6 + helevel + wlthind5 + HC1B + tot1 by 
	  improved + sanitary + imwims + tot2
  /statistics
    mean(improved (f5.1) '')
    mean(sanitary (f5.1) '')
    mean(imwims (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table EN.7: Use of improved water sources and improved sanitation"
		"Percentage of household population using both improved drinking water "+
		"sources and sanitary means of excreta disposal, Country, Year"
  /caption
    "* MICS indicator 11; MDG indicator 30"
		"** MICS indicator 12; MDG indicator 31".

new file.
