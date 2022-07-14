get file = 'ch.sav'.

select if (FLAG = 1).

weight by chweight.

compute misshw = 0.
if (height = 997 or height = 999.9 or weight = 97 or weight = 99.9) misshw = 100.
variable label misshw "Missing height or weight".

do if (misshw = 0).
+ recode WAZ (lo thru -2.00 = 100) (else = 0) into wa2.
+ recode WAZ (lo thru -3.00 = 100) (else = 0) into wa3.
+ recode HAZ (lo thru -2.00 = 100) (else = 0) into ha2.
+ recode HAZ (lo thru -3.00 = 100) (else = 0) into ha3.
+ recode WHZ (lo thru -2.00 = 100) (else = 0) into wh2.
+ recode WHZ (lo thru -3.00 = 100) (else = 0) into wh3.
else.
+ compute wa2 = 9.
+ compute wa3 = 9.
+ compute ha2 = 9.
+ compute ha3 = 9.
+ compute wh2 = 9.
+ compute wh3 = 9.
end if.
variable label wa2 "Weight for age: -2 SD".
variable label wa3 "Weight for age: -3 SD".
variable label ha2 "Height for age: -2 SD".
variable label ha3 "Height for age: -3 SD".
variable label wh2 "Weight for height: -2 SD".
variable label wh3 "Weight for height: -3 SD".

missing values wa2 wa3 ha2 ha3 wh2 wh3 (9).

tables
  /observation = wa2 wa3 ha2 ha3 wh2 wh3 misshw
  /ftotal = tot1 "Total" tot2 "Number of children"
  /tables = HL3 + HI7 + HI6 + cage_6 + melevel + tot1 by wa2 + wa3 + ha2 + ha3 + wh2 + wh3 + misshw + tot2
  /statistics
    mean(wa2 (f5.1) '')
    mean(wa3 (f5.1) '')
    mean(ha2 (f5.1) '')
    mean(ha3 (f5.1) '')
    mean(wh2 (f5.1) '')
    mean(wh3 (f5.1) '')
    mean(misshw (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table 15: Percentage of under-five children who are severly or moderately undernourished, Country, Year"
  /caption
    "World Summit for Children Goal => Number 3, 9, 26".
