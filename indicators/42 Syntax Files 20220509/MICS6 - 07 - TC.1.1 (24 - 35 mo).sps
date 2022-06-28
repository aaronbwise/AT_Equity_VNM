* Encoding: UTF-8.
*v02 - 2014-04-23.
* variable h3_12 included in calculation of all vaccines.
***.
*v02 - 2020-04-27: Several changes related to the latest tab plan. Labels in French and Spanish have been removed.
***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

include file = "MICS6 - 07 - TC - RECODE.sps".

select if (UF17 = 1).

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
  /polio3ipv = pin(polio3ipv 1 1)  
  /hepB0 = pin(hepB0 1 1)  
  /hepB0day = pin(hepB0day 1 1)  
  /hepB0later = pin(hepB0later 1 1)  
  /penta1 = pin(penta1 1 1)
  /penta2 = pin(penta2 1 1)
  /penta3 = pin(penta3 1 1)
  /pneumo1 = pin(pneumo1 1 1)
  /pneumo2 = pin(pneumo2 1 1)
  /pneumo3 = pin(pneumo3 1 1)
  /rota1 = pin(rota1 1 1)
  /rota2 = pin(rota2 1 1)
  /rota3 = pin(rota3 1 1)
  /yf = pin(yf 1 1)
  /td = pin(td 1 1)
  /measles1 = pin(measles1 1 1)
  /measles2 = pin(measles2 1 1)
  /basicvacc = pin(basicvacc 1 1)
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
  /polio3ipv = pin(polio3ipv 2 2)  
  /hepB0 = pin(hepB0 2 2)  
  /hepB0day = pin(hepB0day 2 2)  
  /hepB0later = pin(hepB0later 2 2)  
  /penta1 = pin(penta1 2 2)
  /penta2 = pin(penta2 2 2)
  /penta3 = pin(penta3 2 2)
  /pneumo1 = pin(pneumo1 2 2)
  /pneumo2 = pin(pneumo2 2 2)
  /pneumo3 = pin(pneumo3 2 2)
  /rota1 = pin(rota1 2 2)
  /rota2 = pin(rota2 2 2)
  /rota3 = pin(rota3 2 2)
  /yf = pin(yf 2 2)
  /td = pin(td 2 2)
  /measles1 = pin(measles1 2 2)
  /measles2 = pin(measles2 2 2)
  /basicvacc = pin(basicvacc 2 2)
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
  /polio3ipv = pin(polio3ipv 1 2)  
  /hepB0 = pin(hepB0 1 2)  
  /hepB0day = pin(hepB0day 1 2)  
  /hepB0later = pin(hepB0later 1 2)  
  /penta1 = pin(penta1 1 2)
  /penta2 = pin(penta2 1 2)
  /penta3 = pin(penta3 1 2)
  /pneumo1 = pin(pneumo1 1 2)
  /pneumo2 = pin(pneumo2 1 2)
  /pneumo3 = pin(pneumo3 1 2)
  /rota1 = pin(rota1 1 2)
  /rota2 = pin(rota2 1 2)
  /rota3 = pin(rota3 1 2)
  /yf = pin(yf 1 2)
  /td = pin(td 1 2)
  /measles1 = pin(measles1 1 2)
  /measles2 = pin(measles2 1 2)
  /basicvacc = pin(basicvacc 1 2)
  /allvacc = pin(allvacc 1 2)
  /novacc = pin(novacc 1 2)
  /total = N
.

* Select children with a vaccination card.
select if (IM5 = 1 or IM5 = 2 or IM5 = 3).

define before12 (v_12 = !tokens(1) / vacc = !tokens(1) / vd = !tokens(1) / vm = !tokens(1) / vy = !tokens(1) / vlabel = !tokens(1)).

* Calculate whether child who received vaccination according to a vaccination card
* received it before her 1st birthday.

do if (!vacc = 1 and !vm < 96 and !vy < 9996).
+ compute !v_12 = 0.
+ compute dov = (!vy - 1900)*12 + !vm.
+ if (dov - cdob < 13) !v_12 = 100.
else if (!vacc = 1 and !vy < 9996).
+ compute !v_12 = 0.
+ if (!vy <= UB1Y+1) !v_12 = 100.
end if.
variable label !v_12 !vlabel.

!enddefine.


define before24 (v_12 = !tokens(1) / vacc = !tokens(1) / vd = !tokens(1) / vm = !tokens(1) / vy = !tokens(1) / vlabel = !tokens(1)).

* Calculate whether child who received vaccination according to a vaccination card
* received it before her 2nd birthday.

do if (!vacc = 1 and !vm < 96 and !vy < 9996).
+ compute !v_12 = 0.
+ compute dov = (!vy - 1900)*12 + !vm.
+ if (dov - cdob < 25) !v_12 = 100.
else if (!vacc = 1 and !vy < 9996).
+ compute !v_12 = 0.
+ if (!vy <= UB1Y + 2) !v_12 = 100.
end if.
variable label !v_12 !vlabel.

!enddefine.


* BCG.
before12  v_12=b_12   vacc=bcg    vd=IM6BD   vm=IM6BM   vy=IM6BY  vlabel="BCG".

* Polio.
before12  v_12=p0_12 vacc=polio0 vd=IM6P0D vm=IM6P0M vy=IM6P0Y vlabel="Polio at birth".
before12  v_12=p1_12 vacc=polio1 vd=IM6P1D vm=IM6P1M vy=IM6P1Y vlabel="OPV1".
before12  v_12=p2_12 vacc=polio2 vd=IM6P2D vm=IM6P2M vy=IM6P2Y vlabel="OPV2".
before12  v_12=p3_12 vacc=polio3 vd=IM6P3D vm=IM6P3M vy=IM6P3Y vlabel="OPV3".
before12  v_12=i_12 vacc=ipv vd=IM6ID vm=IM6IM vy=IM6IY vlabel="IPV".
* Combination Polio3 and IPV.
compute p3i_12=0.
if p3_12=100 and i_12=100 p3i_12=100.
variable labels p3i_12 "OPV3 and IPV".

* HepB0.
before12  v_12=hepB0_12 vacc=hepB0 vd=IM6H0D vm=IM6H0M vy=IM6H0Y vlabel="HepB at birth".
before12  v_12=hepB0a_12 vacc=hepB0day vd=IM6H0Da vm=IM6H0Ma vy=IM6H0Ya vlabel="HepB at birth: Within 1 day".
before12  v_12=hepB0b_12 vacc=hepB0later vd=IM6H0Db vm=IM6H0Mb vy=IM6H0Yb vlabel="HepB at birth: Later".

* Penta.
before12  v_12=d1_12 vacc=penta1 vd=IM6PENTA1D vm=IM6PENTA1M vy=IM6PENTA1Y vlabel="Penta 1".
before12  v_12=d2_12 vacc=penta2 vd=IM6PENTA2D vm=IM6PENTA2M vy=IM6PENTA2Y vlabel="Penta 2".
before12  v_12=d3_12 vacc=penta3 vd=IM6PENTA3D vm=IM6PENTA3M vy=IM6PENTA3Y vlabel="Penta 3".

* Pneumococcal.
before12  v_12=h1_12 vacc=pneumo1 vd=IM6PCV1D vm=IM6PCV1M vy=IM6PCV1Y vlabel="Pneumo 1".
before12  v_12=h2_12 vacc=pneumo2 vd=IM6PCV2D vm=IM6PCV2M vy=IM6PCV2Y vlabel="Pneumo 2".
before12  v_12=h3_12 vacc=pneumo3 vd=IM6PCV3D vm=IM6PCV3M vy=IM6PCV3Y vlabel="Pneumo 3".

* Rota.
before12  v_12=r1_12 vacc=rota1 vd=IM6R1D vm=IM6R1M vy=IM6R1Y vlabel="Rota 1".
before12  v_12=r2_12 vacc=rota2 vd=IM6R2D vm=IM6R2M vy=IM6R2Y vlabel="Rota 2".
before12  v_12=r3_12 vacc=rota3 vd=IM6R3D vm=IM6R3M vy=IM6R3Y vlabel="Rota 3".

* Measles.
before12  v_12=m1_12 vacc=measles1 vd=IM6M1D vm=IM6M1M vy=IM6M1Y vlabel="Measles 1".
before24  v_12=m2_12 vacc=measles2 vd=IM6M2D vm=IM6M2M vy=IM6M2Y vlabel="Measles 2".

* Yellow fever.
before24  v_12=yf_12 vacc=yf vd=IM6YD vm=IM6YM vy=IM6YY vlabel="Yellow fever".

* Td Booster. 
before24  v_12=td_12 vacc=td vd=IM6TDD vm=IM6TDM vy=IM6TDY vlabel="Td Booster".

if (b_12 = 0 or 
    p1_12 = 0 or p2_12 = 0 or p3_12 = 0 or
    d1_12 = 0 or d2_12 = 0 or d3_12 = 0 or
    m1_12 = 0) basic_12 = 0.
if (b_12 = 100 & 
    p1_12 = 100 & p2_12 = 100 & p3_12 = 100 &
    d1_12 = 100 & d2_12 = 100 & d3_12 = 100 &
    m1_12 = 100) basic_12 = 100.
variable labels basic_12 "Basic vaccinations".

if (b_12 = 0 or 
    p1_12 = 0 or p2_12 = 0 or p3_12 = 0 or p3i_12 = 0 or
    d1_12 = 0 or d2_12 = 0 or d3_12 = 0 or
    h1_12 = 0 or h2_12 = 0 or h3_12 = 0 or
    r1_12 = 0 or r2_12 = 0 or r3_12 = 0 or
    m1_12 = 0 or m2_12 = 0 or yf_12 = 0  or td_12 = 0) all_12 = 0.
if (b_12 = 100 & 
    p1_12 = 100 & p2_12 = 100 & p3_12 = 100 & p3i_12 = 100 &
    d1_12 = 100 & d2_12 = 100 & d3_12 = 100 &
    h1_12 = 100 & h2_12 = 100 & h3_12 = 100 &
    r1_12 = 100 & r2_12 = 100 & r3_12 = 100 &
    m1_12 = 100 & m2_12 = 100 & yf_12 = 100 & td_12 = 100) all_12 = 100.
variable labels all_12 "All vaccinations".

if (b_12 = 100 or 
    p1_12 = 100 or p2_12 = 100 or p3_12 = 100 or i_12 = 100 or 
    d1_12 = 100 or d2_12 = 100 or d3_12 = 100 or
    h1_12 = 100 or h2_12 = 100 or h3_12 = 100 or
    r1_12 = 100 or r2_12 = 100 or r3_12 = 100 or
    m1_12 = 100 or m2_12 =100 or yf_12 = 100 or td_12 = 100) none_12 = 0.
if (b_12 = 0 & 
    p1_12 = 0 & p2_12 = 0 & p3_12 = 0 & i_12 =0 &
    d1_12 = 0 & d2_12 = 0 & d3_12 = 0 &
    h1_12 = 0 & h2_12 = 0 & h3_12 = 0 & 
    r1_12 = 0 & r2_12 = 0 & r3_12 = 0 &
    m1_12 = 0 & m2_12 = 0 & yf_12 = 0 & td_12 = 0) none_12 = 100.
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
  /polio3ipv = pin(p3i_12 100 100)  
  /hepB0 = pin(hepB0_12 100 100)  
  /hepB0day = pin(hepB0a_12 100 100)  
  /hepB0later = pin(hepB0b_12 100 100)  
  /penta1 = pin(d1_12 100 100)
  /penta2 = pin(d2_12 100 100)
  /penta3 = pin(d3_12 100 100)
  /pneumo1 = pin(h1_12 100 100)
  /pneumo2 = pin(h2_12 100 100)
  /pneumo3 = pin(h3_12 100 100)
  /rota1 = pin(r1_12 100 100)
  /rota2 = pin(r2_12 100 100)
  /rota3 = pin(r2_12 100 100)
  /measles1 = pin(m1_12 100 100)
  /measles2 = pin(m2_12 100 100)
  /yf = pin(yf_12 100 100)
  /td = pin(td_12 100 100)
  /basicvacc = pin(basic_12 100 100)
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
+ compute polio3ipv = polio3ipv*lag(polio3ipv)/100.
+ compute hepB0 = hepB0*lag(hepB0)/100.
+ compute hepB0day = hepB0day*lag(hepB0day)/100.
+ compute hepB0later = hepB0later*lag(hepB0later)/100.
+ compute penta1 = penta1*lag(penta1)/100.
+ compute penta2 = penta2*lag(penta2)/100.
+ compute penta3 = penta3*lag(penta3)/100.
+ compute pneumo1 = pneumo1*lag(pneumo1)/100.
+ compute pneumo2 = pneumo2*lag(pneumo2)/100.
+ compute pneumo3 = pneumo3*lag(pneumo3)/100.
+ compute rota1 = rota1*lag(rota1)/100.
+ compute rota2 = rota2*lag(rota2)/100.
+ compute rota3 = rota3*lag(rota3)/100.
+ compute measles1 = measles1*lag(measles1)/100.
+ compute measles2 = measles2*lag(measles2)/100.
+ compute yf = yf*lag(yf)/100.
+ compute td = td*lag(td)/100.
+ compute basicvacc = basicvacc*lag(basicvacc)/100.
+ compute allvacc = allvacc*lag(allvacc)/100.
+ compute novacc = 100-(100-novacc)*(100-lag(novacc))/100.
+ compute total = lag(total).

end if.

variable labels
  bcg     "BCG [1]"
 /polio0  "Polio (OPV) at birth [C]"
 /polio1  "Polio (OPV) 1"
 /polio2  "Polio (OPV) 2"
 /polio3  "Polio (OPV) 3"
 /polio3ipv  "Polio (OPV3 and IPV) [2]" 
 /hepB0 "HepB at birth [D]"
 /hepB0day "    HepB at birth: Within 1 day"
 /hepB0later "    HepB at birth: Later"
 /penta1    "DTP-HepB-Hib 1"
 /penta2    "DTP-HepB-Hib 2"
 /penta3    "DTP-HepB-Hib [3] [4] [5]"
 /pneumo1  "Pneumococcal (Conjugate) 1"
 /pneumo2  "Pneumococcal (Conjugate) 2"
 /pneumo3  "Pneumococcal (Conjugate) 3 [6]"
 /rota1  "Rotavirus 1"
 /rota2  "Rotavirus 2"
 /rota3  "Rotavirus 3 [7]"
 /measles1 "Measles-Rubella 1 [8]"
 /measles2 "Measles-Rubella 2 [9]"
 /yf "Yellow fever [10]"
 /td "Td Booster 1"
 /basicvacc "Basic antigens [11] [E]"
 /allvacc "All antigens [12] [F]"
 /novacc "No vaccinations"
 /total   "Number of children".

variable labels vacc "".
value labels vacc
  1 "Vaccination records [A]"
  2 "Mother's report"
  3 "Either (Crude coverage) [B] "
  4 "Vaccinated by 12 months of age".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Vaccinated at any time before the survey according to:".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Antigen".

ctables
  /format missing = "na" 
  /vlabels variables = vacc layer layer1
         display = none
  /table layer1 [c] > (bcg [s] [mean '' f5.1] + 
           polio0 [s] [mean '' f5.1] + polio1 [s] [mean '' f5.1] + polio2 [s] [mean '' f5.1] + polio3 [s] [mean '' f5.1] + polio3ipv [s] [mean,'',f5.1] +
           hepB0 [s] [mean '' f5.1] + hepB0day [s] [mean '' f5.1] + hepB0later [s] [mean '' f5.1] +
           penta1 [s] [mean '' f5.1] + penta2 [s] [mean '' f5.1] + penta3 [s] [mean '' f5.1] +
           pneumo1 [s] [mean '' f5.1] + pneumo2 [s] [mean '' f5.1] + pneumo3 [s] [mean '' f5.1] +
           rota1 [s] [mean '' f5.1] + rota2 [s] [mean '' f5.1] + rota3 [s] [mean '' f5.1] +
           measles1 [s] [mean '' f5.1]  + measles2 [s] [mean '' f5.1] +
           yf [s] [mean '' f5.1] +
           td [s] [mean '' f5.1]) + 
           basicvacc [s] [mean '' f5.1] +  allvacc [s] [mean '' f5.1] +  novacc [s] [mean '' f5.1] +
           total [s] [mean '' f5.0] 
	by layer [c] > vacc [c] 
  /slabels position=column  visible=no
  /titles title=
	"Table TC.1.1: Vaccinations in the first years of life  (part  II: Children age 24-35 months:)"
	"Percentage of children age 12-23 months and 24-35 months vaccinated against vaccine preventable childhood diseases at any time before the survey (Crude coverage) and by their first birthday, " + surveyname
  caption=
    "[1] MICS indicator TC.1 - Tuberculosis immunization coverage"
    "[2] MICS indicator TC.2 - Polio immunization coverage"								
    "[3] MICS indicator TC.3 - Diphtheria, tetanus and pertussis (DTP) immunization coverage; SDG indicator 3.b.1 & 3.8.1"								
    "[4] MICS indicator TC.4 - Hepatitis B immunization coverage"								
    "[5] MICS indicator TC.5 - Haemophilus influenzae type B (Hib) immunization coverage"							
    "[6] MICS indicator TC.6 - Pneumococcal (Conjugate) immunization coverage; SDG indicator 3.b.1"								
    "[7] MICS indicator TC.7 - Rotavirus immunization coverage"							
    "[8] MICS indicator TC.8 - Rubella immunization coverage"							
    "[9] MICS indicator TC.10 - Measles immunization coverage; SDG indicator 3.b.1"								
    "[10] MICS indicator TC.9 - Yellow fever immunization coverage"								
    "[11] MICS indicator TC.11a - Full immunization coverage (basic antigens)"								
    "[12] MICS indicator TC.11b - Full immunization coverage (all antigens)"							
    "na: not applicable"							
    "[A] Vaccination card or other documents where the vaccinations are written down"							
    "[B] MICS indicators TC.1, TC.2, TC.3, TC.4, TC.5, TC.6, TC.7, TC.8, and TC.11a refer to children age 12-23 months; MICS indicators TC.9, TC.10 and TC.11b refer to children age 24-35 months"							
    "[C] For children with vaccination records, any record of Polio at birth is accepted. For children relying on mother's report, Polio at birth is a dose received within the first 2 weeks after birth."								
    "[D] The Hepatitis B birth dose is further disaggregated by timing of dose. For children with vaccination records, 'Within 1 day' includes records of a dose given on the day of birth or the following day. " +
           "For children relying on mother's report, 'Within 1 day' refers to the 24 hours following birth, as this is specifically used in the recall question. " +
           "Cases with unknown timing are not shown in the disaggregate, but are included in the total, which therefore may present more cases than the sum of the disaggregate."								
    "[E] Basic antigens include: BCG, Polio3, DTP3, Measles 1"								
    "[F] All antigens include: BCG, Polio3/IPV, DTP3, HepB3, Hib3, PCV3, Rota3, Rubella, YF, DT Booster 1 and Measles 2 as per the vaccination schedule in Country"
.								
						
new file.
erase file = 'aggr1.sav'.
erase file = 'aggr2.sav'.
erase file = 'aggr3.sav'.
erase file = 'aggr4.sav'.