get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute notmeas = 0.
if (AN4 <> 1) notmeas = 100.
variable label notmeas "Children not measured".

compute missage = 0.
if (notmeas = 0 & (UF10M >= 96 or UF10Y >= 9996)) missage = 100.
variable label missage "Missing month or year of birth".

compute misshw = 0.
if (notmeas = 0 & (AN1 >= 99.0 or AN2 >= 999.0)) misshw = 100.
variable label misshw "Missing height or weight".

compute missflag = 0.
if (notmeas = 0 & missage = 0 & misshw = 0 & flag <> 0) missflag = 100.
variable label missflag "Other flagged cases".

compute totflag = 0.
if (notmeas = 100 or missage = 100 or misshw = 100 or flag <> 0) totflag = 100.
variable label totflag "Total cases excluded from analysis".

tables
  /format = zero
  /observation = notmeas misshw missage missflag totflag
  /ftotal = tot1 "Total" tot2 "Number of children"
  /table = HL4 + HH7 + HH6 + cage_6 + melevel + wlthind5 + HC1B + tot1 
		by notmeas + misshw + missage + missflag + totflag + tot2
  /statistics
    mean(notmeas (f5.1) '')
    mean(misshw (f5.1) '')
    mean(missage (f5.1) '')
    mean(missflag (f5.1) '')
    mean(totflag (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table NU.1w: Child malnourishment (Working table)"
		"Percentage of under-five children not measured, measured with missing height or weight, missing month or year of birth, "+
                        "or other flagged cases, and total cases excluded from analysis, Country, Year".

select if (FLAG = 0).

do if (misshw = 0).
+ recode WAZ (-2.00 thru hi = 0) (else = 100) into wa2.
+ recode WAZ (-3.00 thru hi = 0) (else = 100) into wa3.
+ recode HAZ (-2.00 thru hi = 0) (else = 100) into ha2.
+ recode HAZ (-3.00 thru hi = 0) (else = 100) into ha3.
+ recode WHZ (-2.00 thru hi = 0) (else = 100) into wh2.
+ recode WHZ (-3.00 thru hi = 0) (else = 100) into wh3.
+ recode WHZ (lo thru +2.00 = 0) (else = 100) into wh3a.
else.
+ compute wa2 = 9.
+ compute wa3 = 9.
+ compute ha2 = 9.
+ compute ha3 = 9.
+ compute wh2 = 9.
+ compute wh3 = 9.
+ compute wh3a = 9.
end if.
variable label wa2 "Weight for age: % below -2 SD".
variable label wa3 "Weight for age: % below -3 SD*".
variable label ha2 "Height for age: % below -2 SD".
variable label ha3 "Height for age: % below -3 SD**".
variable label wh2 "Weight for height: % below -2 SD".
variable label wh3 "Weight for height: % below -3 SD***".
variable label wh3a "Weight for height: % above +2 SD".

missing values wa2 wa3 ha2 ha3 wh2 wh3 wh3a (9).

tables
  /format = zero
  /observation = wa2 wa3 ha2 ha3 wh2 wh3 wh3a
  /ftotal = tot1 "Total" tot2 "Number of children"
  /table = HL4 + HH7 + HH6 + cage_6 + melevel + wlthind5 + HC1B + tot1 
		by wa2 + wa3 + ha2 + ha3 + wh2 + wh3 +wh3a+ tot2
  /statistics
    mean(wa2 (f5.1) '')
    mean(wa3 (f5.1) '')
    mean(ha2 (f5.1) '')
    mean(ha3 (f5.1) '')
    mean(wh2 (f5.1) '')
    mean(wh3 (f5.1) '')
    mean(wh3a (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table NU.1: Child malnourishment" 
		"Percentage of under-five children who are severely or moderately "+
		"undernourished, Country, Year"
  /caption
    "* MICS indicator 6; MDG indicator 4"
		"** MICS indicator 7"
		"*** MICS indicator 8".

new file.
