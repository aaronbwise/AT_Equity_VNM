get file = 'hl.sav'.

weight by hhweight.

tables
  /ftotal = tot1 "Total"
  /table = memage + tot1 by hl3
  /statistics
    count(hl3 (f5.0) 'Number')
    cpct(hl3 (f5.1) 'Percent':hl3)
  /title
    "Table 2: Single year age distribution of household population by sex, Country, Year".
