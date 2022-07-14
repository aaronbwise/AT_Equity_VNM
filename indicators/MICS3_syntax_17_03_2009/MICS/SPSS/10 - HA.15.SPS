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

select if (HL5 >= 15 and HL5 <= 17).

sort cases by HH1 HH2 HL1.

save outfile ="tmp.sav" 
  /keep HH1 HH2 HL1 vulne oneboth orphans norpvul
  /rename (HL1=LN).

get file = 'wm.sav'.

select if (WM9 >= 15 and WM9 <= 17).

sort cases by HH1 HH2 LN.

match files
  /file = *
  /table='tmp.sav'
  /by HH1 HH2 LN.

weight by wmweight.

compute sex15 = 0.
if (SB1 <> 0 and SB1 < 15) sex15 = 100.
if (SB1 = 95 and agem >= 4 and agem < 15) sex15 = 100.
variable label sex15 "Percentage of young women aged 15-17 years who had sex before age 15".

compute total = 1.
variable label total "Number of young women aged 15-17 years".
value label total 1 "".

compute ratio = 1.
variable label ratio "Ratio OVC to non-OVC".

compute total = 1.

aggregate outfile = 'tmp1.sav'
  /break vulne
  /tsex15 = mean(sex15)
  /totl = sum(vulne).

aggregate outfile = 'tmp2.sav'
  /break oneboth
  /tsex15 = mean(sex15)
  /totl = sum(oneboth).

aggregate outfile = 'tmp3.sav'
  /break orphans
  /tsex15 = mean(sex15)
  /totl = sum(orphans).

aggregate outfile = 'tmp4.sav'
  /break norpvul
  /tsex15 = mean(sex15)
  /totl = sum(norpvul).

aggregate outfile = 'tmp5.sav'
  /break ratio
  /tsex15 = mean(sex15)
  /totl = sum(ratio).

aggregate outfile = 'tmp6.sav'
  /break total
  /tsex15 = mean(sex15)
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

variable label tsex15 "Percentage of young women aged 15-17 years who had sex before age 15".
variable label totl "Number of young women aged 15-17 years".

* initialize ratio row just to be safe.
if (ratio = 1) tsex15 = 0.

* calculate ratio of orphan or vulnerable to non-orphaned, non-vulnerable.
if (lag(orphans,2) = 1 and lag(norpvul) = 1) tsex15 = lag(tsex15,2)/lag(tsex15).

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

tables
  /format = zero
  /observation = tsex15 totl
  /tables =  oneboth + vulne + orphans + norpvul + total + ratio by 
	  tsex15 + totl
  /statistics
    mean(tsex15 (f5.2) '')
    mean(totl (f5.0) '')
  /title
    "Table HA.15: Sexual behaviour among young women by orphanhood and vulnerability status due to AIDS"
		"Percentage of young women aged 15-17 years who had sex before age 15 by "+
		"vulnerability status and survival status of parents, Country, Year"
  /caption
    "* MICS Indicator 80".

new file.

*delete working files.
erase file = 'tmp.sav'.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.
