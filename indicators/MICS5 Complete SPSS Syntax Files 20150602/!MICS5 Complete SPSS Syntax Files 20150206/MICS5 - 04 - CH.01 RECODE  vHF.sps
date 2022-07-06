define vaccdef (vacc = !tokens(1) / hfd = !tokens(1) / hfm = !tokens(1) / hfy = !tokens(1) / vd = !tokens(1) / vm = !tokens(1) / vy = !tokens(1) 
                        / vgiven = !tokens(1) / vbirth = !tokens(1) / vtot = !tokens(1)  / vnum = !tokens(1) / vlabel = !tokens(1)).

compute !vacc = 3. 
* Given according to HF card.
if ((!hfd >= 1 and !hfd <= 31) or !hfd = 44 or (!hfd >= 97 and !hfd <=99)) !vacc = 1.
* Given according to card.
if (!vacc = 3 & ((!vd >= 1 and !vd <= 31) or !vd = 44 or (!vd >= 97 and !vd <=99))) !vacc = 1.
* Given according to mother's report - marked on card.
if (!vacc = 3 & !vd = 66) !vacc = 2.
* Polio 0 and Hep B 0 - given at birth.
if (!vacc = 3 & (!vgiven = 1 & !vbirth = 1 & !vnum=0)) !vacc = 2.
* BCG, Polio 1, DPT 1, Hep B 1, HiB 1, Measles, Yellow Fever - given (not at birth).
if (!vacc = 3 & (!vgiven = 1 & !vbirth<>1 & !vnum=1)) !vacc = 2.
* All except Polio 0, Hep B 0 - given, had one at birth, had more than x (x is 1, 2, 3 - vnum). 
if (!vacc = 3 & (!vgiven = 1 & !vbirth = 1 & !vnum<>0 & !vtot>=!vnum+1 & !vtot<96)) !vacc = 2.
* Polio 2,3, DPT 2,3, Hep B 2,3, HiB 2,3 - given, not at birth, had x or more (x is 1,2,3 - vnum).
if (!vacc = 3 & (!vgiven = 1 & !vbirth<>1 & !vnum>1 & !vtot>=!vnum & !vtot<96)) !vacc = 2.
* DK/Missing is ever given.
if (!vacc = 3 & (!vgiven = 8 or !vgiven = 9)) !vacc = 8.
* Polio 2,3, DPT 2,3, Hep B 2,3, Hib 2, 3 - DK/Missing number given.
if (!vacc = 3 &  !vnum > 1 & (!vtot >= 96 & !vtot < 99)) !vacc = 8.

variable labels !vacc !vlabel.
value labels !vacc 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

!enddefine.

* Country specific variables.
* BCG.
vaccdef vacc=bcg       vd=IM3BD  vm=IM3BM  vy=IM3BY  hfd=HF13BD  hfm=HF13BM  hfy=HF13BY vgiven=IM7  vbirth=0 vtot=1 vnum=1 vlabel="BCG".

* Polio 0.
vaccdef vacc=polio0    vd=IM3P0D vm=IM3P0M vy=IM3P0Y hfd=HF13P0D   hfm=HF13P0M   hfy=HF13P0Y vgiven=IM8   vbirth=IM9   vtot=IM10 vnum=0 vlabel="Polio at birth".
* Polio 1, 2, 3.
vaccdef vacc=polio1    vd=IM3P1D vm=IM3P1M vy=IM3P1Y hfd=HF13P1D   hfm=HF13P1M   hfy=HF13P1Y vgiven=IM8   vbirth=IM9   vtot=IM10 vnum=1 vlabel="Polio 1".
vaccdef vacc=polio2    vd=IM3P2D vm=IM3P2M vy=IM3P2Y hfd=HF13P2D   hfm=HF13P2M   hfy=HF13P2Y vgiven=IM8   vbirth=IM9   vtot=IM10 vnum=2 vlabel="Polio 2".
vaccdef vacc=polio3    vd=IM3P3D vm=IM3P3M vy=IM3P3Y hfd=HF13P3D   hfm=HF13P3M   hfy=HF13P3Y vgiven=IM8   vbirth=IM9   vtot=IM10 vnum=3 vlabel="Polio 3".

* DPT.
vaccdef vacc=dpt1      vd=IM3D1D vm=IM3D1M vy=IM3D1Y hfd=HF13D1D  hfm=HF13D1M   hfy=HF13D1Y vgiven=IM11  vbirth=0 vtot=IM12 vnum=1 vlabel="DPT 1".
vaccdef vacc=dpt2      vd=IM3D2D vm=IM3D2M vy=IM3D2Y hfd=HF13D2D  hfm=HF13D2M   hfy=HF13D2Y vgiven=IM11  vbirth=0  vtot=IM12 vnum=2 vlabel="DPT 2".
vaccdef vacc=dpt3      vd=IM3D3D vm=IM3D3M vy=IM3D3Y hfd=HF13D3D  hfm=HF13D3M   hfy=HF13D3Y vgiven=IM11  vbirth=0  vtot=IM12 vnum=3 vlabel="DPT 3".

* HepB 0. 
vaccdef vacc=hepb0    vd=IM3H0D vm=IM3H0M vy=IM3H0Y hfd=HF13H0D  hfm=HF13H0M   hfy=HF13H0Y vgiven=IM13  vbirth=IM14 vtot=IM15 vnum=0 vlabel="HepB at birth".
* HepB 1,2,3. 
vaccdef vacc=hepb1    vd=IM3H1D vm=IM3H1M vy=IM3H1Y hfd=HF13H1D  hfm=HF13H1M   hfy=HF13H1Y vgiven=IM13  vbirth=IM14 vtot=IM15 vnum=1 vlabel="HepB 2".
vaccdef vacc=hepb2    vd=IM3H2D vm=IM3H2M vy=IM3H2Y hfd=HF13H2D  hfm=HF13H2M   hfy=HF13H2Y vgiven=IM13  vbirth=IM14 vtot=IM15 vnum=2 vlabel="HepB 3".
vaccdef vacc=hepb3    vd=IM3H3D vm=IM3H3M vy=IM3H3Y hfd=HF13H3D  hfm=HF13H3M   hfy=HF13H3Y vgiven=IM13  vbirth=IM14 vtot=IM15 vnum=3 vlabel="HepB 3".

* HiB.
vaccdef vacc=hib1     vd=IM3I1D vm=IM3I1M vy=IM3I1Y hfd=HF13I1D  hfm=HF13I1M   hfy=HF13I1Y vgiven=IM15A  vbirth=0 vtot=IM15B vnum=1 vlabel="HiB 1".
vaccdef vacc=hib2     vd=IM3I2D vm=IM3I2M vy=IM3I2Y hfd=HF13I2D  hfm=HF13I2M   hfy=HF13I2Y vgiven=IM15A  vbirth=0 vtot=IM15B vnum=2 vlabel="HiB 2".
vaccdef vacc=hib3     vd=IM3I3D vm=IM3I3M vy=IM3I3Y hfd=HF13I3D  hfm=HF13I3M   hfy=HF13I3Y vgiven=IM15A  vbirth=0 vtot=IM15B vnum=3 vlabel="HiB 3".

* MMR.
vaccdef vacc=measles vd=IM3MD  vm=IM3MM  vy=IM3MY  hfd=HF13MD  hfm=HF13MM   hfy=HF13MY vgiven=IM16  vbirth=0   vtot=1  vnum=1 vlabel="Measles".

* YF.
vaccdef vacc=yf vd=IM3YD  vm=IM3YM  vy=IM3YY  hfd=HF13YD  hfm=HF13YM   hfy=HF13YY vgiven=IM17  vbirth=0   vtot=1  vnum=1 vlabel="Yellow Fever".

* child has vaccination card.
recode IM1 (1 = 1) (else = 2) into hasvcard.
if (HF11 = 1) hasvcard = 1.
variable labels hasvcard 'Has vaccination card'.
value labels hasvcard
	1 "Yes"
	2 "No".

* all vaccinations.
do if (bcg = 3 or measles = 3 or dpt1 = 3 or dpt2 = 3 or dpt3 = 3 or polio1 = 3 or polio2 = 3 or polio3 = 3 or hepb0 = 3 or hepb1 = 3 or hepb2 = 3 or hib1 = 3 or hib2 = 3 or hib3 = 3 or yf = 3).
* at least one vaccination not given.
+  compute basicvacc = 3.
else if (bcg = 8 or measles = 8 or dpt1 = 8 or dpt2 = 8 or dpt3 = 8 or polio1 = 8 or polio2 = 8 or polio3 = 8 or hepb0= 8 or hepb1 = 8 or hepb2 = 8 or hib1 = 8 or hib2 = 8 or hib3 = 8 or yf = 8).
* at least one vaccination not known if given.
+  compute basicvacc = 8.
else.
* all vaccinations given.
+  if (hasvcard = 1) basicvacc = 1.
+  if (hasvcard <> 1) basicvacc = 2.
end if.
variable labels basicvacc "Fully vaccinated".
value labels basicvacc
	1 "Vaccination card"
	2 "Mother's report"
	3 "Doesn't have all vaccinations"
	8 "DK".

* no vaccinations.
compute novacc = 8.
do if (bcg = 3 & measles = 3 & dpt1 = 3 & dpt2 = 3 & dpt3 = 3 & polio1 = 3 & polio2 = 3 & polio3 = 3 &  hepb0 = 3 & hepb1 = 3 & hepb2 = 3 & hib1 = 3 & hib2 = 3 & hib3 = 3 & yf = 3).
* no vaccinations given.
+  if (hasvcard = 1) novacc = 1.
+  if (hasvcard <> 1) novacc = 2.
else if (bcg = 1 or measles = 1 or dpt1 = 1 or dpt2 = 1 or dpt3 = 1 or polio1 = 1 or polio2 = 1 or polio3 = 1 or hepb0 = 1 or hepb1 = 1 or hepb2 = 1 
	or  hib1 = 1 or hib2 = 1 or hib3 = 1 or yf = 1 or
           bcg = 2 or measles = 2 or dpt1 = 2 or dpt2 = 2 or dpt3 = 2 or polio1 = 2 or polio2 = 2 or polio3 = 2  or hepb0 = 2 or hepb1 = 2 or hepb2 = 2 
	or hib1 = 2 or hib2 = 2 or hib3 = 2 or yf = 2).
* at least one vaccination given.
+ compute novacc = 3.
end if.
variable labels  novacc "No vaccinations".
value labels novacc
	1 "Vaccination card"
	2 "Mother's report"
	3 "Has some vaccinations".

recode bcg polio0 polio1 polio2 polio3 dpt1 dpt2 dpt3 measles yf hepb0 hepb1 hepb2 hepb3 hib1 hib2 hib3 basicvacc novacc (8=sysmis).
