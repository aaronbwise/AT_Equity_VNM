get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

compute twoways = 0.
if (HA2 = 1 and HA4 = 1) twoways = 100.
variable label twoways "Knows 2 ways to prevent HIV transmission".

* The 3 misconceptions should be the same set of misconceptions as used in HA02.
compute threemis = 0.
if (HA3 = 2 and HA5 = 2 and HA8 = 1) threemis = 100.
variable label threemis "Correctly identify 3 misconceptions about HIV transmission".

compute compre = 0.
if (twoways = 100 and threemis = 100) compre = 100.
variable label compre "Have comprehensive knowledge" +
   "(identify 2 prevention methods and 3 misconceptions) *".

recode wage (1,2=copy) (else=sysmis) into wage1.
recode wage (1=2) (else=copy) into wage2.
variable label wage1 "Age".
variable label wage2 " ".
value label wage1 1 "15-19" 2 "20-24".
value label wage2 2 "  15-24" 3 "25-29" 4 "30-34" 5 "35-39" 6 "40-44" 7 "45-49".

compute total = 1.
value label total 1 "".
variable label total "Number of women".

tables
  /format = zero
  /observation twoways threemis compre
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage1 + wage2 + melevel + wlthind5 + HC1B + tot1 by
    twoways + threemis + compre + total
  /statistics
    mean(twoways (f5.1) '')
    mean(threemis (f5.1) '')
    mean(compre (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table HA.3: Comprehensive knowledge of HIV/AIDS transmission"
		"Percentage of women aged 15-49 years who have comprehensive knowledge "+
		"of HIV/AIDS transmission, Country, Year"
  /caption
    "* MICS Indicator 82; MDG Indicator 19b".

new file.
