get file = 'hh.sav'.

select  if (HH9 = 1 and HC6 >= 06 and HC6 <= 11).

weight by hhweight.

compute total = 1.
variable label total "Number of households using solid fuels for cooking".
value label total 1 "".

compute stove = 9.
if (HC7 = 3) stove = 1.
if ((HC7 = 1 or HC7 = 2) and HC7a = 1) stove = 2.
if ((HC7 = 1 or HC7 = 2) and HC7a <> 1) stove = 3.
if (HC7 = 6) stove = 6.
variable label stove "Percentage of households using solid fuels for cooking:".
value label stove
	1 "Closed stove with chimney"
	2 "Open stove or fire with chimney or hood"
	3 "Open stove or fire with no chimney or hood"
	6 "Other stove"
	9 "DK stove type/missing".

tables
  /format = zero
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + helevel + wlthind5 + HC1B + tot1 by 
	  stove + tot1 + total
  /statistics
    cpct(stove (f5.1) '': HH7 HH6 helevel wlthind5 HC1B)
    count(total (f5.0) '')
  /title
    "Table CH.9: Solid fuel use by type of stove or fire"
		"Percent of households using solid fuels for cooking by type of stove or "+
		"fire, Country, Year".

new file.
