get file = 'hl.sav'.

weight by hhweight.

recode HL5 (0 thru 4 = 1) (5 thru 9 = 2) (10 thru 14 = 3) (15 thru 17 =4) into agegrp.
variable label agegrp "Age".
value label agegrp
  1 "0-4 years"
  2 "5-9 years"
  3 "10-14 years"
  4 "15-17 years".

compute ill = 0.
if (HL10A = 1 or HL12A = 1) ill = 100.
variable label ill "Chronically ill".

compute death = 0.
if (OV4 = 1) death = 100.
variable label death "Adult death in household".

compute chroill = 0.
if (TOHL8A >= 1) chroill = 100.
variable label chroill "Chronically ill adult in household".

compute vulne = 0.
if (ill = 100 or death = 100 or chroill = 100) vulne = 100.
variable label vulne "Vulnerable children".

compute oneboth = 0.
if (HL9 = 2 or HL11 = 2) oneboth = 100.
variable label oneboth "One or both parents dead".

compute orphans = 0.
if (vulne = 100 or oneboth = 100) orphans = 100.
variable label orphans "Orphans and vulnerable children".

select if (orphans = 100 and HL5 >= 0 and HL5 <= 17).

compute torphans = 1.
value label torphans 1 "".
variable label torphans "Number of children orphaned or vulnerable aged 0-17 years".

recode OV10 (1 = 100) (else = 0) into medical.
variable label medical "Medical support (in last 12 months)".

recode OV12 (1 = 100) (else = 0) into emot.
variable label emot "Emotional and psychosocial support (in last 3 months)".

compute socmat  = 0.
if (OV14 = 1 or OV16 = 1) socmat = 100.
variable label socmat "Social/material support (in last 3 months)". 

recode OV18 (1 = 100) (else = 0) into educat.
variable label educat "Educational support (in last 12 months)".

compute any = 0.
if (HL5 >= 0 and HL5 <= 4 and (medical = 100 or emot = 100 or socmat = 100)) any = 100.
if (HL5 >= 5 and HL5 <= 17 and (medical = 100 or emot = 100 or socmat = 100 or educat = 100)) any = 100.
variable label any "Any support *".

compute alltype = 0.
if (HL5 >= 0 and HL5 <= 4 and medical = 100 and emot = 100 and socmat = 100) alltype = 100.
if (HL5 >= 5 and HL5 <= 17 and medical = 100 and emot = 100 and socmat = 100 and educat = 100) alltype = 100.
variable label alltype "All types of support".

recode any (100 = 0) (0 = 100) into nosupp.
variable label nosupp "No support at all".

compute layer = 0.
variable label layer "".
value label layer 0 "Percent of orphans and vulnerable children whose households received:".

tables
  /format = zero
  /observation = medical emot socmat educat any alltype nosupp torphans 
  /ftotal = tot1 "Total" tot2 "Number of children"
  /tables = HL4 + HH7 + HH6 + agegrp + wlthind5 + HC1B + tot1 by 
	  layer > (medical + emot + socmat + educat + any + alltype + nosupp) + torphans
  /statistics
    mean(medical (f5.1) '')
    mean(emot (f5.1) '')
    mean(socmat (f5.1) '')
    mean(educat (f5.1) '')
    mean(any (f5.1) '')
    mean(alltype (f5.1) '')
    mean(nosupp (f5.1) '')
    sum(torphans (f5.0) '')
  /title
  /title
    "Table HA.13: Support for children orphaned and vulnerable due to AIDS"
		"Percentage of children aged 0-17 years orphaned or made vulnerable due to AIDS whose "+
		"households receive free basic external support in caring for child, Country, Year"
  /caption
    "* MICS Indicator 81".

new file.
