get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

variable label CM1 "Motherhood status".
value label CM1 
	1 "Ever gave birth" 
	2 "Never gave birth".

tables
  /format = zero
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + mstatus + CM1 + melevel + wlthind5 + HC1B + tot1 
		by (statistics)
  /statistics
    cpct(HH7 (f5.1) 'Weighted percent')
    count(HH7 (f5.0) 'Number of women weighted')
    unw count(HH7 (f5.0) 'Number of women unweighted')
    cpct(HH6 (f5.1) 'Weighted percent')
    count(HH6 (f5.0) 'Number of women weighted')
    unw count(HH6 (f5.0) 'Number of women unweighted')
    cpct(wage (f5.1) 'Weighted percent')
    count(wage (f5.0) 'Number of women weighted')
    unw count(wage (f5.0) 'Number of women unweighted')
    cpct(mstatus (f5.1) 'Weighted percent')
    count(mstatus (f5.0) 'Number of women weighted')
    unw count(mstatus (f5.0) 'Number of women unweighted')
    cpct(CM1 (f5.1) 'Weighted percent')
    count(CM1 (f5.0) 'Number of women weighted')
    unw count(CM1 (f5.0) 'Number of women unweighted')
    cpct(melevel (f5.1) 'Weighted percent')
    count(melevel (f5.0) 'Number of women weighted')
    unw count(melevel (f5.0) 'Number of women unweighted')
    cpct(wlthind5 (f5.1) 'Weighted percent')
    count(wlthind5 (f5.0) 'Number of women weighted')
    unw count(wlthind5 (f5.0) 'Number of women unweighted')
    cpct(HC1B (f5.1) 'Weighted percent')
    count(HC1B (f5.0) 'Number of women weighted')
    unw count(HC1B (f5.0) 'Number of women unweighted')
  /title
    "Table HH.4: Women's background characteristics" 
		"Percent distribution of women aged 15-49 years by background "+
		"characteristics, Country, Year".

new file.
