get file 'hl.sav'.

weight by hhweight.

if (ED22A = 2 and ED22B = 1 and ED17 <> 1) second = 0.
if (ED22A = 2 and ED22B = 1 and ED20A = 2 and ED20B = 2 and ED17 = 1) second = 100.
variable label second "Percent in 1st grade last year who are in 2nd grade this year"

if (ED22A = 2 and ED22B = 2 and ED17 <> 1) third = 0.
if (ED22A = 2 and ED22B = 2 and ED20A = 2 and ED20B = 3 and ED17 = 1) third = 100.
variable label third "Percent in 2nd grade last year who are in 3nr grade this year"

if (ED22A = 2 and ED22B = 3 and ED17 <> 1) fourth = 0.
if (ED22A = 2 and ED22B = 3 and ED20A = 2 and ED20B = 4 and ED17 = 1) fourth = 100.
variable label fourth "Percent in 3rd grade last year who are in 4th grade this year"

if (ED22A = 2 and ED22B = 4 and ED17 <> 1) fifth = 0.
if (ED22A = 2 and ED22B = 4 and ED20A = 2 and ED20B = 5 and ED17 = 1) fifth = 100.
variable label fifth "Percent in 4th grade last year who are in 5th grade this year"

tables
  /ftotal = tot1 "Total"
  /observation = second third fourth fifth
  /table = HL3 + HI7 + HI6 + tot1 by second + third + fourth + fifth
  /statistics
    mean(second (f5.1) '')
    mean(third (f5.1) '')
    mean(fourth (f5.1) '')
    mean(fifth (f5.1) '')
  /title
    "Table 10: Percentage of children entering first grade of primary school who eventually reach grade 5, Country, Year"
  /caption
    "World Summit for Children Goal => Number 6".
