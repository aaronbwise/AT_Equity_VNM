get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM12 = "Y" or CM12 = "O" or CM12 = "S").

compute total = 1.
value labels total 1 "".
variable label total "Number of women who gave birth in the preceding two years".

compute prevent = 0.
if (MN6A = 1) prevent  = 100.
variable label prevent "Medecine to prevent malaria during pregnancy".

compute onetime = 0.
if (MN6BA = "A" and MN6D = 1) onetime  = 100.
variable label onetime "SP/Fansidar only one time".

compute twotimes = 0.
if (MN6BA = "A" and MN6D >= 2 and MN6D < 98) twotimes  = 100.
variable label twotimes "SP/Fansidar two or more times *".

compute fansun = 0.
if (MN6BA = "A" and (MN6D = 98 | MN6D = 99)) fansun  = 100.
variable label fansun "SP/Fansidar but number of times unknown".

compute chloroq = 0.
if (MN6BB = "B") chloroq  = 100.
variable label chloroq "Chloroquine".

compute other = 0.
if (MN6BX = "X") other  = 100.
variable label other "Other medicines".

compute dk = 0.
if (MN6BZ = "Z") dk  = 100.
variable label dk "Don't know medicine".

tables
  /format = zero
  /observation = prevent onetime twotimes fansun chloroq other dk
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + melevel + wlthind5 + HC1B + tot1 by 
	  prevent + onetime + twotimes + fansun + chloroq + other + dk + total
  /statistics
    mean(prevent (f5.1) '')
    mean(onetime (f5.1) '')
    mean(twotimes (f5.1) '')
    mean(fansun (f5.1) '')
    mean(chloroq (f5.1) '')
    mean(other (f5.1) '')
    mean(dk (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table CH.13: Intermittent preventive treatment for malaria"
		"Percent distribution of women aged 15-49 years with a birth in two years "+
		"preceding the survey who received intermittent preventive therapy (IPT) "+
    "for malaria during pregnancy ,Country, Year"
  /caption
    "* MICS Indicator 40".

new file.
