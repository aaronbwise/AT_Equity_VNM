get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

select if (cage >= 6).

compute vitamina = 9.
if (VA1 = 1 and (VA2 >= 0 and VA2 <= 5)) vitamina = 1.
if (VA1 = 1 and (VA2 >= 6 and VA2 <= 60)) vitamina = 2.
if (VA1 = 1 and (VA2 = 98 or VA2 = 99)) vitamina = 3.
if (VA1 = 8 or VA1 = 9) vitamina = 4.
if (VA1 = 2) vitamina = 5.
variable label vitamina "Percent of children who received Vitamin A:".
value label vitamina
  1 "Within last 6 months*"
  2 "Prior to last 6 months"
  3 "Not sure when"
  4 "Not sure if received"
  5 "Never received Vitamin A".

tables
  /format = zero
  /ftotal = tot1 "Total" tot2 "Total"
  /table = HL4 + HH7 + HH6 + cage_6 + melevel + wlthind5 + HC1B + tot1 
		by vitamina + tot2
  /statistics
    cpct(vitamina (f5.1) '': HL4 HH7 HH6 cage_6 melevel wlthind5 HC1B)
    cpct(tot2 (f5.1) 'Total': HL4 HH7 HH6 cage_6 melevel wlthind5 HC1B)
    count(tot2 (f5.0) 'Number of children aged 6-59 months')
  /title
    "Table NU.6: Children's vitamin A supplementation" 
		"Percent distribution of children aged 6-59 months by whether they "+
		"received a high dose Vitamin A supplement in the last 6 months, "+
		"Country, Year"
  /caption
    "* MICS indicator 42".

new file.
