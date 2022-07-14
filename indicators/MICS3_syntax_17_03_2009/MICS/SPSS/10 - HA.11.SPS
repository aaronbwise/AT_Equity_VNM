get file = 'hl.sav'.

weight by hhweight.

recode HL5 (0 thru 4 = 1) (5 thru 9 = 2) (10 thru 14 = 3) (15 thru 17 = 4) into agegrp.
variable label agegrp "Age".
value label agegrp
  1 "0-4 years"
  2 "5-9 years"
  3 "10-14 years"
  4 "15-17 years".

compute ill = 0.
if (HL10A = 1 or HL12A = 1) ill = 100.
variable label ill "Chronically ill parent".

compute death = 0.
if (OV4 = 1) death = 100.
variable label death "Adult death in household".

compute chroill = 0.
if (TOHL8A >= 1) chroill = 100.
variable label chroill "Chronically ill adult in household".

compute vulne = 0.
if (ill = 100 or death = 100 or chroill = 100) vulne = 100.
variable label vulne "Vulnerable children *".

compute oneboth = 0.
if (HL9 = 2 or HL11 = 2) oneboth = 100.
variable label oneboth "One or both parents dead **".

compute orphans = 0.
if (vulne = 100 or oneboth = 100) orphans = 100.
variable label orphans "Orphans and vulnerable children".

select if (HL5 >= 0 and HL5 <= 17).

tables
  /format = zero
  /observation = ill death chroill vulne oneboth orphans
  /ftotal = tot1 "Total" tot2 "Number of children aged 0-17 years"
  /tables = HL4 + HH7 + HH6 + agegrp + wlthind5 + HC1B + tot1 by
	  ill + death + chroill + vulne + oneboth + orphans + tot2
  /statistics
    mean(ill (f5.1) '')
    mean(death (f5.1) '')
    mean(chroill (f5.1) '')
    mean(vulne (f5.1) '')
    mean(oneboth (f5.1) '')
    mean(orphans (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table HA.11: Prevalence of orphanhood and vulnerability among children"
		"Percentage of children aged 0-17 years who are orphaned or vulnerable "+
		"due to AIDS, Country, Year"
  /caption
    "* MICS Indicator 76"
		"** MICS Indicator 75".

new file.
