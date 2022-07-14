get file = 'hl.sav'.

weight by hhweight.

recode WS1 (97,99 = 99).
value labels WS1
  99 "DK/Missing".

recode WS1 (1,2,3,4,5,6,7 = 100) (else = 0) into safe.
variable label safe "Total with safe drinking water".

tables
  /observation = safe
  /ftotal = tot1 "Total" tot2 "Number of persons"
  /table = HI7 + HI6 + tot1 by WS1 + tot1 + safe + tot2
  /statistics
    cpct(WS1 (f5.1) '')
    mean(safe (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table 13: Percentage of the population with access to safe drinking water, Country, Year"
  /caption
    "World Summit for Children Goal => Number 4".
