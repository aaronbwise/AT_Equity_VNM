get file = 'hl.sav'.

weight by hhweight.

recode WS3 (1,2,3,4 = 100) (else = 0) into sanitary.
variable label sanitary "Total with sanitary means of excreta disposal".

tables
  /observation = sanitary
  /ftotal = tot1 "Total" tot2 "Number of persons"
  /table = HI7 + HI6 + tot1 by WS3 + tot1 + sanitary + tot2
  /statistics
    cpct(WS3 (f5.1) '')
    mean(sanitary (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table 14: Percentage of the population with access to sanitary means of excreta disposal, Country, Year"
  /caption
    "World Summit for Children Goal => Number 5".
