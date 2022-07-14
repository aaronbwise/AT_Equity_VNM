
* BCG.
compute bcg = 3.
if ((IM2D >= 1 and IM2D <= 31) or IM2D = 44 or IM2D >= 97) bcg = 1.
if (bcg = 3 & (IM2D = 66 or IM11 = 1)) bcg = 2.
if (bcg = 3 & (IM11 = 8 or IM11 = 9)) bcg = 8.
variable label bcg "BCG".
value label bcg 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* polio 0.
compute polio0 = 3.
if ((IM3AD >= 1 and IM3AD <= 31) or IM3AD = 44 or IM3AD >= 97) polio0 = 1.
if (polio0 = 3 & (IM3AD = 66 or IM13 = 1)) polio0 = 2.
if (polio0 = 3 & (IM12 = 8 or IM12 = 9)) polio0 = 8.
variable label polio0 "Polio 0".
value label polio0 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* polio 1.
compute polio1 = 3.
if ((IM3BD >= 1 and IM3BD <= 31) or IM3BD = 44 or IM3BD >= 96) polio1 = 1.
if (polio1 = 3 & (IM3BD = 66 or (IM12 = 1 and IM13 <> 1)
  or (IM12 = 1 and IM13 = 1 and IM14 >= 2 and IM14 < 96))) polio1 = 2.
if (polio1 = 3 & (IM12 = 8 or IM12 = 9 or (IM14 >= 96 and IM14 <= 99))) polio1 = 8.
variable label polio1 "Polio 1".
value label polio1 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* polio 2.
compute polio2 = 3.
if ((IM3CD >= 1 and IM3CD <= 31) or IM3CD = 44 or IM3CD >= 96) polio2 = 1.
if (polio2 = 3 & (IM3CD = 66 or (IM12 = 1 and IM13 <> 1 and IM14 >= 2 and IM14 < 96)
  or (IM12 = 1 and IM13 = 1 and IM14 >= 3 and IM14 < 96))) polio2 = 2.
if (polio2 = 3 & (IM12 = 8 or IM12 = 9 or (IM14 >= 96 and IM14 <= 99))) polio2 = 8.
variable label polio2 "Polio 2".
value label polio2 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* polio 3.
compute polio3 = 3.
if ((IM3DD >= 1 and IM3DD <= 31) or IM3DD = 44 or IM3DD >= 96) polio3 = 1.
if (polio3 = 3 & (IM3DD = 66 or (IM12 = 1 and IM13 <> 1 and IM14 >= 3 and IM14 <= 96)
  or (IM12 = 1 and IM13 = 1 and IM14 >= 4 and IM14 < 96))) polio3 = 2.
if (polio3 = 3 & (IM12 = 8 or IM12 = 9 or (IM14 >= 96 and IM14 <= 99))) polio3 = 8.
variable label polio3 "Polio 3".
value label polio3 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* DPT1.
compute dpt1 = 3.
if ((IM4AD >= 1 and IM4AD <= 31) or IM4AD = 44 or IM4AD >= 96) dpt1 = 1.
if (dpt1 = 3 & (IM4AD = 66 or IM15 = 1)) dpt1 = 2.
if (dpt1 = 3 & (IM15 = 8 or IM15 = 9)) dpt1 = 8.
variable label dpt1 "DPT1".
value label dpt1 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* DPT2.
compute dpt2 = 3.
if ((IM4BD >= 1 and IM4BD <= 31) or IM4BD = 44 or IM4BD >= 96) dpt2 = 1.
if (dpt2 = 3 & (IM4BD = 66 or (IM15 = 1 and IM16 >= 2 and IM16 < 96))) dpt2 = 2.
if (dpt2 = 3 & (IM15 = 8 or IM15 = 9 or (IM16 >= 96 and IM16 <= 99))) dpt2 = 8.
variable label dpt2 "DPT2".
value label dpt2 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* DPT3.
compute dpt3 = 3.
if ((IM4CD >= 1 and IM4CD <= 31) or IM4CD = 44 or IM4CD >= 96) dpt3 = 1.
if (dpt3 = 3 & (IM4CD = 66 or (IM15 = 1 and IM16 >= 3 and IM16 < 96))) dpt3 = 2.
if (dpt3 = 3 & (IM15 = 8 or IM15 = 9 or (IM16 >= 96 and IM16 <= 99))) dpt3 = 8.
variable label dpt3 "DPT3".
value label dpt3 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* HepB1 (or DPTHepB1).
compute hepb1 = 3.
if ((IM5AD >= 1 and IM5AD <= 31) or IM5AD = 44 or IM5AD >= 96) hepb1 = 1.
if (hepb1 = 3 & (IM5AD = 66 or IM16A = 1)) hepb1 = 2.
if (hepb1 = 3 & (IM16A = 8 or IM16A = 9)) hepb1 = 8.
variable label hepb1 "HepB1".
value label hepb1 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* HepB2 (or DPTHepB2).
compute hepb2 = 3.
if ((IM5BD >= 1 and IM5BD <= 31) or IM5BD = 44 or IM5BD >= 96) hepb2 = 1.
if (hepb2 = 3 & (IM5BD = 66 or (IM16A = 1 and IM16B >= 2 and IM16B < 96))) hepb2 = 2.
if (hepb2 = 3 & (IM16A = 8 or IM16A = 9 or (IM16B >= 96 and IM16B <= 99))) hepb2 = 8.
variable label hepb2 "HepB2".
value label hepb2 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* HepB3 (or DPTHepB3).
compute hepb3 = 3.
if ((IM5CD >= 1 and IM5CD <= 31) or IM5CD = 44 or IM5CD >= 96) hepb3 = 1.
if (hepb3 = 3 & (IM5CD = 66 or (IM16A = 1 and IM16B >= 3 and IM16B < 96))) hepb3 = 2.
if (hepb3 = 3 & (IM16A = 8 or IM16A = 9 or (IM16B >= 96 and IM16B <= 99))) hepb3 = 8.
variable label hepb3 "HepB3".
value label hepb3 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* Measles (MMR).
compute measles = 3.
if ((IM6D >= 1 and IM6D <= 31) or IM6D = 44 or IM6D >= 96) measles = 1.
if (measles = 3 & (IM6D = 66 or IM17 = 1)) measles = 2.
if (measles = 3 & (IM17 = 8 or IM17 = 9)) measles = 8.
variable label measles  "Measles (or MMR)".
value label measles 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* Yellow Fever.
compute yf = 3.
if ((IM7D >= 1 and IM7D <= 31) or IM7D = 44 or IM7D >= 96) yf = 1.
if (yf = 3 & (IM7D = 66 or IM18 = 1)) yf = 2.
if (yf = 3 & (IM18 = 8 or IM18 = 9)) yf = 8.
variable label yf "Yellow Fever".
value label  yf 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* HIB1.
compute hib1 = 3.
if ((IM7AD >= 1 and IM7AD <= 31) or IM7AD = 44 or IM7AD >= 96) hib1 = 1.
if (hib1 = 3 & (IM7AD = 66 or IM17A = 1)) hib1 = 2.
if (hib1 = 3 & (IM17A = 8 or IM17A = 9)) hib1 = 8.
variable label hib1 "HIB1".
value label hib1 1 "Vaccination Card" 2 "Mother's Report" 3 "Not vaccinated" 8 "DK".

* HIB2.
compute hib2 = 3.
if ((IM7BD >= 1 and IM7BD <= 31) or IM7BD = 44 or IM7BD >= 96) hib2 = 1.
if (hib2 = 3 & (IM7BD = 66 or (IM17A = 1 and IM17B >= 2 and IM17B < 96))) hib2 = 2.
if (hib2 = 3 & (IM17A = 8 or IM17A = 9 or (IM17B >= 96 and IM17B <= 99))) hib2 = 8.
variable label hib2 "HIB2".
value label hib2 1 "Vaccination Card" 2 "Mother's Report" 3 "Not vaccinated" 8 "DK".

* HIB3.
compute hib3 = 3.
if ((IM7CD >= 1 and IM7CD <= 31) or IM7CD = 44 or IM7CD >= 96) hib3 = 1.
if (hib3 = 3 & (IM7CD = 66 or (IM17A = 1 and IM17B >= 3 and IM17B < 96))) hib3 = 2.
if (hib3 = 3 & (IM17A = 8 or IM17A = 9 or (IM17B >= 96 and IM17B <= 99))) hib3 = 8.
variable label hib3 "HIB3".
value label hib3 1 "Vaccination Card" 2 "Mother's Report" 3 "Not vaccinated" 8 "DK".


* Vitamin A 1.
compute vat1 = 3.
if ((IM8AD >= 1 and IM8AD <= 31) or IM8AD = 44 or IM8AD >= 96) vat1 = 1.
if (vat1 = 3 & IM8AD = 66) vat1 = 2.
variable label vat1 "Vitamin A (1)".
value label vat1 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* Vitamin A 2.
compute vat2 = 3.
if ((IM8BD >= 1 and IM8BD <= 31) or IM8BD = 44 or IM8BD >= 96) vat2 = 1.
if (vat2 = 3 & IM8BD = 66) vat2 = 2.
variable label vat2 "Vitamin A (2)".
value label vat2 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* all vaccinations.
do if (bcg = 3 or measles = 3 or dpt1 = 3 or dpt2 = 3 or dpt3 = 3 or polio1 = 3 or polio2 = 3 or polio3 = 3).
* at least one vaccination not given.
+  compute allvacc = 3.
else if (bcg = 8 or measles = 8 or dpt1 = 8 or dpt2 = 8 or dpt3 = 8 or polio1 = 8 or polio2 = 8 or polio3 = 8).
* at least one vaccination not known if given.
+  compute allvacc = 8.
else.
* all vaccinations given.
+  if (IM1 = 1) allvacc = 1.
+  if (IM1 <> 1) allvacc = 2.
end if.
variable label allvacc "All vaccinations".
value label allvacc
	1 "Vaccination card"
	2 "Mother's report"
	3 "Doesn't have all vaccinations"
            8 "DK".

* no vaccinations.
compute novacc = 8.
do if (bcg = 3 & measles = 3 & dpt1 = 3 & dpt2 = 3 & dpt3 = 3 & polio1 = 3 & polio2 = 3 & polio3 = 3).
* no vaccinations given.
+  if (IM1 = 1) novacc = 1.
+  if (IM1 <> 1) novacc = 2.
else if (bcg = 1 or measles = 1 or dpt1 = 1 or dpt2 = 1 or dpt3 = 1 or polio1 = 1 or polio2 = 1 or polio3 = 1 or
           bcg = 2 or measles = 2 or dpt1 = 2 or dpt2 = 2 or dpt3 = 2 or polio1 = 2 or polio2 = 2 or polio3 = 2).
* at least one vaccination given.
+ compute novacc = 3.
end if.
variable label novacc "No vaccinations".
value label novacc
	1 "Vaccination card"
	2 "Mother's report"
	3 "Has some vaccinations".

* child has vaccination card.
recode IM1 (1 = 1) (else = 2) into hasvcard.
variable label hasvcard 'Has vaccination card'.
value label hasvcard
	1 "Yes"
	2 "No".

recode bcg polio0 polio1 polio2 polio3 dpt1 dpt2 dpt3 measles allvacc novacc hib1 hib2 hib3 hepb1 hepb2 hepb3 yf vat1 vat2 (8=sysmis).