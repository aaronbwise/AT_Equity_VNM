get file = 'hl.sav'.

weight by hhweight.

* select children who are of primary school entry age; this definition is
* country-specific and should be changed to reflect the situation in your
* country.

* NEXT TWO LINES SHOULD BE ADDED IF THE SURVEY WAS CONDUCTED HALF A YEAR OR LATER THAN THE BEGINNING OF THE SCHOOL YEAR. 
*compute hl5 = hl5-1.
*variable label hl5 "Age at beginning of school year".

select if (HL5 = 6).

compute total = 1.
variable label total  "Number of children of primary school entry age".
value label total 1 "".

compute first  = 0.
* Including second grade due to age issues.
if (ED6A = 1 and (ED6B  = 1 or ED6B = 2)) first =  100.
variable label first "Percentage of children of primary school entry age "+
  "currently attending grade 1 *".

tables
  /format = zero
  /observation = first
  /ftotal = tot1 "Total"
  /tables = HL4 + HH7 + HH6 + HL5 + melevel + wlthind5 +HC1B+ tot1 
	  by first + total
  /statistics
    mean(first (f5.1) '')
  /title
    "Table ED.2: Primary school entry"
		"Percentage of children of primary school entry age attending grade 1, "+
		"Country, Year"
  /caption
    "* MICS Indicator 54".
new file.
