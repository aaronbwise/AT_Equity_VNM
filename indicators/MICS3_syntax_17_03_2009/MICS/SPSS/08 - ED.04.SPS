get file = 'hl.sav'.

weight by hhweight.

* select children who are of secondary school age; this definition is
* country-specific and should be changed to reflect the situation in your
* country.

* NEXT TWO LINES SHOULD BE ADDED IF THE SURVEY WAS CONDUCTED HALF A YEAR OR LATER THAN THE BEGINNING OF THE SCHOOL YEAR. 
*compute hl5 = hl5-1.
*variable label hl5 "Age at beginning of school year".

select if (HL5 >= 11 and HL5 <= 17).

compute second  = 0.
if (ED6A >= 2 and ED6A <= 3) second =  100.
* Set test for HL5 equal to age in last grade of secondary and test for ED3B equal to the last grade of secondary.
if (HL5 = 17 and ED3A = 2 and ED3B = 6 and ED4 = 2) second  = 100.
variable label second "".

variable label HL4 "".

tables
  /format = zero
  /observation = second
  /ftotal = tot1 "Total"
  /tables = HH7 + HH6 + HL5 + melevel + wlthind5 + HC1B + tot1 by 
	  HL4 > second + tot1
  /statistics
    mean(second (f5.1) 'Net attendance ratio')
    validn(second (f5.0) 'Number of children')
  /title
    "Table ED.4: Secondary school net attendance ratio"
		"Percentage of children of secondary school age attending secondary or higher "+
		"school (NAR), Country, Year"
  /caption
    "* MICS indicator 56".
new file.
