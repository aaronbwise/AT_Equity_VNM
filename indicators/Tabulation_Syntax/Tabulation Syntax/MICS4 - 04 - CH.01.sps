* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

include file = "MICS4 - 04 - CH.01 RECODE.SPS".

select if (UF9 = 1).
weight by chweight.

select if (cage >= 12 and cage <= 23).

compute total = 1.
value label total 1 "Number of children".

* Create a file with percent of children vaccinated according to a card.
compute vacc = 1 .
aggregate
  /outfile = 'aggr1.sav'
  /break = vacc
  /bcg = pin(bcg 1 1)
  /polio0 = pin(polio0 1 1)
  /polio1 = pin(polio1 1 1)
  /polio2 = pin(polio2 1 1)
  /polio3 = pin(polio3 1 1)
  /dpt1 = pin(dpt1 1 1)
  /dpt2 = pin(dpt2 1 1)
  /dpt3 = pin(dpt3 1 1)
  /measles = pin(measles 1 1)
  /hepb0 = pin(hepb0 1 1)
  /hepb1 = pin(hepb1 1 1)
  /hepb2 = pin(hepb2 1 1)
  /hepb3 = pin(hepb3 1 1)
  /yf = pin(yf 1 1)
  /allvacc = pin(allvacc 1 1)
  /novacc = pin(novacc 1 1)
  /total = N
.
* Create a file with percent of children vaccinated according mother's report.
compute vacc = 2 .
aggregate
  /outfile = 'aggr2.sav'
  /break = vacc
  /bcg = pin(bcg 2 2)
  /polio0 = pin(polio0 2 2)
  /polio1 = pin(polio1 2 2)
  /polio2 = pin(polio2 2 2)
  /polio3 = pin(polio3 2 2)
  /dpt1 = pin(dpt1 2 2)
  /dpt2 = pin(dpt2 2 2)
  /dpt3 = pin(dpt3 2 2)
  /measles = pin(measles 2 2)
  /hepb0 = pin(hepb0 2 2)
  /hepb1 = pin(hepb1 2 2)
  /hepb2 = pin(hepb2 2 2)
  /hepb3 = pin(hepb3 2 2)
  /yf = pin(yf 2 2)
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
  /polio0 = pin(polio0 1 2)
  /polio1 = pin(polio1 1 2)
  /polio2 = pin(polio2 1 2)
  /polio3 = pin(polio3 1 2)
  /dpt1 = pin(dpt1 1 2)
  /dpt2 = pin(dpt2 1 2)
  /dpt3 = pin(dpt3 1 2)
  /hepb0 = pin(hepb0 1 2)
  /hepb1 = pin(hepb1 1 2)
  /hepb2 = pin(hepb2 1 2)
  /hepb3 = pin(hepb3 1 2)
  /yf = pin(yf 1 2)
  /measles = pin(measles 1 2)
  /allvacc = pin(allvacc 1 2)
  /novacc = pin(novacc 1 2)
  /total = N
.
* Select children with a vaccination card.
select if IM1 = 1.

* Calculate whether child who received BCG according to a vaccination card
* received it before her 1st birthday.

do if (bcg = 1 and IM3BM < 96 and IM3BY < 9996).
+ compute b_12 = 0.
+ compute dov = (IM3BY - 1900)*12 + IM3BM.
+ if (dov - cdob < 13) b_12 = 100.
else if (bcg = 1 and IM3BY < 9996).
+ if (IM3BY = AG1Y) b_12 = 100.
+ if (IM3BY >= AG1Y + 2) b_12 = 0.
end if.
variable label b_12 "BCG".

* Calculate whether child who received Polio 0 according to a vaccination card
* received it before her 1st birthday.

do if (polio0 = 1 and IM3P0M < 96 and IM3P0Y < 9996).
+ compute p0_12 = 0.
+ compute dov = (IM3P0Y - 1900)*12 + IM3P0M.
+ if (dov - cdob < 13) p0_12 = 100.
else if (polio0 = 1 and IM3P0Y < 9996).
+ if (IM3P0Y = AG1Y) p0_12 = 100.
+ if (IM3P0Y >= AG1Y + 2) p0_12 = 0.
end if.
variable label p0_12 "Polio 0".

* Calculate whether child who received Polio 1 according to a vaccination card
* received it before her 1st birthday.

do if (polio1 = 1 and IM3P1M < 96 and IM3P1Y < 9996).
+ compute p1_12 = 0.
+ compute dov = (IM3P1Y - 1900)*12 + IM3P1M.
+ if (dov - cdob < 13) p1_12 = 100.
else if (polio1 = 1 and IM3P1Y < 9996).
+ if (IM3P1Y = AG1Y) p1_12 = 100.
+ if (IM3P1Y >= AG1Y + 2) p1_12 = 0.
end if.
variable label p1_12 "Polio 1".

* Calculate whether child who received Polio 2 according to a vaccination card
* received it before her 1st birthday.

do if (polio2 = 1 and IM3P2M < 96 and IM3P2Y < 9996).
+ compute p2_12 = 0.
+ compute dov = (IM3P2Y - 1900)*12 + IM3P2M.
+ if (dov - cdob < 13) p2_12 = 100.
else if (polio2 = 1 and IM3P2Y < 9996).
+ if (IM3P2Y = AG1Y) p2_12 = 100.
+ if (IM3P2Y >= AG1Y + 2) p2_12 = 0.
end if.
variable label p2_12 "Polio 2".

* Calculate whether child who received Polio 3 according to a vaccination card
* received it before her 1st birthday.

do if (polio3 = 1 and IM3P3M < 96 and IM3P3Y < 9996).
+ compute p3_12 = 0.
+ compute dov = (IM3P3Y - 1900)*12 + IM3P3M.
+ if (dov - cdob < 13) p3_12 = 100.
else if (polio3 = 1 and IM3P3Y < 9996).
+ if (IM3P3Y = AG1Y) p3_12 = 100.
+ if (IM3P3Y >= AG1Y + 2) p3_12 = 0.
end if.
variable label p3_12 "Polio 3".

* Calculate whether child who received DPT1 according to a vaccination card
* received it before her 1st birthday.

do if (dpt1 = 1 and IM3D1M < 96 and IM3D1Y < 9996).
+ compute d1_12 = 0.
+ compute dov = (IM3D1Y - 1900)*12 + IM3D1M.
+ if (dov - cdob < 13) d1_12 = 100.
else if (dpt1 = 1 and IM3D1Y < 9996).
+ if (IM3D1Y = AG1Y) d1_12 = 100.
+ if (IM3D1Y >= AG1Y + 2) d1_12 = 0.
end if.
variable label d1_12 "DPT 1".

* Calculate whether child who received DPT2 according to a vaccination card
* received it before her 1st birthday.
do if (dpt2 = 1 and IM3D2M < 96 and IM3D2Y < 9996).
+ compute d2_12 = 0.
+ compute dov = (IM3D2Y - 1900)*12 + IM3D2M.
+ if (dov - cdob < 13) d2_12 = 100.
else if (dpt2 = 1 and IM3D2Y < 9996).
+ if (IM3D2Y = AG1Y) d2_12 = 100.
+ if (IM3D2Y >= AG1Y + 2) d2_12 = 0.
end if.
variable label d2_12 "DPT 2".

* Calculate whether child who received DPT3 according to a vaccination card
* received it before her 1st birthday.

do if (dpt3 = 1 and IM3D3M < 96 and IM3D3Y < 9996).
+ compute d3_12 = 0.
+ compute dov = (IM3D3Y - 1900)*12 + IM3D3M.
+ if (dov - cdob < 13) d3_12 = 100.
else if (dpt3 = 1 and IM3D3Y < 9996).
+ if (IM3D3Y = AG1Y) d3_12 = 100.
+ if (IM3D3Y >= AG1Y + 2) d3_12 = 0.
end if.
variable label d3_12 "DPT 3".

* Calculate whether child who received measles according to a vaccination card
* received it before her 1st birthday.
do if (measles = 1 and IM3MM < 96 and IM3MY < 9996).
+ compute m_12 = 0.
+ compute dov = (IM3MY - 1900)*12 + IM3MM.
+ if (dov - cdob < 13) m_12 = 100.
else if (measles = 1 and IM3MY < 9996).
+ if (IM3MY = AG1Y) m_12 = 100.
+ if (IM3MY >= AG1Y + 2) m_12 = 0.
end if.
variable label m_12 "Measles".

* Calculate whether child who received HepB0 according to a vaccination card
* received it before her 1st birthday.
do if (hepb0 = 1 and IM3H0M < 96 and IM3H0Y < 9996).
+ compute h0_12 = 0.
+ compute dov = (IM3H0Y - 1900)*12 + IM3H0M.
+ if (dov - cdob < 13) h0_12 = 100.
else if (hepb0 = 1 and IM3H0Y < 9996).
+ if (IM3H0Y = AG1Y) h0_12 = 100.
+ if (IM3H0Y >= AG1Y + 2) h0_12 = 0.
end if.
variable label h0_12 "HepB at birth".

* Calculate whether child who received HepB1 according to a vaccination card
* received it before her 1st birthday.
do if (hepb1 = 1 and IM3H1M < 96 and IM3H1Y < 9996).
+ compute h1_12 = 0.
+ compute dov = (IM3H1Y - 1900)*12 + IM3H1M.
+ if (dov - cdob < 13) h1_12 = 100.
else if (hepb1 = 1 and IM3H1Y < 9996).
+ if (IM3H1Y = AG1Y) h1_12 = 100.
+ if (IM3H1Y >= AG1Y + 2) h1_12 = 0.
end if.
variable label h1_12 "HepB 1".

* Calculate whether child who received HepB2 according to a vaccination card
* received it before her 1st birthday.
do if (hepb2 = 1 and IM3H2M < 96 and IM3H2Y < 9996).
+ compute h2_12 = 0.
+ compute dov = (IM3H2Y - 1900)*12 + IM3H2M.
+ if (dov - cdob < 13) h2_12 = 100.
else if (hepb2 = 1 and IM3H2Y < 9996).
+ if (IM3H2Y = AG1Y) h2_12 = 100.
+ if (IM3H2Y >= AG1Y + 2) h2_12 = 0.
end if.
variable label h2_12 "HepB 2".

* Calculate whether child who received HepB3 according to a vaccination card
* received it before her 1st birthday.
do if (hepb3 = 1 and IM3H3M < 96 and IM3H3Y < 9996).
+ compute h3_12 = 0.
+ compute dov = (IM3H3Y - 1900)*12 + IM3H3M.
+ if (dov - cdob < 13) h3_12 = 100.
else if (hepb3 = 1 and IM3H3Y < 9996).
+ if (IM3H3Y = AG1Y) h3_12 = 100.
+ if (IM3H3Y >= AG1Y + 2) h3_12 = 0.
end if.
variable label h3_12 "HepB 3".

* Calculate whether child who received Yellow Fever vaccine according to a vaccination card
* received it before her 1st birthday.
do if (yf = 1 and IM3YM < 96 and IM3YY < 9996).
+ compute yf_12 = 0.
+ compute dov = (IM3YY - 1900)*12 + IM3YM.
+ if (dov - cdob < 13) yf_12 = 100.
else if (yf = 1 and IM3YY < 9996).
+ if (IM3YY = AG1Y) yf_12 = 100.
+ if (IM3YY >= AG1Y + 2) yf_12 = 0.
end if.
variable label yf_12 "Yellow fever".

if (b_12 = 0 or m_12 = 0 or d1_12 = 0 or d2_12 = 0 or d3_12 = 0 or p1_12 = 0 
  or p2_12 = 0 or p3_12 = 0 or h1_12 = 0 or h2_12 = 0 or h3_12 = 0 or yf_12 = 0) all_12 = 0.
if (b_12 = 100 & m_12 = 100 & d1_12 = 100 & d2_12 = 100 & d3_12 = 100 & 
  p1_12 = 100 & p2_12 = 100 & p3_12 = 100 & h1_12 = 100 & 
  h2_12 = 100 & h3_12 = 100 & yf_12 = 100) all_12 = 100.
variable label all_12 "All vaccinations".

if (b_12 = 100 or m_12 = 100 or d1_12 = 100 or d2_12 = 100 or d3_12 = 100 or 
  p1_12 = 100 or p2_12 = 100 or p3_12 = 100 or h1_12 = 100 or 
  h2_12 = 100 or h3_12 = 100 or yf_12 = 100) none_12 = 0.
if (b_12 = 0 & m_12 = 0 & d1_12 = 0 & d2_12 = 0 & d3_12 = 0 & p1_12 = 0 & 
  p2_12 = 0 & p3_12 = 0  & h1_12 = 0 & h2_12 = 0 & h3_12 = 0 & yf_12 = 0) none_12 = 100.
variable label none_12 "No vaccinations".

* Create a data file containing percentage of vaccinations received in first year.
compute vacc = 4 .
aggregate
  /outfile = 'aggr4.sav'
  /break = vacc
  /bcg = pin(b_12 100 100)
  /polio0 = pin(p0_12 100 100)
  /polio1 = pin(p1_12 100 100)
  /polio2 = pin(p2_12 100 100)
  /polio3 = pin(p3_12 100 100)
  /dpt1 = pin(d1_12 100 100)
  /dpt2 = pin(d2_12 100 100)
  /dpt3 = pin(d3_12 100 100)
  /hepb0 = pin(h0_12 100 100)
  /hepb1 = pin(h1_12 100 100)
  /hepb2 = pin(h2_12 100 100)
  /hepb3 = pin(h3_12 100 100)
  /yf = pin(yf_12 100 100)
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

* Multiply percentage who received a vaccination by the (estimated) percentage
* who received it in the first year.

do if (vacc = 4).
+ compute bcg = bcg*lag(bcg)/100.
+ compute polio0 = polio0*lag(polio0)/100.
+ compute polio1 = polio1*lag(polio1)/100.
+ compute polio2 = polio2*lag(polio2)/100.
+ compute polio3 = polio3*lag(polio3)/100.
+ compute dpt1 = dpt1*lag(dpt1)/100.
+ compute dpt2 = dpt2*lag(dpt2)/100.
+ compute dpt3 = dpt3*lag(dpt3)/100.
+ compute measles = measles*lag(measles)/100.
+ compute hepb0 = hepb0*lag(hepb0)/100.
+ compute hepb1 = hepb1*lag(hepb1)/100.
+ compute hepb2 = hepb2*lag(hepb2)/100.
+ compute hepb3 = hepb3*lag(hepb3)/100.
+ compute yf = yf *lag(yf)/100.
+ compute allvacc = allvacc*lag(allvacc)/100.
+ compute novacc = 100-(100-novacc)*(100-lag(novacc))/100.
+ compute total = lag(total).

end if.
variable label
  bcg     "BCG [1]"
 /polio0  "Polio 0"
 /polio1  "Polio 1"
 /polio2  "Polio 2"
 /polio3  "Polio 3 [2]"
 /dpt1    "DPT 1"
 /dpt2    "DPT 2"
 /dpt3    "DPT 3 [3]"
 /measles "Measles [4]"
 /hepb0  "HepB at birth"
 /hepb1  "HepB 1"
 /hepb2  "HepB 2"
 /hepb3  "HepB 3 [5]"
 /yf "Yellow fever [6]"
 /allvacc "All vaccinations"
 /novacc "No vaccinations"
 /total   "Number of children age 12-23 months".
variable label vacc "".
value label vacc
  1 "Vaccinated at any time before the survey according to: Vaccination card"
  2 "Vaccinated at any time before the survey according to: Mother's report"
  3 "Vaccinated at any time before the survey according to: Either"
  4 "Vaccinated by 12 months of age".

* For labels in French uncomment commands bellow.

*variable labels
 allvacc "Toutes les vaccinations"
 /novacc "Aucune vaccination"
 /total   "Nombre d'enfants âgés de 12-23 mois".
*value labels vacc
  1 "Vaccinés à n'importe quel moment avant l'enquête selon: la carte de vaccination"
  2 "Vaccinés à n'importe quel moment avant l'enquête selon: la déclaration de la mère"
  3 "Vaccinés à n'importe quel moment avant l'enquête selon: l'une ou l'autre"
  4 "Vaccinés avant 12 mois".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = vacc
         display = none
  /table bcg [s] [mean,'',f5.1] + 
           polio0 [s] [mean,'',f5.1] + polio1 [s] [mean,'',f5.1] + polio2 [s] [mean,'',f5.1] + polio3 [s] [mean,'',f5.1] +
           dpt1 [s] [mean,'',f5.1] + dpt2 [s] [mean,'',f5.1] + dpt3 [s] [mean,'',f5.1] +
           measles [s] [mean,'',f5.1] + 
           hepb0 [s] [mean,'',f5.1] + hepb1 [s] [mean,'',f5.1] + hepb2 [s] [mean,'',f5.1] + hepb3 [s] [mean,'',f5.1] +
           yf [s] [mean,'',f5.1] +
           allvacc [s] [mean,'',f5.1] + novacc [s] [mean,'',f5.1] +
           total [s] [mean,'',f5.0] 
	by vacc [c] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
  "Table CH.1: Vaccinations in first year of life "
  "Percentage of children age 12-23 months immunized against childhood diseases at any time before the survey and before the first birthday, " + surveyname
  caption=
		"[1] MICS indicator 3.1"
		"[2] MICS indicator 3.2"
		"[3] MICS indicator 3.3"
		"[4] MICS indicator 3.4; MDG indicator 4.3"
		"[5] MICS indicator 3.5"
		"[6] MICS indicator 3.6".

* Ctables command in French.
*
ctables
  /vlabels variables = vacc
         display = none
  /table bcg [s] [mean,'',f5.1] + 
           polio0 [s] [mean,'',f5.1] + polio1 [s] [mean,'',f5.1] + polio2 [s] [mean,'',f5.1] + polio3 [s] [mean,'',f5.1] +
           dpt1 [s] [mean,'',f5.1] + dpt2 [s] [mean,'',f5.1] + dpt3 [s] [mean,'',f5.1] +
           measles [s] [mean,'',f5.1] + 
           hepb0 [s] [mean,'',f5.1] + hepb1 [s] [mean,'',f5.1] + hepb2 [s] [mean,'',f5.1] + hepb3 [s] [mean,'',f5.1] +
           yf [s] [mean,'',f5.1] + 
           allvacc [s] [mean,'',f5.1] + novacc [s] [mean,'',f5.1] +
           total [s] [mean,'',f5.0] 
	by vacc [c] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
  "Table CH.1: Vaccinations au cours de la première année de vie"
  "Pourcentage d'enfants âgés de 12-23 mois vaccinés contre les maladies infantiles à n'importe quel moment avant l'enquête et avant leur premier anniversaire, " + surveyname
  caption=
		"[1] Indicateur MICS 3.1"
		"[2] Indicateur MICS 3.2"
		"[3] Indicateur MICS 3.3"
		"[4] Indicateur MICS 3.4;  Indicateur OMD 4.3"
		"[5] Indicateur MICS 3.5"
		"[6] Indicateur MICS 3.6".				

new file.
erase file = 'aggr1.sav'.
erase file = 'aggr2.sav'.
erase file = 'aggr3.sav'.
erase file = 'aggr4.sav'.
