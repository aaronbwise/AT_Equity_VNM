get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

compute mosquito = 0.
if (TN1 = 1 and TN2 >= 1 and TN2 <= 7) mosquito = 100.
variable label mosquito "Percentage of households with at least one mosquito "+
  "net".

compute treated  = 0.
if (TN3L1 = 1 or TN3L2 = 1) treated = 100.
if ((TN3P1 = 1 or TN3P2  = 1) and  TN6 < 12) treated = 100.
if ((TN3O1 = 1 or TN3O2 = 1 or TN3O3 = 1 or TN3O4 = 1) and 
  TN5 = 1 and  TN6 < 12) treated = 100.
if (TN7 = 1 and TN8 < 12) treated = 100.
variable label treated "Percentage of households with at least one "+
  "insecticide treated net (ITN)*".

tables
  /format = zero
  /observation = mosquito treated
  /ftotal = tot1 "Total" tot2 "Number of households"
  /table = HH7 + HH6 + helevel + wlthind5 + HC1B + tot1 by 
	  mosquito + treated + tot2
  /statistics
    mean(mosquito (f5.1) '')
    mean(treated (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table CH.10: Availability of insecticide treated nets"
		"Percent of households with at least one insecticide treated net (ITN), "+
		"Country, Year"
  /caption
    "* MICS Indicator 36".

new file.
