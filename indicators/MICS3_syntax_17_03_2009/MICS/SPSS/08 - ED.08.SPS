get file = 'wm.sav'.

select if (WM7 = 1).
weight by wmweight.

select if (WM9 >= 15 and WM9 <= 24).

compute literate  = 0.
if (WM14 = 3 or WM11 = 2 or WM11 = 3) literate = 100.
variable label literate "Percentage literate *".

compute notknown = 0. 
if (WM14 = 4 or WM14 = 8 or WM14 = 9) notknown = 100.
variable label notknown "Percentage not known ".

recode WM9 (15 thru 19 = 1) (20 thru 24 = 2) into agegrps.
variable label agegrps "Age".
value label agegrps
  1 "15-19"
  2 "20-24".

compute total = 1.
variable label total "Number of women aged 15-24 years".
value label total 1 "".

tables
  /format = zero
  /observation = literate notknown
  /ftotal = tot1 "Total" tot2 "Number"
  /table = HH7 + HH6 + melevel + agegrps + wlthind5 + HC1B + tot1 by
	  literate + notknown + total
  /statistics
    mean(literate (f5.1) '')
    mean(notknown (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table ED.8: Adult literacy"
		"Percentage of women aged 15-24 years that are literate, Country, year"
  /caption
    "* MICS Indicator 60; MDG Indicator 8".

new file.
