get file = 'hl.sav'.

weight by hhweight.

select if (HL4 >= 0 and HL4 <= 14).

recode HL4 (0 thru 4 = 1) (5 thru 9 = 2) (10 thru 14 = 3) into agegrp.
variable label agegrp "Age".
value label agegrp
  1 "0-4 years"
  2 "5-9 years"
  3 "10-14 years".

compute status = 0.
if (HL11 = 1 and HL13 = 1) status = 1.
if (HL10 <> 1 and HL12 = 1 and HL13 <> 1) status = 2.
if (HL10 = 1 and HL11 <> 1 and HL12 <> 1) status = 3.
if (HL10 = 1 and HL11 <> 1 and HL12 = 1 and HL13 <> 1) status = 4.
if (HL10 <> 1 and HL12 <> 1) status = 5.
if (HL11 = 1 and HL12 = 1 and HL13 <> 1) status = 6.
if (HL11 = 1 and HL12 <> 1) status = 7.
if (HL13 = 1 and HL10 = 1 and HL11 <> 1) status = 8.
if (HL13 = 1 and HL10 <> 1) status = 9.
if (HL10 = 7 or HL10 = 9 or HL12 = 7 or HL12 = 9) status = 10.
variable label status "Living arrangement".
value label status
  1 "Living with both parents"
  2 "Living with neither: only father alive"
  3 "Living with neither: only mother alive"
  4 "Living with neither: both are alive"
  5 "Living with neither: both are dead"
  6 "Living with mother only: father alive"
  7 "Living with mother only: father dead"
  8 "Living with father only: mother alive"
  9 "Living with father only: mother dead"
  10 "Impossible to determine".

compute noparent = 0.
if (status >= 2 and status <= 5) noparent = 100.
variable label noparent "Not living with a biological parent".

compute oneboth = 0.
if (status = 2 or status = 3 or status = 5 or status = 7 or status = 9) oneboth = 100.
variable label oneboth "One or both parents dead".

tables
  /observation = noparent oneboth
  /ftotal = tot1 "Total" tot2 "Number of children"
  /tables = HL3 + HI7 + HI6 + agegrp + tot1 by status + tot1 + noparent + oneboth + tot2
  /statistics
    cpct(status (f5.1) '':HL3 HI7 HI6 agegrp)
    mean(noparent (f5.1) '')
    mean(oneboth (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table 41: Percentage of children 0-14 years of age in households not living with a biological parent, Country, Year"
  /caption
    "Monitoring Children's Rights Indicator".
