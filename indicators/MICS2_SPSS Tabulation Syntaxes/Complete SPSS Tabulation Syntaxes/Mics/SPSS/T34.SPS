get file = 'wm.sav'.

weight by wmweight.

compute total = 1.
variable label total "Number of women".

compute prevent = 0.
if (HA3 = 1 and HA5 = 1 and HA7 = 1) prevent = 100.
variable label prevent "Know 3 ways to prevent HIV transmission".

compute miscon = 0.
if (HA4 = 2 and HA6 = 2 and HA8 = 1) miscon = 100.
variable label miscon "Correctly identify 3 misconceptions about HIV transmission".

compute knows = 0.
if (prevent = 100 and miscon = 100) knows = 100.
variable label knows "Have sufficient knowledge".

tables
  /observation aids prevent miscon knows
  /ftotal = tot1 "Total"
  /table = HI7 + HI6 + wage + melevel + tot1 by
           aids + prevent + miscon + knows + total
  /statistics
    mean(aids (f5.1) '')
    mean(prevent (f5.1) '')
    mean(miscon (f5.1) '')
    mean(knows (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table 34: Percentage of women aged 15-49 who have sufficient knowledge of HIV/AIDS transmission, Country, Year"
  /caption
    "Monitoring HIV/AIDS Indicator".
