get file = 'ch.sav'.

include file = "04 - chrecvac.sps".

select if (UF9 = 1).

weight by chweight.

select if (cage >= 12 and cage <= 23).

compute total = 1.
value label total 1 "Number of children".

* create a file with percent of children vaccinated according to a card.
compute vacc = 1 .
aggregate
  /outfile = 'aggr1.sav'
  /break = vacc
  /bcg = pin(bcg 1 1)
  /dpt1 = pin(dpt1 1 1)
  /dpt2 = pin(dpt2 1 1)
  /dpt3 = pin(dpt3 1 1)
  /polio0 = pin(polio0 1 1)
  /polio1 = pin(polio1 1 1)
  /polio2 = pin(polio2 1 1)
  /polio3 = pin(polio3 1 1)
  /measles = pin(measles 1 1)
  /allvacc = pin(allvacc 1 1)
  /novacc = pin(novacc 1 1)
  /total = N
.

* create a file with percent of children vaccinated according mother's report.
compute vacc = 2 .
aggregate
  /outfile = 'aggr2.sav'
  /break = vacc
  /bcg = pin(bcg 2 2)
  /dpt1 = pin(dpt1 2 2)
  /dpt2 = pin(dpt2 2 2)
  /dpt3 = pin(dpt3 2 2)
  /polio0 = pin(polio0 2 2)
  /polio1 = pin(polio1 2 2)
  /polio2 = pin(polio2 2 2)
  /polio3 = pin(polio3 2 2)
  /measles = pin(measles 2 2)
  /allvacc = pin(allvacc 2 2)
  /novacc = pin(novacc 2 2)
  /total = N
.

* create a file with percent of children vaccinated according to any source.
compute vacc = 3 .
aggregate
  /outfile = 'aggr3.sav'
  /break = vacc
  /bcg = pin(bcg 1 2)
  /dpt1 = pin(dpt1 1 2)
  /dpt2 = pin(dpt2 1 2)
  /dpt3 = pin(dpt3 1 2)
  /polio0 = pin(polio0 1 2)
  /polio1 = pin(polio1 1 2)
  /polio2 = pin(polio2 1 2)
  /polio3 = pin(polio3 1 2)
  /measles = pin(measles 1 2)
  /allvacc = pin(allvacc 1 2)
  /novacc = pin(novacc 1 2)
  /total = N
.

* select children with a vaccination card.
select if IM1 = 1.

* calculate whether child who received BCG according to a vaccination card
* received it before her 1st birthday.
do if (bcg = 1 and IM2M < 96 and IM2Y < 9996).
+ compute b_12 = 0.
+ compute dov = (IM2Y - 1900)*12 + IM2M.
+ if (dov - cdob < 13) b_12 = 100.
else if (bcg = 1 and IM2Y < 9996).
+ if (IM2Y = UF10Y) b_12 = 100.
+ if (IM2Y >= UF10Y + 2) b_12 = 0.
end if.
variable label b_12 "BCG".

* calculate whether child who received Polio 0 according to a vaccination card
* received it before her 1st birthday.
do if (polio0 = 1 and IM3AM < 96 and IM3AY < 9996).
+ compute p0_12 = 0.
+ compute dov = (IM3AY - 1900)*12 + IM3AM.
+ if (dov - cdob < 13) p0_12 = 100.
else if (polio0 = 1 and IM3AY < 9996).
+ if (IM3AY = UF10Y) p0_12 = 100.
+ if (IM3AY >= UF10Y + 2) p0_12 = 0.
end if.
variable label p0_12 "Polio 0".

* calculate whether child who received Polio 1 according to a vaccination card
* received it before her 1st birthday.
do if (polio1 = 1 and IM3BM < 96 and IM3BY < 9996).
+ compute p1_12 = 0.
+ compute dov = (IM3BY - 1900)*12 + IM3BM.
+ if (dov - cdob < 13) p1_12 = 100.
else if (polio1 = 1 and IM3BY < 9996).
+ if (IM3BY = UF10Y) p1_12 = 100.
+ if (IM3BY >= UF10Y + 2) p1_12 = 0.
end if.
variable label p1_12 "Polio 1".

* calculate whether child who received Polio 2 according to a vaccination card
* received it before her 1st birthday.
do if (polio2 = 1 and IM3CM < 96 and IM3CY < 9996).
+ compute p2_12 = 0.
+ compute dov = (IM3CY - 1900)*12 + IM3CM.
+ if (dov - cdob < 13) p2_12 = 100.
else if (polio2 = 1 and IM3CY < 9996).
+ if (IM3CY = UF10Y) p2_12 = 100.
+ if (IM3CY >= UF10Y + 2) p2_12 = 0.
end if.
variable label p2_12 "Polio 2".

* calculate whether child who received Polio 3 according to a vaccination card
* received it before her 1st birthday.
do if (polio3 = 1 and IM3DM < 96 and IM3DY < 9996).
+ compute p3_12 = 0.
+ compute dov = (IM3DY - 1900)*12 + IM3DM.
+ if (dov - cdob < 13) p3_12 = 100.
else if (polio3 = 1 and IM3DY < 9996).
+ if (IM3DY = UF10Y) p3_12 = 100.
+ if (IM3DY >= UF10Y + 2) p3_12 = 0.
end if.
variable label p3_12 "Polio 3".

* calculate whether child who received DPT1 according to a vaccination card
* received it before her 1st birthday.
do if (dpt1 = 1 and IM4AM < 96 and IM4AY < 9996).
+ compute d1_12 = 0.
+ compute dov = (IM4AY - 1900)*12 + IM4AM.
+ if (dov - cdob < 13) d1_12 = 100.
else if (dpt1 = 1 and IM4AY < 9996).
+ if (IM4AY = UF10Y) d1_12 = 100.
+ if (IM4AY >= UF10Y + 2) d1_12 = 0.
end if.
variable label d1_12 "DPT 1".

* calculate whether child who received DPT2 according to a vaccination card
* received it before her 1st birthday.
do if (dpt2 = 1 and IM4BM < 96 and IM4BY < 9996).
+ compute d2_12 = 0.
+ compute dov = (IM4BY - 1900)*12 + IM4BM.
+ if (dov - cdob < 13) d2_12 = 100.
else if (dpt2 = 1 and IM4BY < 9996).
+ if (IM4BY = UF10Y) d2_12 = 100.
+ if (IM4BY >= UF10Y + 2) d2_12 = 0.
end if.
variable label d2_12 "DPT 2".

* calculate whether child who received DPT3 according to a vaccination card
* received it before her 1st birthday.
do if (dpt3 = 1 and IM4CM < 96 and IM4CY < 9996).
+ compute d3_12 = 0.
+ compute dov = (IM4CY - 1900)*12 + IM4CM.
+ if (dov - cdob < 13) d3_12 = 100.
else if (dpt3 = 1 and IM4CY < 9996).
+ if (IM4CY = UF10Y) d3_12 = 100.
+ if (IM4CY >= UF10Y + 2) d3_12 = 0.
end if.
variable label d3_12 "DPT 3".

* calculate whether child who received measles according to a vaccination card
* received it before her 1st birthday.
do if (measles = 1 and IM6M < 96 and IM6Y < 9996).
+ compute m_12 = 0.
+ compute dov = (IM6Y - 1900)*12 + IM6M.
+ if (dov - cdob < 13) m_12 = 100.
else if (measles = 1 and IM6Y < 9996).
+ if (IM6Y = UF10Y) m_12 = 100.
+ if (IM6Y >= UF10Y + 2) m_12 = 0.
end if.
variable label m_12 "Measles".

if (b_12 = 0 or m_12 = 0 or d1_12 = 0 or d2_12 = 0 or d3_12 = 0 or p1_12 = 0 
  or p2_12 = 0 or p3_12 = 0) all_12 = 0.
if (b_12 = 100 & m_12 = 100 & d1_12 = 100 & d2_12 = 100 & d3_12 = 100 & 
  p1_12 = 100 & p2_12 = 100 & p3_12 = 100) all_12 = 100.
variable label all_12 "All vaccinations".

if (b_12 = 100 or m_12 = 100 or d1_12 = 100 or d2_12 = 100 or d3_12 = 100 or 
  p1_12 = 100 or p2_12 = 100 or p3_12 = 100) none_12 = 0.
if (b_12 = 0 & m_12 = 0 & d1_12 = 0 & d2_12 = 0 & d3_12 = 0 & p1_12 = 0 & 
  p2_12 = 0 & p3_12 = 0) none_12 = 100.
variable label none_12 "No vaccinations".

* create a data file containing percentage of vaccinations received in first
* year.
compute vacc = 4 .
aggregate
  /outfile = 'aggr4.sav'
  /break = vacc
  /bcg = pin(b_12 100 100)
  /dpt1 = pin(d1_12 100 100)
  /dpt2 = pin(d2_12 100 100)
  /dpt3 = pin(d3_12 100 100)
  /polio0 = pin(p0_12 100 100)
  /polio1 = pin(p1_12 100 100)
  /polio2 = pin(p2_12 100 100)
  /polio3 = pin(p3_12 100 100)
  /measles = pin(m_12 100 100)
  /allvacc = pin(all_12 100 100)
  /novacc = pin(none_12 100 100)
  /total = N
.

new file.

get file = 'aggr1.sav'.
add files
  /file = *
  /file = 'aggr2.sav'
  /file = 'aggr3.sav'
  /file = 'aggr4.sav'. 

* if sysmis(bcg) bcg = 0.
* if sysmis(dpt1) dpt1 = 0.
* if sysmis(dpt2) dpt2 = 0.
* if sysmis(dpt3) dpt3 = 0.
* if sysmis(polio0) polio0 = 0.
* if sysmis(polio1) polio1 = 0.
* if sysmis(polio2) polio2 = 0.
* if sysmis(polio3) polio3 = 0.
* if sysmis(measles) measles = 0.
* if sysmis(allvacc) allvacc = 0.
* if sysmis(novacc) novacc = 0.

* multiply percentage who received a vaccination by the (estimated) percentage
* who received it in the first year.
do if (vacc = 4).
+ compute bcg = bcg*lag(bcg)/100.
+ compute dpt1 = dpt1*lag(dpt1)/100.
+ compute dpt2 = dpt2*lag(dpt2)/100.
+ compute dpt3 = dpt3*lag(dpt3)/100.
+ compute polio0 = polio0*lag(polio0)/100.
+ compute polio1 = polio1*lag(polio1)/100.
+ compute polio2 = polio2*lag(polio2)/100.
+ compute polio3 = polio3*lag(polio3)/100.
+ compute measles = measles*lag(measles)/100.
+ compute allvacc = allvacc*lag(allvacc)/100.
+ compute novacc = 100-(100-novacc)*(100-lag(novacc))/100.
+ compute total = lag(total).
end if.

variable label
  bcg     "BCG *"
 /dpt1    "DPT 1"
 /dpt2    "DPT 2"
 /dpt3    "DPT 3 **"
 /polio0  "Polio 0"
 /polio1  "Polio 1"
 /polio2  "Polio 2"
 /polio3  "Polio 3 ****"
 /measles "Measles ****"
 /allvacc "All *****"
 /novacc  "None"
 /total   "Number of children aged 12-23 months".

value label vacc
  1 "Vaccination card"
  2 "Mother's report"
  3 "Either"
  4 "Vaccinated by 12 months of age".

tables
  /format = zero
  /observations bcg dpt1 dpt2 dpt3 polio0 polio1 polio2 polio3 measles allvacc 
		novacc total
  /table vacc by bcg + dpt1 + dpt2 + dpt3 + polio0 + polio1 + polio2 + polio3 +
		measles + allvacc + novacc + total
  /statistics
    mean(bcg (f5.1) '')
    mean(dpt1 (f5.1) '')
    mean(dpt2 (f5.1) '')
    mean(dpt3 (f5.1) '')
    mean(polio0 (f5.1) '')
    mean(polio1 (f5.1) '')
    mean(polio2 (f5.1) '')
    mean(polio3 (f5.1) '')
    mean(measles (f5.1) '')
    mean(allvacc (f5.1) '')
    mean(novacc (f5.1) '')
    mean(total (f5.0) '')
  /title
    "Table CH.1: Vaccinations in first year of life"
		"Percentage of children aged 12-23 months immunized against childhood "+
		"diseases at any time before the survey and before the first birthday, "+
		"Country, Year"
  /caption                                                      
    "* MICS Indicator 25"
		"** MICS Indicator 26"
		"*** MICS Indicator 27"
		"**** MICS Indicator 28 ; MDG Indicator 15"
		"***** MICS Indicator 31".

new File.
erase file = 'aggr1.sav'.
erase file = 'aggr2.sav'.
erase file = 'aggr3.sav'.
erase file = 'aggr4.sav'.
