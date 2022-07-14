get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

compute total  = 1.
variable label total "Number of housholds".

recode WS3 (995 = 1) (0 thru 14 = 2) (15 thru 29 = 3) (30 thru 59 = 4) 
  (60 thru 990 = 5) (998 = 8) (999 = 9) into time.
if (WS1 = 11 | WS1 = 12) time = 1. 
variable label time "Time to source of drinking water".
value label time 
	1 "Water on premises"
	2 "Less than 15 minutes"
	3 "15 minutes to less than 30 minutes"
	4 "30 minutes to less than 1 hour"
	5 "1 hour or more"
	8 "DK"
	9 "Missing" .

recode WS3 (995,998,999=sysmis) (else = copy) into tsource.
variable label tsource "Mean time to source of drinking water (excluding "+
  "those on premises)".

tables
  /format = zero
  /ftotal = tot1 "Total" tot2 "Number of households"
  /observations = tsource
  /table = HH7 + HH6 + helevel + wlthind5 + HC1B + tot1 by time + tot1 + 
	  tsource + tot2 
  /statistics
    cpct(time (f5.1) '':HH7 HH6 helevel wlthind5 HC1B)
    mean(tsource (f5.1) '')
   count(tot2 (f5.0) '')
  /title
    "Table EN.3: Time to source of water"
		"Percent distribution of households according to time to go to source of "+
		"drinking water, get water and return, and mean time to source of "+
		"drinking water, Country, Year".

new file.
