* Encoding: UTF-8.
***.
*v02 - 2020-04-26. Lines 5-28: condition vtot<96, and vtot <99, chaned to vtot<6 and vtot<9, respectively.
*                          Several changes related to the latest tab plan. 
***.

***. 
define vaccdef ( vacc = !tokens(1) / vd = !tokens(1) / vm = !tokens(1) / vy = !tokens(1) / vgiven = !tokens(1) / vbirth = !tokens(1) / vtot = !tokens(1) / vnum = !tokens(1) / vlabel = !tokens(1) ).

compute !vacc = 3. 
* Given according to card.
if ((!vd >= 1 and !vd <= 31) or !vd = 44 or (!vd >= 97 and !vd <=99)) !vacc = 1.
* Given according to mother's report - marked on card.
if (!vacc = 3 & !vd = 66) !vacc = 2.
* Polio 0 - given at birth.
if (!vacc = 3 & (!vgiven = 1 & !vbirth = 1 & !vnum=0)) !vacc = 2.
* BCG, Polio 1, Penta 1, Pneumo 1, Rota 1, Measles, Yellow Fever - given (not at birth).
if (!vacc = 3 & (!vgiven = 1 & !vbirth<>1 & !vnum=1)) !vacc = 2.
* All except Polio 0- given, had one at birth, had more than x (x is 1, 2, 3 - vnum). 
if (!vacc = 3 & (!vgiven = 1 & !vbirth = 1 & !vnum<>0 & !vtot>=!vnum+1 & !vtot<8)) !vacc = 2.
* Polio 2,3, Penta 2,3, Pneumo 2,3, Rota 2 - given, not at birth, had x or more (x is 1,2,3 - vnum).
if (!vacc = 3 & (!vgiven = 1 & !vbirth<>1 & !vnum>1 & !vtot>=!vnum & !vtot<8)) !vacc = 2.
* DK/Missing is ever given.
if (!vacc = 3 & (!vgiven = 8 or !vgiven = 9)) !vacc = 8.
* Polio 2,3, Penta 2,3, Pneumo 2,3, Rota 2 - DK/Missing number given.
if (!vacc = 3 &  !vnum > 1 & (!vtot >= 8 & !vtot <= 9)) !vacc = 8.

variable labels !vacc !vlabel.
value labels !vacc 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

!enddefine.

* Country specific variables. Customization required.
* BCG.
vaccdef vacc=bcg    vd=IM6BD    vm=IM6BM    vy=IM6BY    vgiven=IM14    vbirth=0    vtot=1    vnum=1 vlabel="BCG".

* Polio 0.
vaccdef vacc=polio0    vd=IM6P0D vm=IM6P0M vy=IM6P0Y vgiven=IM16   vbirth=IM17   vtot=IM18 vnum=0 vlabel="Polio at birth".
* Polio 1,2,3.
vaccdef vacc=polio1    vd=IM6P1D vm=IM6P1M vy=IM6P1Y vgiven=IM16   vbirth=IM17   vtot=IM18 vnum=1 vlabel="OPV 1".
vaccdef vacc=polio2    vd=IM6P2D vm=IM6P2M vy=IM6P2Y vgiven=IM16   vbirth=IM17   vtot=IM18 vnum=2 vlabel="OPV 2".
vaccdef vacc=polio3    vd=IM6P3D vm=IM6P3M vy=IM6P3Y vgiven=IM16   vbirth=IM17   vtot=IM18 vnum=3 vlabel="OPV 3".
* Polio IPV.
vaccdef vacc=ipv    vd=IM6ID vm=IM6IM vy=IM6IY vgiven=IM19   vbirth=0   vtot=1 vnum=1 vlabel="Polio (IPV)".

*combine Polio3 and IPV.
compute polio3ipv = 3.
* both from the card.
if (polio3=1 and ipv=1) polio3ipv = 1.
* mothers report, if at least one comes from mothers report.
if (polio3=1 and ipv=2) polio3ipv = 2.
if (polio3=2 and ipv=1) polio3ipv = 2.
if (polio3=2 and ipv=2) polio3ipv = 2.
* dk if any is dk.
if polio3ipv=3 and (polio3=8 or polio3=9 or ipv=8 or ipv=9) polio3ipv = 8.
variable labels polio3ipv "OPV3 and IPV".

* HepB at birth.
recode IM15 (1, 2 = 1) (else = copy) into IM15HepB.
vaccdef vacc=hepB0    vd=IM6H0D vm=IM6H0M vy=IM6H0Y vgiven=IM15HepB   vbirth=1   vtot=1 vnum=0 vlabel="HepB at birth".
* Hep B at birth: Within 1 day.
compute hepB0day = 3.
* Card.
* Vaccination date is valid, vaccine is given on the birthday or a day after, when month and year are the same).
if (hepB0day = 3 & hepB0 = 1 & IM6H0D < 44 & IM6H0M < 44 & IM6H0Y < 4444 & (IM6H0D = UB1D or IM6H0D = UB1D+1) & IM6H0M = UB1M & IM6H0Y = UB1Y) hepB0day = 1.
* Vaccination date is valid, vaccine is given on the birthday or a day after, transition from one month to another).
if (hepB0day = 3 & hepB0 = 1 & IM6H0D < 44 & IM6H0M < 44 & IM6H0Y < 4444 & IM6H0D = 1 & IM6H0M = UB1M + 1 & IM6H0Y = UB1Y) hepB0day = 1.
* Vaccination date is valid, vaccine is given on the birthday or a day after, transition from one year to another).
if (hepB0day = 3 & hepB0 = 1 & IM6H0D < 44 & IM6H0M < 44 & IM6H0Y < 4444 & IM6H0D = 1 & IM6H0M = 1 & IM6H0Y = UB1Y+1) hepB0day = 1.
* Mothers recall.
if (hepB0day = 3 & hepB0 = 2 & IM15 = 1) hepB0day = 2.
* Hep B at birth: Later.
compute hepB0later = 3.
* Card.
* Any valid date when vacinne is not given within 24 h.
if (hepB0later = 3 & hepB0 = 1 & IM6H0D < 44 & IM6H0M < 44 & IM6H0Y < 4444 & hepB0day <> 1) hepB0later = 1.
* Mothers recall. 
if (hepB0later = 3 & hepB0 = 2 & IM15 = 2) hepB0later = 2.
value labels hepB0day hepB0later 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".
* create date variables for both options of HepB.
do if (hepB0day = 1).
+ compute IM6H0Da = IM6H0D.
+ compute IM6H0Ma = IM6H0M.
+ compute IM6H0Ya = IM6H0Y.
end if.
do if (hepB0later = 1).
+ compute IM6H0Db = IM6H0D.
+ compute IM6H0Mb = IM6H0M.
+ compute IM6H0Yb = IM6H0Y.
end if.

* Penta 1,2,3. 
vaccdef vacc=penta1    vd=IM6PENTA1D vm=IM6PENTA1M vy=IM6PENTA1Y vgiven=IM20  vbirth=0 vtot=IM21 vnum=1 vlabel="DTP-HepB-Hib 1".
vaccdef vacc=penta2    vd=IM6PENTA2D vm=IM6PENTA2M vy=IM6PENTA2Y vgiven=IM20  vbirth=0 vtot=IM21 vnum=2 vlabel="DTP-HepB-Hib 2".
vaccdef vacc=penta3    vd=IM6PENTA3D vm=IM6PENTA3M vy=IM6PENTA3Y vgiven=IM20  vbirth=0 vtot=IM21 vnum=3 vlabel="DTP-HepB-Hib 3".

*  Pneumo 1,2,3. 
vaccdef vacc=pneumo1      vd=IM6PCV1D vm=IM6PCV1M vy=IM6PCV1Y vgiven=IM22  vbirth=0      vtot=IM23 vnum=1 vlabel="Pneumococcal (Conjugate) 1".
vaccdef vacc=pneumo2      vd=IM6PCV2D vm=IM6PCV2M vy=IM6PCV2Y vgiven=IM22  vbirth=0      vtot=IM23 vnum=2 vlabel="Pneumococcal (Conjugate) 2".
vaccdef vacc=pneumo3      vd=IM6PCV3D vm=IM6PCV3M vy=IM6PCV3Y vgiven=IM22  vbirth=0      vtot=IM23 vnum=3 vlabel="Pneumococcal (Conjugate) 3".

* Rotavirus 1,2,3. 
vaccdef vacc=rota1     vd=IM6R1D vm=IM6R1M vy=IM6R1Y vgiven=IM24  vbirth=0 vtot=IM25 vnum=1 vlabel="Rotavirus 1".
vaccdef vacc=rota2     vd=IM6R2D vm=IM6R2M vy=IM6R2Y vgiven=IM24  vbirth=0 vtot=IM25 vnum=2 vlabel="Rotavirus 2".
vaccdef vacc=rota3     vd=IM6R3D vm=IM6R3M vy=IM6R3Y vgiven=IM24  vbirth=0 vtot=IM25 vnum=2 vlabel="Rotavirus 3".

* MMR.
vaccdef vacc=measles1 vd=IM6M1D  vm=IM6M1M  vy=IM6M1Y  vgiven=IM26  vbirth=0   vtot=IM26A  vnum=1 vlabel="Measles-Rubella 1".
vaccdef vacc=measles2 vd=IM6M2D  vm=IM6M2M  vy=IM6M2Y  vgiven=IM26  vbirth=0   vtot=IM26A  vnum=2 vlabel="Measles-Rubella 2".

* YF.
vaccdef vacc=yf vd=IM6YD  vm=IM6YM  vy=IM6YY  vgiven=IM27  vbirth=0      vtot=1       vnum=1 vlabel="Yellow fever".

* Td Booster.
vaccdef vacc=td vd=IM6TDD  vm=IM6TDM  vy=IM6TDY  vgiven=IM27A vbirth=0      vtot=1       vnum=1 vlabel="Td Booster".

* Basic antigens.
do if (bcg = 3 or polio1 = 3 or polio2 = 3 or polio3 = 3 or penta1 = 3 or penta2 = 3 or penta3 = 3 or measles1 = 3).
* at least one vaccination not given.
+  compute basicvacc = 3.
else if (bcg = 8 or polio1 = 8 or polio2 = 8 or polio3 = 8 or penta1 = 8 or penta2 = 8 or penta3 = 8 or measles1 = 8).
* at least one vaccination not known if given.
+  compute basicvacc = 8.
else.
* all vaccinations given.
recode IM5 (1, 2, 3 = 1)(else = 2) into basicvacc.
end if.
variable labels basicvacc "Basic vaccinations".
value labels basicvacc
	1 "Vaccination card"
	2 "Mother's report"
	3 "Doesn't have all vaccinations"
 	8 "DK".

* All antigens.
* All antigens include: BCG, Polio3/IPV, DTP3, HepB3, Hib3, Rubella, DT Booster 1 and Measles 2 as per the vaccination schedule in Country.
do if (bcg = 3 or polio1 = 3 or polio2 = 3 or polio3 = 3 or ipv = 3 or penta1 = 3 or penta2 = 3 or penta3 = 3 or rota1 = 3 or rota2 = 3 or rota3 = 3 or measles1 = 3  or measles2 = 3 or pneumo1 = 3 or pneumo2 = 3 or pneumo3 = 3 or yf = 3 or td = 2).
* at least one vaccination not given.
+  compute allvacc = 3.
else if (bcg = 8 or polio1 = 8 or polio2 = 8 or polio3 = 8 or ipv = 8 or penta1 = 8 or penta2 = 8 or penta3 = 8 or rota1 = 8 or rota2 = 8 or rota3 = 8 or measles1 = 8 or measles2 = 8 or pneumo1 = 8 or pneumo2 = 8 or pneumo3 = 8 or yf = 8 or td = 8).
* at least one vaccination not known if given.
+  compute allvacc = 8.
else.
* all vaccinations given.
recode IM5 (1, 2, 3 = 1)(else = 2) into allvacc.
end if.
variable labels allvacc "All vaccinations".
value labels allvacc
	1 "Vaccination card"
	2 "Mother's report"
	3 "Doesn't have all vaccinations"
 	8 "DK".

* no vaccinations.
compute novacc = 8.
do if (bcg = 3 and polio1 = 3 and polio2 = 3 and polio3 = 3 and ipv = 3 and penta1 = 3 and penta2 = 3 and penta3 = 3 and rota1 = 3 and rota2 = 3 and rota3 = 3 and measles1 = 3  and measles2 = 3 
       and pneumo1 = 3 and pneumo2 = 3 and pneumo3 = 3 and yf = 3 and td = 2).
* no vaccinations given.
+ recode IM5 (1, 2, 3 = 1)(else = 2) into novacc.
else if (bcg = 1 or polio1 = 1 or polio2 = 1 or polio3 = 1 or ipv = 1 or penta1 = 1 or penta2 = 1 or penta3 = 1 or rota1 = 1 or rota2 = 1 or rota3 = 1 or measles1 = 1 or measles2 = 1 or pneumo1 = 1 or pneumo2 = 1 or pneumo3 = 1 or yf = 1 or td = 1 or
       bcg = 2 or polio1 = 2 or polio2 = 2 or polio3 = 2 or ipv = 2 or penta1 = 2 or penta2 = 2 or penta3 = 2 or rota1 = 2 or rota2 = 2 or rota3 = 2 or measles1 = 2 or measles2 = 2 or pneumo1 = 2 or pneumo2 = 2 or pneumo3 = 2 or yf = 2 or td = 2).
* at least one vaccination given.
+ compute novacc = 3.
end if.
variable labels novacc "No vaccinations".
value labels novacc
	1 "Vaccination card"
	2 "Mother's report"
	3 "Has some vaccinations".

* child has vaccination card.
recode IM2(1,2,3 =1 )(else = 2) into hasC.

* vaccination card seen.
recode IM5 (1, 2, 3 = 1) (else = 2) into hasvcard.
variable labels hasvcard 'Vaccination card seen'.
value labels hasvcard
	1 "Yes"
	2 "No".