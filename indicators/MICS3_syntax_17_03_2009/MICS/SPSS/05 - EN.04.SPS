get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

compute total  = 1.
variable label total "Number of households".
value label total 1 "".

select if (not(sysmis(WS4))).

variable label WS4 "Person collecting drinking water".

tables
  /format = zero
  /ftotal = tot1 "Total" 
  /table = HH7 + HH6 + helevel + wlthind5 + HC1B + tot1 by WS4 + tot1 + total 
  /statistics
    cpct(WS4 (f5.1) '':HH7 HH6 helevel wlthind5 HC1B)
  /title
    "Table EN.4: Person collecting water"
		"Percent distribution of households according to the person collecting "+
		"water used in the household, Country, Year".

new file.
