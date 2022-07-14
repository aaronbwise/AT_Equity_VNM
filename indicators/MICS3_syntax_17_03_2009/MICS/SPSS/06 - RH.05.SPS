get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM12 = "Y" or CM12 = "O" or CM12 = "S").

compute total = 1.
variable label total "Number of women who gave birth in preceding two years".
value label total 1 "".

compute dcare = 0.
if (MN7A = "A") dcare = 1.
if (dcare = 0 and MN7B = "B") dcare = 2.
if (dcare = 0 and MN7C = "C") dcare = 3.
if (dcare = 0 and MN7F = "F") dcare =  4.
if (dcare = 0 and MN7G = "G") dcare = 5.
if (dcare = 0 and MN7H = "H") dcare = 6.
if (dcare = 0 and (MN7X = "X" or MN7A = "?")) dcare = 7.
if (dcare = 0 and MN7Y = "Y") dcare = 8.
variable label dcare "Person assisting at delivery".
value label dcare
  1 "Medical doctor"
  2 "Nurse/midwife"
  3 "Auxiliary midwife"
  4 "Traditional birth attendant"
  5 "Community health worker"
  6 "Relative/friend"
  7 "Other/missing"
  8 "No attendant".

compute skilled = 0.
if (dcare = 1 or dcare = 2 or dcare = 3) skilled = 100.
variable label skilled "Any skilled personnel *".

recode MN8 (21,22,26,31,32,33,36 = 100) (else = 0) into facility.
variable label facility "Delivered in health facility **".

tables
  /format = zero
  /observation = skilled facility
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1 by 
	  dcare + tot1 + skilled + facility + total
  /statistics
    cpct(dcare (f5.1) '': HH7 HH6 wage melevel wlthind5 HC1B)
    mean(skilled (f5.1) '')
    mean(facility (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table RH.5: Assistance during delivery"
		"Percent distribution of women aged 15-49 with a birth in two years "+
		"preceding the survey by type of personnel assisting at delivery, Country, Year"
  /caption
    "* MICS indicator 4; MDG indicator 17"
		"** MICS indicator 5".

new file.
