*define a MACRO that merges 2 files.
define !merge (file = !tokens(1)
              /mvars = !tokens(2)).
get file = 'tmp.sav'.
sort cases by !mvars.
save outfile = 'tmp.sav'.
get file = !file.
sort cases by !mvars.
match files
  /file = *
  /table = 'tmp.sav'
  /by !mvars.
!enddefine.

get file = 'hl.sav'.

compute woman = 0.
if (HL3 = 2 and HL4 >= 15 and HL4 <= 49) woman = 1.

compute kid5 = 0.
if (HL4 < 5) kid5 = 1.

compute kid15 = 0.
if (HL4 < 15) kid15 = 1.

aggregate outfile = 'tmp.sav'
  /break = HI1 HI2
  /totwoman = sum(woman)
  /totkid5 = sum(kid5)
  /totkid15 = sum(kid15).

!merge file=hh.sav mvars=HI1 HI2.

weight by hhweight.

recode himem (1 = 1) (2,3 = 2) (4,5 = 3) (6,7 = 4) (8,9 = 5) (10 thru 50 = 6) into hhmember.
variable label hhmember "Number of HH members".
value label hhmember
  1 "1"
  2 "2-3"
  3 "4-5"
  4 "6-7"
  5 "8-9"
  6 "10+".

recode totkid15 (0 = 0) (1 thru 50 = 100) into kid15.
variable label kid15 "At least one child age < 15".

recode totkid5 (0 = 0) (1 thru 50 = 100) into kid5.
variable label kid5 "At least one child age < 5".

recode totwoman (0 = 0) (1 thru 50 = 100) into woman.
variable label woman "At least one woman age 15-49".

tables
  /ftotal = tot1 "Total"
  /table = HI7 + HI6 + hhmember + tot1 by (statistics)
  /statistics =
    cpct(HI7 (f5.1) 'Percent')
    count(HI7 (f5.0) 'Number')
    unw count(HI7 (f5.0) 'Unweighted')
    cpct(HI6 (f5.1) 'Percent')
    count(HI6 (f5.0) 'Number')
    unw count(HI6 (f5.0) 'Unweighted')
    cpct(hhmember (f5.1) 'Percent')
    count(hhmember (f5.0) 'Number')
    unw count(hhmember (f5.0) 'Unweighted')
  /title =
    "Table 4: Percent distribution of households by background characteristics, Country, Year".

tables
  /observation = kid15 kid5 woman
  /table = kid15 + kid5 + woman by (statistics)
  /statistics =
    mean(kid15 (f5.1) 'Percent')
    validn(kid15 (f5.0) 'Number')
    unw validn(kid15 (f5.0) 'Unweighted')
    mean(kid5 (f5.1) 'Percent')
    validn(kid5 (f5.0) 'Number')
    unw validn(kid5 (f5.0) 'Unweighted')
    mean(woman (f5.1) 'Percent')
    validn(woman (f5.0) 'Number')
    unw validn(woman (f5.0) 'Unweighted')
  /title =
    "Table 4: Percent distribution of households by background characteristics, Country, Year".

erase file = 'tmp.sav'.
