get file = 'hl.sav'.

compute kid18 = 0.
if (HL5 < 18) kid18 = 1.

aggregate outfile = 'tmp.sav'
  /break =  HH1 HH2
  /totkid18 = sum(kid18).

* open the aggregate file.
get file = 'tmp.sav'.

* sort the cases by cluster number and household number.
sort cases by HH1 HH2.

* save the sorted cases in a working file.
save outfile = 'tmp.sav'.

* open the household data file.
get file = 'hh.sav'.

* select completed households.
select if (HH9  = 1).

* sort the cases by cluster number and household number.
sort cases by HH1 HH2.

* merge the aggregate data onto the household data file.
match files
  /file = *
  /table = 'tmp.sav'
  /by  HH1 HH2.

weight by hhweight.

recode HH11 (1 = 1) (2,3 = 2) (4,5 = 3) (6,7 = 4) (8,9 = 5) (10 thru hi = 6) 
	into hhmember.
variable label hhmember "Number of household members".
value label hhmember
  1 "1"
  2 "2-3"
  3 "4-5"
  4 "6-7"
  5 "8-9"
  6 "10+".

recode totkid18 (0 = 0) (1 thru hi = 100) into kid18.
variable label kid18 "At least one child aged < 18 years".

recode HH14 (0 = 0) (1 thru hi = 100) into kid5.
variable label kid5 "At least one child aged < 5 years".

recode HH12 (0 = 0) (1 thru hi = 100) into woman.
variable label woman "At least one woman aged 15-49 years".

tables
  /format = zero
  /ftotal = tot1 "Total"
  /table = hhsex + HH7 + HH6 + hhmember + HC1B + tot1	by (statistics)
  /statistics =
    cpct(hhsex (f5.1) 'Weighted percent')
    count(hhsex (f5.0) 'Number of households weighted')
    unw count(hhsex (f5.0) 'Number of households unweighted')
    cpct(HH7 (f5.1) 'Weighted percent')
    count(HH7 (f5.0) 'Number of households weighted')
    unw count(HH7 (f5.0) 'Number of households unweighted')
    cpct(HH6 (f5.1) 'Weighted percent')
    count(HH6 (f5.0) 'Number of households weighted')
    unw count(HH6 (f5.0) 'Number of households unweighted')
    cpct(hhmember (f5.1) 'Weighted percent')
    count(hhmember (f5.0) 'Number of households weighted')
    unw count(hhmember (f5.0) 'Number of households unweighted')
    cpct(HC1B (f5.1) 'Weighted percent')
    count(HC1B (f5.0) 'Number of households weighted')
    unw count(HC1B (f5.0) 'Number of households unweighted')
  /title =
    "Table HH.3: Household composition" 
		"Percent distribution of households by selected characteristics, "+
		"Country, Year".

tables
  /format = zero
  /observation = kid18 kid5 woman
  /table = kid18 + kid5 + woman by (statistics)
  /statistics =
    mean(kid18 (f5.1) 'Weighted percent')
    validn(kid18 (f5.0) 'Number of households weighted')
    unw validn(kid18 (f5.0) 'Number of households unweighted')
    mean(kid5 (f5.1) 'Weighted percent')
    validn(kid5 (f5.0) 'Number of households weighted')
    unw validn(kid5 (f5.0) 'Number of households unweighted')
    mean(woman (f5.1) 'Weighted percent')
    validn(woman (f5.0) 'Number of households weighted')
    unw validn(woman (f5.0) 'Number of households unweighted')
  /title =
    "Table HH.3: Household composition" 
		"Percent distribution of households by selected characteristics, "+
		"Country, Year".

new file.

erase file = 'tmp.sav'.
