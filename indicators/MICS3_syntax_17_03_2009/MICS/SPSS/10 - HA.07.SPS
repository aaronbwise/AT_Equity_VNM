get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM12 = "Y" or CM12 = "O" or CM12 = "S").

compute total = 1.
variable label total "Number of women who gave birth in two years preceding the survey".
value label total 1 "".

compute anc = 0.
if (MN2A = "A" or MN2B = "B" or MN2C = "C") anc = 100.
variable label anc "Received antenatal care from a health professional for last pregnancy".

recode MN4 (1 = 100) (else = 0) into hivprev.
variable label hivprev "Were provided information about HIV prevention during ANC visit *".

recode MN5 (1 = 100) (else = 0) into hivtest.
variable label hivtest "Were tested for HIV at ANC visit".

recode MN6 (1 = 100) (else = 0) into hivresp.
variable label hivresp "Received results of HIV test at ANC visit **".

recode wage (5 thru 7 = 5).
value label wage 1 "15-19" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35-49".

compute layer = 0.
variable label layer "".
value label layer 0 "Percent of women who:".

tables
  /format = zero
  /observation = anc hivprev hivtest hivresp
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1 by 
	  layer > (anc + hivprev + hivtest + hivresp) + total
  /statistics
    mean(anc (f5.1) '')
    mean(hivprev (f5.1) '')
    mean(hivtest (f5.1) '')
    mean(hivresp (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table HA.7: HIV testing and counseling coverage during antenatal care"
		"Percentage of women aged 15-49 years who gave birth in the two years "+
		"preceding the survey who were offered HIV testing and counseling "+
                        "with their antenatal care, Country, Year"
  /caption
    "* MICS Indicator 90"
    "** MICS Indicator 91".

new file.
