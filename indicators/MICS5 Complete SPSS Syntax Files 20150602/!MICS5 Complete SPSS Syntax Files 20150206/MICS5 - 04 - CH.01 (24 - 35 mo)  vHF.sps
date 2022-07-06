* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

include file = "MICS5 - 04 - CH.01 RECODE vHF.SPS".

select if (UF9 = 1).

weight by chweight.

select if (cage >= 24 and cage <= 35).

compute total = 1.
value labels total 1 "Number of children".

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
  /hepb0 = pin(hepb0 1 1)
  /hepb1 = pin(hepb1 1 1)
  /hepb2 = pin(hepb2 1 1)
  /hepb3 = pin(hepb3 1 1)
  /hib1 = pin(hib1 1 1)
  /hib2 = pin(hib2 1 1)
  /hib3 = pin(hib3 1 1)
  /yf = pin(yf 1 1)
  /measles = pin(measles 1 1)
  /basicvacc = pin(basicvacc 1 1)
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
  /hepb0 = pin(hepb0 2 2)
  /hepb1 = pin(hepb1 2 2)
  /hepb2 = pin(hepb2 2 2)
  /hepb3 = pin(hepb3 2 2)
  /hib1 = pin(hib1 2 2)
  /hib2 = pin(hib2 2 2)
  /hib3 = pin(hib3 2 2)
  /yf = pin(yf 2 2)
  /measles = pin(measles 2 2)
  /basicvacc = pin(basicvacc 2 2)
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
  /hib1 = pin(hib1 1 2)
  /hib2 = pin(hib2 1 2)
  /hib3 = pin(hib3 1 2)
  /yf = pin(yf 1 2)
  /measles = pin(measles 1 2)
  /basicvacc = pin(basicvacc 1 2)
  /novacc = pin(novacc 1 2)
  /total = N
.
* Select children with a vaccination card.
select if (HF11=1 or IM1=1).

define before12 (v_12 = !tokens(1) / vacc = !tokens(1) 
                 / vd = !tokens(1) / vm = !tokens(1) / vy = !tokens(1) / vlabel = !tokens(1)
                 / hfd = !tokens(1) / hfm = !tokens(1) / hfy = !tokens(1)).

* Calculate whether child who received vaccination according to a vaccination card
* received it before her 1st birthday.

do if (!vacc = 1 and !hfm < 44 and !hfy < 4444).
+ compute !v_12 = 0.
+ compute dov = (!hfy - 1900)*12 + !hfm.
+ if (dov - cdob < 13) !v_12 = 100.
else if (!vacc = 1 and  !hfm >= 44 and  !hfy < 4444).
+ compute !v_12 = 0.
+ if (!hfy <= AG1Y+1) !v_12 = 100.
end if.

do if ((!v_12 = 0 and !vacc = 1 and !vm < 44 and !vy < 4444) or (!vacc = 1 and !vm < 44 and !vy < 4444 and HF11 <> 1)).
+ compute !v_12 = 0.
+ compute dov = (!vy - 1900)*12 + !vm.
+ if (dov - cdob < 13) !v_12 = 100.
else if ((!v_12 = 0 and !vacc = 1 and !vm >= 44 and !vy < 4444) or (!vacc = 1 and !vm >= 44 and !vy < 4444 and HF11 <> 1)).
+ compute !v_12 = 0.
+ if (!vy <= AG1Y+1) !v_12 = 100.
end if.
variable label !v_12 !vlabel.

!enddefine.

 * define before24 (v_24 = !tokens(1) / vacc = !tokens(1) 
                 / vd = !tokens(1) / vm = !tokens(1) / vy = !tokens(1) / vlabel = !tokens(1)
                 / hfd = !tokens(1) / hfm = !tokens(1) / hfy = !tokens(1)).

* Calculate whether child who received vaccination according to a vaccination card
* received it before her 2nd birthday.

 * do if (!vacc = 1 and !hfm < 44 and !hfy < 4444).
 * + compute !v_24 = 0.
 * + compute dov = (!hfy - 1900)*12 + !hfm.
 * + if (dov - cdob < 25) !v_24 = 100.
 * else if (!vacc = 1 and  !hfm >= 44 and  !hfy < 4444).
 * + compute !v_24 = 0.
 * + if (!hfy <= AG1Y+2) !v_24 = 100.
 * end if.

 * do if ((!v_24 = 0 and !vacc = 1 and !vm < 44 and !vy < 4444) or (!vacc = 1 and !vm < 44 and !vy < 4444 and HF11 <> 1)).
 * + compute !v_24 = 0.
 * + compute dov = (!vy - 1900)*12 + !vm.
 * + if (dov - cdob < 25) !v_24 = 100.
 * else if ((!v_24 = 0 and !vacc = 1 and !vm >= 44 and !vy < 4444) or (!vacc = 1 and !vm >= 44 and !vy < 4444 and HF11 <> 1)).
 * + compute !v_24 = 0.
 * + if (!vy <= AG1Y+2) !v_24= 100.
 * end if.
 * variable label !v_24 !vlabel.

 * !enddefine.


* BCG.
before12  v_12=b_12   vacc=bcg    vd=IM3BD   vm=IM3BM   vy=IM3BY  hfd=HF13BD  hfm=HF13BM  hfy=HF13BY vlabel="BCG".

* Polio.
before12  v_12=p0_12 vacc=polio0 vd=IM3P0D vm=IM3P0M vy=IM3P0Y  hfd=HF13P0D   hfm=HF13P0M   hfy=HF13P0Y vlabel="Polio at birth".
before12  v_12=p1_12 vacc=polio1 vd=IM3P1D vm=IM3P1M vy=IM3P1Y  hfd=HF13P1D   hfm=HF13P1M   hfy=HF13P1Y vlabel="Polio 1".
before12  v_12=p2_12 vacc=polio2 vd=IM3P2D vm=IM3P2M vy=IM3P2Y  hfd=HF13P2D   hfm=HF13P2M   hfy=HF13P2Y vlabel="Polio 2".
before12  v_12=p3_12 vacc=polio3 vd=IM3P3D vm=IM3P3M vy=IM3P3Y  hfd=HF13P3D   hfm=HF13P3M   hfy=HF13P3Y vlabel="Polio 3".

* DPT.
before12  v_12=d1_12 vacc=DPT1 vd=IM3D1D vm=IM3D1M vy=IM3D1Y hfd=HF13D1D  hfm=HF13D1M   hfy=HF13D1Y vlabel="DPT 1".
before12  v_12=d2_12 vacc=DPT2 vd=IM3D2D vm=IM3D2M vy=IM3D2Y hfd=HF13D2D  hfm=HF13D2M   hfy=HF13D2Y vlabel="DPT 2".
before12  v_12=d3_12 vacc=DPT3 vd=IM3D3D vm=IM3D3M vy=IM3D3Y hfd=HF13D3D  hfm=HF13D3M   hfy=HF13D3Y vlabel="DPT 3".

* Hep B.
before12  v_12=h0_12 vacc=hepb0 vd=IM3H0D vm=IM3H0M vy=IM3H0Y hfd=HF13H0D  hfm=HF13H0M   hfy=HF13H0Y vlabel="HepB at birth".
before12  v_12=h1_12 vacc=hepb1 vd=IM3H1D vm=IM3H1M vy=IM3H1Y hfd=HF13H1D  hfm=HF13H1M   hfy=HF13H1Y vlabel="HepB 1".
before12  v_12=h2_12 vacc=hepb2 vd=IM3H2D vm=IM3H2M vy=IM3H2Y hfd=HF13H2D  hfm=HF13H2M   hfy=HF13H2Y vlabel="HepB 2".
before12  v_12=h3_12 vacc=hepb3 vd=IM3H3D vm=IM3H3M vy=IM3H3Y hfd=HF13H3D  hfm=HF13H3M   hfy=HF13H3Y vlabel="HepB 3".

* HiB.
before12  v_12=hb1_12 vacc=hib1 vd=IM3I1D vm=IM3I1M vy=IM3I1Y hfd=HF13I1D  hfm=HF13I1M   hfy=HF13I1Y vlabel="Hib 1".
before12  v_12=hb2_12 vacc=hib2 vd=IM3I2D vm=IM3I2M vy=IM3I2Y hfd=HF13I2D  hfm=HF13I2M   hfy=HF13I2Y vlabel="Hib 2".
before12  v_12=hb3_12 vacc=hib3 vd=IM3I3D vm=IM3I3M vy=IM3I3Y hfd=HF13I3D  hfm=HF13I3M   hfy=HF13I3Y vlabel="Hib 3".

* Measles.
before12  v_12=m_12 vacc=measles vd=IM3MD vm=IM3MM vy=IM3MY hfd=HF13MD  hfm=HF13MM   hfy=HF13MY vlabel="Measles".
*before24  v_24=m_12 vacc=measles vd=IM3MD vm=IM3MM vy=IM3MY hfd=HF13MD  hfm=HF13MM   hfy=HF13MY vlabel="Measles".

* YF.
before12  v_12=yf_12 vacc=yf vd=IM3YD vm=IM3YD vy=IM3YD hfd=HF13YD  hfm=HF13YM   hfy=HF13YY vlabel="Yellow Fever".


if (b_12 = 0 or 
    d1_12 = 0 or d2_12 = 0 or d3_12 = 0 or
    p1_12 = 0 or p2_12 = 0 or p3_12 = 0 or
    h1_12 = 0 or h2_12 = 0 or h3_12 = 0 or 
    hb1_12 = 0 or hb2_12 = 0 or hb3_12 = 0 or
    yf_12 = 0 or
    m_12 = 0) all_12 = 0.
if (b_12 = 100 & 
    d1_12 = 100 & d2_12 = 100 & d3_12 = 100 &
    p1_12 = 100 & p2_12 = 100 & p3_12 = 100 &
    h1_12 = 100 & h2_12 = 100 & h3_12 = 100 &
    hb1_12 = 100 & hb2_12 = 100 & hb3_12 = 100 &
    yf_12 = 100 &
    m_12 = 100) all_12 = 100.
variable labels all_12 "All vaccinations".

if (b_12 = 100 or 
    d1_12 = 100 or d2_12 = 100 or d3_12 = 100 or
    p1_12 = 100 or p2_12 = 100 or p3_12 = 100 or
    h1_12 = 100 or h2_12 = 100 or h3_12 = 100 or 
    hb1_12 = 100 or hb2_12 = 100 or hb3_12 = 100 or
    yf_ 12 = 100 or
    m_12 = 100) none_12 = 0.
if (b_12 = 0 & 
    d1_12 = 0 & d2_12 = 0 & d3_12 = 0 &
    p1_12 = 0 & p2_12 = 0 & p3_12 = 0 &
    h1_12 = 0 & h2_12 = 0 & h3_12 = 0 & 
    hb1_12 = 0 & hb2_12 = 0 & hb3_12 = 0 &
    yf_12 = 0 &
    m_12 = 0) none_12 = 100.
variable labels none_12 "No vaccinations".

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
  /hib1 = pin(hb1_12 100 100)
  /hib2 = pin(hb2_12 100 100)
  /hib3 = pin(hb3_12 100 100)
  /yf = pin(yf_12 100 100)
  /measles = pin(m_12 100 100)
  /basicvacc = pin(all_12 100 100)
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
+ compute hepb0 = hepb0*lag(hepb0)/100.
+ compute hepb1 = hepb1*lag(hepb1)/100.
+ compute hepb2 = hepb2*lag(hepb2)/100.
+ compute hepb3 = hepb3*lag(hepb3)/100.
+ compute hib1 = hib1*lag(hib1)/100.
+ compute hib2 = hib2*lag(hib2)/100.
+ compute hib3 = hib3*lag(hib3)/100.
+ compute measles = measles*lag(measles)/100.
+ compute basicvacc = basicvacc*lag(basicvacc)/100.
+ compute novacc = 100-(100-novacc)*(100-lag(novacc))/100.
+ compute total = lag(total).

end if.


variable labels
  bcg     "BCG [1]"
 /polio0  "Polio 0"
 /polio1  "Polio 1"
 /polio2  "Polio 2"
 /polio3  "Polio 3 [2]"
 /dpt1    "DPT 1"
 /dpt2    "DPT 2"
 /dpt3    "DPT 3 [3]"
 /hepb0  "HepB 0"
 /hepb1  "HepB 1"
 /hepb2  "HepB 2"
 /hepb3  "HepB 3 [4]"
 /hib1  "Hib 1"
 /hib2  "Hib 2"
 /hib3  "Hib 3 [5]"
 /measles "Measles[7]"
 /basicvacc "Fully vaccinated [8][b]"
 /novacc "No vaccinations"
 /total   "Number of children".
variable label vacc "".
value label vacc
  1 "Vaccinated at any time before the survey according to: Vaccination card or health facility records"
  2 "Vaccinated at any time before the survey according to: Mother's report"
  3 "Vaccinated at any time before the survey according to: Either"
  4 "Vaccinated by 12 months of age  (measles by 24 months) [a]".

ctables
  /vlabels variables = vacc
         display = none
  /table bcg [s] [mean,'',f5.1] + 
           polio0 [s] [mean,'',f5.1] + polio1 [s] [mean,'',f5.1] + polio2 [s] [mean,'',f5.1] + polio3 [s] [mean,'',f5.1] +
           dpt1 [s] [mean,'',f5.1] + dpt2 [s] [mean,'',f5.1] + dpt3 [s] [mean,'',f5.1] +
           hepb0 [s] [mean,'',f5.1] + hepb1 [s] [mean,'',f5.1] + hepb2 [s] [mean,'',f5.1] + hepb3 [s] [mean,'',f5.1] + 
           hib1 [s] [mean,'',f5.1] + hib2 [s] [mean,'',f5.1] + hib3 [s] [mean,'',f5.1] +
           yf [s] [mean,'',f5.1]  + 
           measles [s] [mean,'',f5.1]  + 
           basicvacc [s] [mean,'',f5.1] + novacc [s] [mean,'',f5.1] +
           total [s] [mean,'',f5.0] 
	by vacc [c] 
  /slabels position=column
  /titles title=
	"Table CH.1: Vaccinations in the first years of life  (part 2 24 - 35 months)"
	"Percentage of children age 12-23 months and 24-35 months vaccinated against vaccine preventable " +
	"childhood diseases at any time before the survey and by their first birthday, " + surveyname
  caption=
	"[1] MICS indicator 3.1 - Tuberculosis immunization coverage"
	"[2] MICS indicator 3.2 - Polio immunization coverage"									
	"[3] MICS indicator 3.3 - Diphtheria, pertussis and tetanus (DPT) immunization coverage"									
	"[4] MICS indicator 3.5 - Hepatitis B immunization coverage"					
	"[5] MICS indicator 3.6 - Haemophilus influenzae type B (Hib) immunization coverage"								
	"[6] MICS indicator 3.7 - Yellow fever immunization coverage"									
	"[7] MICS indicator 3.4; MDG indicator 4.3 - Measles immunization coverage"									
	"[8] MICS indicator 3.8 - Full immunization coverage"
	"[a] MICS indicators 3.1, 3.2, 3.3, 3.5, 3.6, and 3.7 refer to results of this column in the left panel; MICS indicators 3.4 and 3.8 refer to this column in the right panel"									
	"[b] Includes: BCG, Polio3, DPT3, HepB3, Hib3, and Measles (MCV1) as per the vaccination schedule in Country".				
													
new file.
erase file = 'aggr1.sav'.
erase file = 'aggr2.sav'.
erase file = 'aggr3.sav'.
erase file = 'aggr4.sav'.
