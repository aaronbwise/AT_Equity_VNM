get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

recode HC6 (97,99 = 99) (else = copy) into HC6.

recode HC6 (06,07,08,09,10,11 = 100) (else  = 0) into sfuels.
variable label sfuels "Solid fuels for cooking *".

tables
  /format = zero
  /observation = sfuels
  /ftotal = tot1 "Total" tot2 "Number of households"
  /table = HH7 + HH6 + helevel + wlthind5 + HC1B + tot1 by 
	  HC6 + tot1 + sfuels + tot2
  /statistics
    cpct(HC6 (f5.1) '':HH7 HH6 helevel wlthind5 HC1B)
    mean(sfuels (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table CH.8: Solid fuel use"
		"Percent distribution of households according to type of cooking fuel, "+
		"and percentage of households used solid fuels for cooking, Country, Year"
  /caption
    "* MICS indicator 24; MDG indicator 29".

new file.
