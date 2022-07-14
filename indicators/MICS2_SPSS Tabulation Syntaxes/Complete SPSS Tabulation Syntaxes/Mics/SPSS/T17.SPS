get file = 'hh.sav'.

weight by hhweight.

recode SI1 (8 = 100) (else = 0) into nosalt.
variable label nosalt "Percent of households with no salt".

recode SI1 (1,2,3 = 100) (else = 0) into salttest.
variable label salttest "Percent of households in which salt was tested".

recode SI1 (1,2 = 1) (3 = 2) (else = sysmis) into iodized.
variable label iodized "Result of test".
value label iodized
  1 "< 15 PPM"
  2 "15+ PPM".

compute total = 1.
variable label total "Number of households interviewed".
value label total 1 "Total".

tables
  /observation = nosalt salttest
  /ftotal = tot1 "Total"
  /table = HI7 + HI6 + tot1 by nosalt + salttest + iodized + total
  /statistics
    mean(nosalt (f5.1) '')
    mean(salttest (f5.1) '')
    cpct(iodized (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table 17: Percentage of households consuming adeuqately iodized salt, Country, Year"
  /caption
    "World Summit for Children Goal => Number 14".
