get file = 'hl.sav'.

weight by hhweight.

select if (HL5 >= 0 and HL5 <= 17).

recode HL5 (0 thru 4 = 1) (5 thru 9 = 2) (10 thru 14 = 3) (15 thru 17 = 4) into agegrp.
variable label agegrp "Age".
value label agegrp
  1 "0-4 years"
  2 "5-9 years"
  3 "10-14 years"
  4 "15-17 years".

compute status = 0.
if (HL9 = 1 and HL10 <> 0 and HL11 = 1 and HL12 <> 0) status = 1.
if (HL9 = 2 and HL11 = 1 and HL12 = 0) status = 2.
if (HL9 = 1 and HL10 = 0 and HL11 = 2) status = 3.
if (HL9 = 1 and HL10 = 0 and HL11 = 1 and HL12 = 0) status = 4.
if (HL9 = 2 and HL11 = 2) status = 5.
if (HL9 = 1 and HL10 <> 0 and HL11 = 1 and HL12 = 0) status = 6.
if (HL9 = 1 and HL10 <> 0 and HL11 = 2) status = 7.
if (HL9 = 1 and HL10 = 0 and HL11 = 1 and HL12 <> 0) status = 8.
if (HL9 = 2 and HL11 = 1 and HL12 <> 0) status = 9.
if (HL9 = 8 or HL9 = 9 or HL11 = 8 or HL11 = 9) status = 10.

variable label status "".
value label status
  1 "Living with both parents"
  2 "Only father alive"
  3 "Only mother alive"
  4 "Both are alive"
  5 "Both are dead"
  6 "Father alive"
  7 "Father dead"
  8 "Mother alive"
  9 "Mother dead"
  10 "Impossible to determine".

recode status (1=1) (2 thru 5=2) (6 thru 7=3) (8 thru 9=4) (10=5) into status1.
variable label status1 "".
value label status1 
  1 " "
  2 "Living with neither parent"
  3 "Living with mother only"
  4 "Living with father only"
  5 " ".

compute noparent = 0.
if (status1 = 2) noparent = 100.
variable label noparent "Not living with a biological parent *".

compute oneboth = 0.
if (HL9 = 2 or HL11 = 2) oneboth = 100.
variable label oneboth "One or both parents dead **".

tables
  /format = zero
  /observation = noparent oneboth 
  /ftotal = tot1 "Total" tot2 "Number of children"
  /tables = HL4 + HH7+ HH6 + agegrp + wlthind5 + HC1B + tot1 by 
	  status1 > status + tot1 + noparent + oneboth + tot2
  /statistics
    cpct(status (f5.1) '': HL4 HH6 HH7 agegrp wlthind5 HC1B)
    mean(noparent (f5.1) '')
    mean(oneboth (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table HA.10: Children's living arrangments and orphanhood"
		"Percent distribution of children aged 0-17 years according to living arrangments, "+
		"percentage of children aged 0-17 years in households not living with a "+
		"biological parent and percentage of children who are orphans, Country, Year"
  /caption
    "* MICS Indicator 78"
    "** MICS Indicator 75".

new file.
