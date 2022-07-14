get file = 'hl.sav'.

compute ill = 0.
if (HL10A = 1 or HL12A = 1) ill = 100.
variable label ill "Chronically ill".

compute death = 0.
if (OV4 = 1) death = 100.
variable label death "Adult death in household".

compute chroill = 0.
if (TOHL8A >= 1) chroill = 100.
variable label chroill "Chronically ill adult in household".

if (ill = 100 or death = 100 or chroill = 100) vulne = 1.
variable label vulne "Vulnerable".

if (HL9 = 2 or HL11 = 2) oneboth = 1.
variable label oneboth "Orphaned".

if (vulne = 1 or oneboth = 1) orphans = 1.
variable label orphans "Orphaned or vulnerable".

if (sysmis(orphans)) norpvul = 1.
variable label norpvul "Not orphaned or vulnerable".

select if (HL5 >= 0 and HL5 <= 4).

sort cases by HH1 HH2 HL1.

save outfile ="tmp.sav" 
  /keep HH1 HH2 HL1 vulne oneboth orphans norpvul
  /rename (HL1=LN).

get file = 'ch.sav'.

sort cases by HH1 HH2 LN.

match files
  /file = *
  /table='tmp.sav'
  /by HH1 HH2 LN.

weight by chweight.

compute misshw = 0.
if (an1 >= 99.0 or an2 >= 999.0) misshw = 100.
variable label misshw "Missing height or weight".

select if (FLAG = 0).

do if (misshw =0).
+ recode WAZ (-2.00 thru hi = 0) (else = 100) into wa2.
+ recode HAZ (-2.00 thru hi= 0) (else = 100) into ha2.
+ recode WHZ (-2.00 thru hi= 0) (else = 100) into wh2.
else.
+ compute wa2 = 9.
+ compute ha2 = 9.
+ compute wh2 = 9.
end if.
variable label wa2 "Weight for age: -2 SD".
variable label ha2 "Height for age: -2 SD".
variable label wh2 "Weight for height: -2 SD".

missing values wa2 ha2 wh2 (9).

compute ratio = 1.
variable label ratio "Ratio OVC to non-OVC *".

compute total = 1.

aggregate outfile = 'tmp1.sav'
  /break vulne
  /awa2 = mean(wa2)
  /aha2 = mean(ha2)
  /awh2 = mean(wh2)
  /totl = sum(vulne).

aggregate outfile = 'tmp2.sav'
  /break oneboth
  /awa2 = mean(wa2)
  /aha2 = mean(ha2)
  /awh2 = mean(wh2)
  /totl = sum(oneboth).

aggregate outfile = 'tmp3.sav'
  /break orphans
  /awa2 = mean(wa2)
  /aha2 = mean(ha2)
  /awh2 = mean(wh2)
  /totl = sum(orphans).

aggregate outfile = 'tmp4.sav'
  /break norpvul
  /awa2 = mean(wa2)
  /aha2 = mean(ha2)
  /awh2 = mean(wh2)
  /totl = sum(norpvul).

aggregate outfile = 'tmp5.sav'
  /break ratio
  /awa2 = mean(wa2)
  /aha2 = mean(ha2)
  /awh2 = mean(wh2)
  /totl = sum(ratio).

aggregate outfile = 'tmp6.sav'
  /break total
  /awa2 = mean(wa2)
  /aha2 = mean(ha2)
  /awh2 = mean(wh2)
  /totl = sum(total).

get file = 'tmp1.sav'.

add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'.

select if (not(sysmis(totl))).

do if (ratio = 1).
+ recode totl (else = sysmis).
end if.

variable label awa2 "Underweight".
variable label aha2 "Stunted".
variable label awh2 "Wasted".
variable label totl "Number of children aged 0-4 years".

* initialize ratio row just to be safe.
if (ratio = 1) awa2 = 0.
if (ratio = 1) aha2 = 0.
if (ratio = 1) awh2 = 0.

* calculate ratio of orphan or vulnerable to non-orphaned, non-vulnerable.
if (lag(orphans,2) = 1 and lag(norpvul) = 1) awa2 = lag(awa2,2)/lag(awa2).
if (lag(orphans,2) = 1 and lag(norpvul) = 1) aha2 = lag(aha2,2)/lag(aha2).
if (lag(orphans,2) = 1 and lag(norpvul) = 1) awh2 = lag(awh2,2)/lag(awh2).

variable label vulne "Vulnerable".
value label vulne 1 "".

variable label oneboth "Orphaned".
value label oneboth 1 "".

variable label orphans "Orphaned or vulnerable".
value label orphans 1 "".

variable label norpvul "Not orphaned or vulnerable".
value label norpvul 1 "".

variable label ratio "Ratio OVC to non-OVC*".
value label ratio 1 "".

variable label total "Total".
value label total 1 "".

compute layer = 0.
variable label layer "".
value label layer 0 "Percentage of children aged 0-4 years who are moderately or severely:".

tables
  /format = zero
  /observation = awa2 aha2 awh2 totl
  /tables = oneboth + vulne + orphans + norpvul + total + ratio by 
	  layer > (awa2 + aha2 + awh2) + totl
  /statistics
    mean(awa2 (f5.2) '')
    mean(aha2 (f5.2) '')
    mean(awh2 (f5.2) '')
    mean(totl (f5.0) '')
  /title
    "Table HA.14: Malnutrition among orphans and vulnerable children"
		"Percent of children aged 0-4 years who are moderately or severely "+
		"underweight, stunted or wasted by orphanhood and vulnerability due to AIDS, "+
		"Country, Year"
  /caption
    "* MICS Indicator 79".

new file.

*delete working files.
erase file = 'tmp.sav'.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.
