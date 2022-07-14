get file = 'ch.sav'.

select if (UF9 = 1).
weight by chweight.

tables
  /format = zero
  /ftotal = tot1 "Total"
  /table = HL4 + HH7 + HH6 + cage_6 + melevel + wlthind5 + HC1B + tot1 
		by (statistics)
  /statistics
    cpct(HL4 (f5.1) 'Weighted percent')
    count(HL4 (f5.0) 'Number of under-5 children weighted')
    unw count(HL4 (f5.0) 'Number of under-5 children unweighted')
    cpct(HH7 (f5.1) 'Weighted percent')
    count(HH7 (f5.0) 'Number of under-5 children weighted')
    unw count(HH7 (f5.0) 'Number of under-5 children unweighted')
    cpct(HH6 (f5.1) 'Weighted percent')
    count(HH6 (f5.0) 'Number of under-5 children weighted')
    unw count(HH6 (f5.0) 'Number of under-5 children unweighted')
    cpct(cage_6 (f5.1) 'Weighted percent')
    count(cage_6 (f5.0) 'Number of under-5 children weighted')
    unw count(cage_6 (f5.0) 'Number of under-5 children unweighted')
    cpct(melevel (f5.1) 'Weighted percent')
    count(melevel (f5.0) 'Number of under-5 children weighted')
    unw count(melevel (f5.0) 'Number of under-5 children unweighted')
    cpct(wlthind5 (f5.1) 'Weighted percent')
    count(wlthind5 (f5.0) 'Number of under-5 children weighted')
    unw count(wlthind5 (f5.0) 'Number of under-5 children unweighted')
    cpct(HC1B (f5.1) 'Weighted percent')
    count(HC1B (f5.0) 'Number of under-5 children weighted')
    unw count(HC1B (f5.0) 'Number of under-5 children unweighted')
  /title
    "Table HH.5: Children's background characteristics" 
		"Percent distribution of children under five years of age by background "+
		"characteristics, Country, Year".

new file.
