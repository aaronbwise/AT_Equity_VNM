get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM12 = "Y" or CM12 = "O" or CM12 = "S").

compute total = 1.
value labels total 1 "".
variable label total "Number of women who gave birth in the preceding two years".

compute anc = 0.
if (MN2A = "A") anc = 1.
if (anc = 0 and MN2B = "B") anc = 2.
if (anc = 0 and MN2C = "C") anc = 3.
if (anc = 0 and MN2F = "F") anc = 4.
if (anc = 0 and MN2G = "G") anc = 5.
if (anc = 0 and MN2H = "H") anc = 6.
if (anc = 0 and (MN2X = "X" or MN2A = "?")) anc = 7.
if (anc = 0 and MN2Y = "Y") anc = 8.
variable label anc "Person providing antenatal care".
value label anc
  1 "Medical doctor"
  2 "Nurse/midwife"
  3 "Auxiliary midwife"
  4 "Traditional birth attendant"
  5 "Community health worker"
  6 "Relative/Friend"
  7 "Other/missing"
  8 "No antenatal care received".

compute skilled = 0.
if (anc = 1 or anc = 2 or anc = 3) skilled = 100.
variable label skilled "Any skilled personnel *".

tables
  /format = zero
  /observation = skilled
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 +HC1B + tot1 
	  by anc + tot1 + skilled + total
  /statistics
    cpct(anc (f5.1) '':HH7 HH6 wage melevel wlthind5 HC1B)
    mean(skilled (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table RH.3: Antenatal care provider"
		"Percent distribution of women aged 15-49 who gave birth in the two "+
		"years preceding the survey by type of personnel providing antenatal "+
		"care, Country, Year"
  /caption
    "* MICS indicator 20".

new file.
