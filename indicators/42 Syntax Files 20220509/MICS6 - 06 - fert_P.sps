* Encoding: UTF-8.
* Direct estimation of fertility.  

* Calculates exposure of all .
compute colper = 0.

weight by hhweight .

recode HL6
  (15 thru 19 = 1)
  (20 thru 24 = 2)
  (25 thru 29 = 3)
  (30 thru 34 = 4)
  (35 thru 39 = 5)
  (40 thru 44 = 6)
  (45 thru 49 = 7) into age5.

variable labels age5 "Women's age".
value labels age5
  1 '15-19'
  2 '20-24'
  3 '25-29'
  4 '30-34'
  5 '35-39'
  6 '40-44'
  7 '45-49'
  .
aggregate outfile = *
  /break = colper hl4 age5
  /nwm = n(hh1).
    
compute total = 1.

aggregate
  /outfile=* mode=addvariable
  /break=total
  /pop=sum(nwm).

select if (HL4 = 2 and not sysmis(age5)) .
save outfile = 'exposureTotal.sav'
  /keep= colper age5 nwm pop .

new file.

