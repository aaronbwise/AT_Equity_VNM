get file = 'wm.sav'.

weight by wmweight.

tables
  /ftotal = tot1 "Total"
  /table = HI7 + HI6 + wage + mstatus + CM1 + melevel + tot1 by (statistics)
  /statistics
    cpct(HI7 (f5.1) 'Percent')
    count(HI7 (f5.0) 'Number')
    unw count(HI7 (f5.0) 'Unweighted')
    cpct(HI6 (f5.1) 'Percent')
    count(HI6 (f5.0) 'Number')
    unw count(HI6 (f5.0) 'Unweighted')
    cpct(wage (f5.1) 'Percent')
    count(wage (f5.0) 'Number')
    unw count(wage (f5.0) 'Unweighted')
    cpct(mstatus (f5.1) 'Percent')
    count(mstatus (f5.0) 'Number')
    unw count(mstatus (f5.0) 'Unweighted')
    cpct(CM1 (f5.1) 'Percent')
    count(CM1 (f5.0) 'Number')
    unw count(CM1 (f5.0) 'Unweighted')
    cpct(melevel (f5.1) 'Percent')
    count(melevel (f5.0) 'Number')
    unw count(melevel (f5.0) 'Unweighted')
  /title
    "Table 5: Percent distribution of women 15-49 by background characteristics, Country, Year".
