*** This program ASSUMES that your questionnaire contains questions about the 
*** HIB vaccination. If you don't have questions about the HIB vaccination,
*** remove the variables HIB1, HIB2 and HIB3 from this program.
*** For countries that do have questions about HIB, this program assumes that
*** they are named as follows:
***   IM7AD, IM7AM, IM7AY --- HIB1 in vaccination table
***   IM7BD, IM7BM, IM7BY --- HIB2 in vaccination table
***   IM7CD, IM7CM, IM7CY --- HIB3 in vaccination table
***   IM17A               --- Ever been given HIB vaccination
***   IM17B               --- Number of HIB vaccinations received
*** If your variable names are different, change the program accordingly.

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
  /hepb1 = pin(hepb1 1 1)
  /hepb2 = pin(hepb2 1 1)
  /hepb3 = pin(hepb3 1 1)
  /hib1  = pin(hib1 1 1)
  /hib2  = pin(hib2 1 1)
  /hib3  = pin(hib3 1 1)
  /yf    = pin(yf 1 1)
  /total = N
.

* create a file with percent of children vaccinated according mother's report.
compute vacc = 2 .
aggregate
  /outfile = 'aggr2.sav'
  /break = vacc
  /hepb1 = pin(hepb1 2 2)
  /hepb2 = pin(hepb2 2 2)
  /hepb3 = pin(hepb3 2 2)
  /hib1  = pin(hib1 2 2)
  /hib2  = pin(hib2 2 2)
  /hib3  = pin(hib3 2 2)
  /yf    = pin(yf 2 2)
  /total = N
.

* create a file with percent of children vaccinated according to any source.
compute vacc = 3 .
aggregate
  /outfile = 'aggr3.sav'
  /break = vacc
  /hepb1 = pin(hepb1 1 2)
  /hepb2 = pin(hepb2 1 2)
  /hepb3 = pin(hepb3 1 2)
  /hib1  = pin(hib1 1 2)
  /hib2  = pin(hib2 1 2)
  /hib3  = pin(hib3 1 2)
  /yf    = pin(yf 1 2)
  /total = N
.

* select children with a vaccination card.
select if IM1 = 1.

* calculate whether child who received HepB1 according to a vaccination card
* received it before her 1st birthday.
do if (IM5AM < 96 and IM5AY < 9996).
+ compute hepb1_12 = 0.
+ compute dov = (IM5AY - 1900)*12 + IM5AM.
+ if (dov - cdob < 13) hepb1_12 = 100.
else if (IM5AY < 9996).
+ if (IM5AY = UF10Y) hepb1_12 = 100.
+ if (IM5AY >= UF10Y + 2) hepb1_12 = 0.
end if.
variable label hepb1_12 "HepB1".

* calculate whether child who received HepB2 according to a vaccination card
* received it before her 1st birthday.
do if (IM5BM < 96 and IM5BY < 9996).
+ compute hepb2_12 = 0.
+ compute dov = (IM5BY - 1900)*12 + IM5BM.
+ if (dov - cdob < 13) hepb2_12 = 100.
else if (IM5BY < 9996).
+ if (IM5BY = UF10Y) hepb2_12 = 100.
+ if (IM5BY >= UF10Y + 2) hepb2_12 = 0.
end if.
variable label hepb2_12 "HepB2".

* calculate whether child who received HepB3 according to a vaccination card
* received it before her 1st birthday.
do if (IM5CM < 96 and IM5CY < 9996).
+ compute hepb3_12 = 0.
+ compute dov = (IM5CY - 1900)*12 + IM5CM.
+ if (dov - cdob < 13) hepb3_12 = 100.
else if (IM5CY < 9996).
+ if (IM5CY = UF10Y) hepb3_12 = 100.
+ if (IM5CY >= UF10Y + 2) hepb3_12 = 0.
end if.
variable label hepb3_12 "HepB3".

* calculate whether child who received HIB1 according to a vaccination card
* received it before her 1st birthday.
do if (IM7AM < 96 and IM7AY < 9996).
+ compute hib1_12 = 0.
+ compute dov = (IM7AY - 1900)*12 + IM7AM.
+ if (dov - cdob < 13) hib1_12 = 100.
else if (IM7AY < 9996).
+ if (IM7AY = UF10Y) hib1_12 = 100.
+ if (IM7AY >= UF10Y + 2) hib1_12 = 0.
end if.
variable label hib1_12 "HIB1".

* calculate whether child who received HIB2 according to a vaccination card
* received it before her 1st birthday.
do if (IM7BM < 96 and IM7BY < 9996).
+ compute hib2_12 = 0.
+ compute dov = (IM7BY - 1900)*12 + IM7BM.
+ if (dov - cdob < 13) hib2_12 = 100.
else if (IM7BY < 9996).
+ if (IM7BY = UF10Y) hib2_12 = 100.
+ if (IM7BY >= UF10Y + 2) hib2_12 = 0.
end if.
variable label hib2_12 "HIB2".

* calculate whether child who received HIB3 according to a vaccination card
* received it before her 1st birthday.
do if (IM7CM < 96 and IM7CY < 9996).
+ compute hib3_12 = 0.
+ compute dov = (IM7CY - 1900)*12 + IM7CM.
+ if (dov - cdob < 13) hib3_12 = 100.
else if (IM7CY < 9996).
+ if (IM7CY = UF10Y) hib3_12 = 100.
+ if (IM7CY >= UF10Y + 2) hib3_12 = 0.
end if.
variable label hib3_12 "HIB3".

* calculate whether child who received yellow fever according to a vaccination
* card received it before her 1st birthday.
do if (IM7M < 96 and IM7Y < 9996).
+ compute yf_12 = 0.
+ compute dov = (IM7Y - 1900)*12 + IM7M.
+ if (dov - cdob < 13) yf_12 = 100.
else if (IM7Y < 9996).
+ if (IM7Y = UF10Y) yf_12 = 100.
+ if (IM7Y >= UF10Y + 2) yf_12 = 0.
end if.
variable label yf_12 "Yellow Fever".

* create a data file containing percentage of vaccinations received in first
* year.
compute vacc = 4 .
aggregate
  /outfile = 'aggr4.sav'
  /break = vacc
  /hepb1 = pin(hepb1_12 100 100)
  /hepb2 = pin(hepb2_12 100 100)
  /hepb3 = pin(hepb3_12 100 100)
  /hib1  = pin(hib1_12 100 100)
  /hib2  = pin(hib2_12 100 100)
  /hib3  = pin(hib3_12 100 100)
  /yf    = pin(yf_12 100 100)
  /total = N
.

new file.

get file = 'aggr1.sav'.
ADD FILES
  /file = *
  /file = 'aggr2.sav'
  /file = 'aggr3.sav'
  /file = 'aggr4.sav'. 

* multiply percentage who received a vaccination by the (estimated) percentage
* who received it in the first year.
do if (vacc = 4).
+ compute hepb1 = hepb1*lag(hepb1)/100.
+ compute hepb2 = hepb2*lag(hepb2)/100.
+ compute hepb3 = hepb3*lag(hepb3)/100.
+ compute hib1 = hib1*lag(hib1)/100.
+ compute hib2 = hib2*lag(hib2)/100.
+ compute hib3 = hib3*lag(hib3)/100.
+ compute yf = yf*lag(yf)/100.
+ compute total = lag(total).
end if.

variable label
  hepb1 "HepB1"
 /hepb2 "HepB2"
 /hepb3 "HepB3*"
 /hib1  "Hib1"
 /hib2  "Hib2"
 /hib3  "Hib3"
 /yf    "Yellow Fever**"
 /total "Number of children aged 12-23 months".

value label vacc
  1 "Vaccination card"
  2 "Mother's report"
  3 "Either"
  4 "Vaccinated by 12 months of age".

tables
  /format = zero
  /observations hepb1 hepb2 hepb3 hib1 hib2 hib3 yf total
  /table vacc by hepb1 + hepb2 + hepb3 + hib1 + hib2 + hib3 + yf + total
  /statistics
    mean(hepb1 (f5.1) '')
    mean(hepb2 (f5.1) '')
    mean(hepb3 (f5.1) '')
    mean(hib1 (f5.1) '')
    mean(hib2 (f5.1) '')
    mean(hib3 (f5.1) '')
    mean(yf    (f5.1) '')
    mean(total (f5.0) '')
  /title
    "Table CH.1c Vaccinations in first year of life (continued)"
		"Percentage of children aged 12-23 months immunized against childhood "+
		"diseases at any time before the survey and before the first birthday, "+
		"Country, Year"
  /caption                                                      
    "* MICS Indicator 29"
		"** MICS Indicator 30".

new File.
erase file = 'aggr1.sav'.
erase file = 'aggr2.sav'.
erase file = 'aggr3.sav'.
erase file = 'aggr4.sav'.
