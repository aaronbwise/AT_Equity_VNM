get file = 'ch.sav'.

weight by chweight.

tables
  /ftotal = tot1 "Total"
  /table = HL3 + HI7 + HI6 + cage_6 + melevel + tot1 by (statistics)
  /statistics
    cpct(HL3 (f5.1) 'Percent')
    count(HL3 (f5.0) 'Number')
    unw count(HL3 (f5.0) 'Unweighted')
    cpct(HI7 (f5.1) 'Percent')
    count(HI7 (f5.0) 'Number')
    unw count(HI7 (f5.0) 'Unweighted')
    cpct(HI6 (f5.1) 'Percent')
    count(HI6 (f5.0) 'Number')
    unw count(HI6 (f5.0) 'Unweighted')
    cpct(cage_6 (f5.1) 'Percent')
    count(cage_6 (f5.0) 'Number')
    unw count(cage_6 (f5.0) 'Unweighted')
    cpct(melevel (f5.1) 'Percent')
    count(melevel (f5.0) 'Number')
    unw count(melevel (f5.0) 'Unweighted')
  /title
    "Table 6: Percent distribution of children under 5 by background characteristics, Country, Year".
