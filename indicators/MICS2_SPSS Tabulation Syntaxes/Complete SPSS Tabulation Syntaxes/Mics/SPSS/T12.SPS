get file = 'hl.sav'.

weight by hhweight.

select if (HL4 >= 15 and HL4 < 97).

recode HL8 (1,2 = 100) (else = 0) into literate.
variable label literate "Literate".

recode HL8 (7,9 = 100) (else = 0) into notknown.
variable label notknown "Not known".

recode HL4 (15 thru 24 = 1) (25 thru 34 = 2) (35 thru 44 = 3) (45 thru 54 = 4)
           (55 thru 64 = 5) (65 thru 96 = 6) into agegrps.
variable label agegrps "Age".
value labels agegrps
  1 "15-24"
  2 "25-34"
  3 "35-44"
  4 "45-54"
  5 "55-64"
  6 "65+".

compute total = 1.
variable label total "Number".
value label total 1 ''.

tables
  /observation = literate notknown
  /ftotal = tot1 "Total" tot2 "Number"
  /table = HI7 + HI6 + agegrps + tot1 by HL3 > (literate + notknown + total) + tot1
  /statistics
    mean(literate (f5.1) '')
    mean(notknown (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table 12: Percentage of the population aged 15 years and older that is literate, Country, Year"
  /caption
    "World Summit for Children Goal => Number 7".
