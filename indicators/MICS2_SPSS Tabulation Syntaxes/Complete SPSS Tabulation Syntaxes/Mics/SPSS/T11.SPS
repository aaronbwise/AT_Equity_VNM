get file = 'hl.sav'.

weight by hhweight.

select if (HL4 >= 5 and HL4 <= 12).

recode ED17 (1 = 100) (else = 0) into school.
variable label school "Attending school".

tables
  /observation = school
  /ftotal = tot1 "Total"
  /tables = HI7 + HI6 + HL4 + tot1 by HL3 > school + tot1
  /statistics
    mean(school (f5.1) 'Attending')
    validn(school (f5.0) 'Number')
  /title
    "Table 11: Percentage of children of primary school age attending primary school, Country, Year"
  /caption
    "World Summit for Children Goal => Number 6".
