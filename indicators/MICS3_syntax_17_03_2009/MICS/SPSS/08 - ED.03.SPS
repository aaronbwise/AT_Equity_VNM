get file = 'hl.sav'.

weight by hhweight.

* select children who are of primary school age; this definition is
* country-specific and should be changed to reflect the situation in your country.

* NEXT TWO LINES SHOULD BE ADDED IF THE SURVEY WAS CONDUCTED HALF A YEAR OR LATER THAN THE BEGINNING OF THE SCHOOL YEAR.  
*compute hl5 = hl5-1.
*variable label hl5 "Age at beginning of school year".

select if (HL5 >= 6 and HL5 <= 10).

compute primary  = 0.
if (ED6A >= 1 and ED6A <= 3) primary =  100.
* Set test for HL5 equal to age in last grade of primary and set test for ED3B equal to the last grade of primary.
if (HL5 = 10 and ED3A = 1 and ED3B = 5 and ED4 =  2) primary  = 100.
variable label primary "".

variable label HL4 "".

tables
  /format = zero
  /observation = primary
  /ftotal = tot1 "Total"
  /tables = HH7 + HH6 + HL5 + melevel + wlthind5 + HC1B + tot1 by 
	  HL4 > primary + tot1
  /statistics
    mean(primary (f5.1) 'Net attendance ratio')
    validn(primary (f5.0) 'Number of children')
  /title
    "Table ED.3: Primary school net attendance ratio"
		"Percentage of children of primary school age attending primary school or secondary school (NAR), Country, Year"
  /caption
    "* MICS indicator 55; MDG indicator 6".
new file.
