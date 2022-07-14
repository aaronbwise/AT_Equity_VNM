get file = 'ch.sav'.

weight by chweight.

select if (cage >= 6).

recode VA1 (1 = 1) (7,9 = 4) (2 = 5) into vitamina.
variable label vitamina "Vitamin A".
value label vitamina
  1 "Received: within last 6 months"
  2 "Received: prior to last 6 months"
  3 "Received: not sure when"
  4 "Not sure if received"
  5 "Not received".

do if (VA1 = 1).
+ recode VA2 (0 thru 6 = 1) (7 thru 60 = 2) (97,99 = 3) into vitamina.
end if.

tables
  /ftotal = tot1 "Total" tot2 "Total"
  /table = HL3 + HI7 + HI6 + cage_6 + melevel + tot1 by vitamina + tot2
  /statistics
    cpct(vitamina (f5.1) '':HL3 HI7 HI6 cage_6 melevel)
    cpct(tot2 (f5.1) 'Total':HL3 HI7 HI6 cage_6 melevel)
    count(tot2 (f5.0) 'Number of children')
  /title
    "Table 18: Percent distribution of children aged 6-59 months by whether they received a high dose of Vitamin A"
    "supplement in the last 6 months, Country, Year"
  /caption
    "World Summit for Children Goal => Number 15".
