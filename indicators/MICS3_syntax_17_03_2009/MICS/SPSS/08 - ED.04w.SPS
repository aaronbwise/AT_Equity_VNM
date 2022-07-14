get file = 'hl.sav'.

weight by hhweight.

* select children who are of secondary school age; this definition is
* country-specific and should be changed to reflect the situation in your
* country.

* NEXT TWO LINES SHOULD BE ADDED IF THE SURVEY WAS CONDUCTED HALF A YEAR OR LATER THAN THE BEGINNING OF THE SCHOOL YEAR. 
*compute hl5 = hl5-1.
*variable label hl5 "Age at beginning of school year".

select if (HL5 >= 11 and HL5 <= 17).

compute prim  = 0.
if (ED6A = 1) prim =  100.
variable label prim "".

variable label HL4 "".

tables
  /format = zero
  /observation = prim
  /ftotal = tot1 "Total"
  /tables = HH7 + HH6 + HL5 + melevel + wlthind5 + HC1B + tot1 by 
	  HL4 > prim + tot1
  /statistics
    mean(prim (f5.1) 'Percent attending primary school')
    validn(prim (f5.0) 'Number of children')
  /title
    "Table ED.4w: Secondary school age children attending primary school"
    "Percentage of children of secondary school age attending primary school, Country, Year".
new file.
