get file = 'ch.sav'.

weight by chweight.

select if (UF9 = 1 and cage < 36).

compute bf = 0.
if (BF2 = 1 & (BF3B <> 1 & BF3C <> 1 & BF3D <> 1 & BF3E <> 1 & BF3F <> 1 & BF3G <> 1 & BF3H <> 1)) bf = 1.
if (BF2 = 1 & (BF3B  = 1 & BF3C <> 1 & BF3D <> 1 & BF3E <> 1 & BF3F <> 1 & BF3G <> 1 & BF3H <> 1)) bf = 2.
if (BF2 = 1 & ((BF3C = 1 or BF3D = 1 or BF3G = 1) & BF3E <> 1 & BF3F <> 1 & BF3H <> 1)) bf = 3.
if (BF2 = 1 & ((BF3E = 1 or BF3F = 1) & BF3H <> 1)) bf = 4.
if (BF2 = 1 and BF3H = 1) bf = 5.
if (BF1 <> 1 or BF2 <> 1) bf = 6.

variable label bf "Infant feeding pattern".
value label bf 
  6 "Weaned (not breastfed)"
  5 "Breastfed and complementary foods"
  4 "Breastfed and other milk/ formula"
  3 "Breastfed and non-milk liquids"
  2 "Breastfed and plain water only"
  1 "Exclusively breastfed".

compute cage2 = trunc(cage/2).
variable label cage2 "Age".
value label cage2 
  0 "0-1"
  1 "2-3"
  2 "4-5"
  3 "6-7"
  4 "8-9"
  5 "10-11"
  6 "12-13"
  7 "14-15"
  8 "16-17"
  9 "18-19"
  10 "20-21"
  11 "22-23"
  12 "24-25"
  13 "26-27"
  14 "28-29"
  15 "30-31"
  16 "32-33"
  17 "34-35".

compute total = 1.
value label total 1 "Number of children".

tables
  /format = zero
  /ftotal = tot1 "Total"
  /table = cage2 + tot1 by bf + tot1 + total
  /statistics
    cpct(bf (f5.1) '': cage2)
  /title
    "Table NU.3w: Infant feeding patterns by  age"
    "Percent distribution of children aged under 3 years by feeding pattern by age group, Country, Year".


graph
  /line(area)=count by cage2 by bf
  /template='BFgraph.sct' .

new file.