
* BCG.
* Include the variables from the vaccination card: IM3B and 
* if vaccination card was not availabe from mother's report: IM7.

compute bcg = 3. 
if ((IM3BD >= 1 and IM3BD <= 31) or IM3BD = 44 or (IM3BD >= 97 and IM3BD <=99)) bcg = 1.
if (bcg = 3 & (IM3BD = 66 or IM7 = 1)) bcg = 2.
if (bcg = 3 & (IM7 = 8 or IM7 = 9)) bcg = 8.
variable label bcg "BCG".
value label bcg 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* polio 0.
* Include the variables from the vaccination card: IM3P0 and 
* if vaccination card was not availabe from mother's report: IM8 and IM9.

compute polio0 = 3.
if ((IM3P0D >= 1 and IM3P0D <= 31) or IM3P0D = 44 or (IM3P0D >= 97 and IM3P0D <=99)) polio0 = 1.
if (polio0 = 3 & (IM3P0D = 66 or IM9 = 1)) polio0 = 2.
if (polio0 = 3 & (IM8 = 8 or IM8 = 9)) polio0 = 8.
variable label polio0 "Polio 0".
value label polio0 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* polio 1.
* Include the variables from the vaccination card: IM3P1 and 
* if vaccination card was not availabe from mother's report: IM8, IM9
* and number of times child received the vaccine: IM10.

compute polio1 = 3.
if ((IM3P1D >= 1 and IM3P1D <= 31) or IM3P1D = 44 or (IM3P1D >= 97 and IM3P1D <=99)) polio1 = 1.
if (polio1 = 3 & (IM3P1D = 66 or (IM8 = 1 and IM9 <> 1)
  or (IM8 = 1 and IM9 = 1 and IM10 >= 2 and IM10 < 96))) polio1 = 2.
if (polio1 = 3 & (IM9 = 8 or IM9 = 9 or (IM10 >= 96 and IM10 <= 99))) polio1 = 8.
variable label polio1 "Polio 1".
value label polio1 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* polio 2.
* Include the variables from the vaccination card: IM3P2 and 
* if vaccination card was not availabe from mother's report: IM8, IM9
* and number of times child received the vaccine: IM10.

compute polio2 = 3.
if ((IM3P2D >= 1 and IM3P2D <= 31) or IM3P2D = 44 or (IM3P2D >= 97 and IM3P2D <=99)) polio2 = 1.
if (polio2 = 3 & (IM3P2D = 66 or (IM8 = 1 and IM9 <> 1 and IM10 >= 2 and IM10 < 96)
  or (IM8 = 1 and IM9 = 1 and IM10 >= 3 and IM10 < 96))) polio2 = 2.
if (polio2 = 3 & (IM8 = 8 or IM8 = 9 or (IM10 >= 96 and IM10 <= 99))) polio2 = 8.
variable label polio2 "Polio 2".
value label polio2 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* polio 3.
* Include the variables from the vaccination card: IM3P3 and 
* if vaccination card was not availabe from mother's report: IM8, IM9
* and number of times child received the vaccine: IM10.

compute polio3 = 3.
if ((IM3P3D >= 1 and IM3P3D <= 31) or IM3P3D = 44 or (IM3P3D >= 97 and IM3P3D <=99)) polio3 = 1.
if (polio3 = 3 & (IM3P3D = 66 or (IM8 = 1 and IM9 <> 1 and IM10 >= 3 and IM10 <= 96)
  or (IM8 = 1 and IM9 = 1 and IM10 >= 4 and IM10 < 96))) polio3 = 2.
if (polio3 = 3 & (IM8 = 8 or IM8 = 9 or (IM10 >= 96 and IM10 <= 99))) polio3 = 8.
variable label polio3 "Polio 3".
value label polio3 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* DPT1.
* Include the variables from the vaccination card: IM3D1 and 
* if vaccination card was not availabe from mother's report: IM11.

compute dpt1 = 3.
if ((IM3D1D >= 1 and IM3D1D <= 31) or IM3D1D = 44 or (IM3D1D >= 97 and IM3D1D <=99)) dpt1 = 1.
if (dpt1 = 3 & (IM3D1D = 66 or IM11 = 1)) dpt1 = 2.
if (dpt1 = 3 & (IM11 = 8 or IM11 = 9)) dpt1 = 8.
variable label dpt1 "DPT1".
value label dpt1 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* DPT2.
* Include the variables from the vaccination card: IM3D2 and 
* if vaccination card was not availabe from mother's report: IM11
* and the number of times child received the vaccine: IM12.

compute dpt2 = 3.
if ((IM3D2D >= 1 and IM3D2D <= 31) or IM3D2D = 44 or (IM3D2D >= 97 and IM3D2D <=99 )) dpt2 = 1.
if (dpt2 = 3 & (IM3D2D = 66 or (IM11 = 1 and IM12 >= 2 and IM12 < 96))) dpt2 = 2.
if (dpt2 = 3 & (IM11 = 8 or IM11 = 9 or (IM12 >= 96 and IM12 <= 99))) dpt2 = 8.
variable label dpt2 "DPT2".
value label dpt2 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* DPT3.
* Include the variables from the vaccination card: IM3D3 and 
* if vaccination card was not availabe from mother's report: IM11
* and the number of times child received the vaccine: IM12.

compute dpt3 = 3.
if ((IM3D3D >= 1 and IM3D3D <= 31) or IM3D3D = 44 or (IM3D3D >= 97 and IM3D3D  <=99)) dpt3 = 1.
if (dpt3 = 3 & (IM3D3D = 66 or (IM11 = 1 and IM12 >= 3 and IM12 < 96))) dpt3 = 2.
if (dpt3 = 3 & (IM11 = 8 or IM11 = 9 or (IM12 >= 96 and IM12 <= 99))) dpt3 = 8.
variable label dpt3 "DPT3".
value label dpt3 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* HepB0 (or DPTHepB0).
* Include the variables from the vaccination card: IM3H0 and 
* if vaccination card was not availabe from mother's report: IM13 and IM14.

compute hepb0 = 3.
if ((IM3H0D >= 1 and IM3H0D <= 31) or IM3H0D = 44 or (IM3H0D >= 97 and IM3H0D <=99)) hepb0 = 1.
if (hepb0 = 3 & (IM3H0D = 66 or (IM13 = 1 and IM14 = 1))) hepb0 = 2.
if (hepb0 = 3 & (IM13 = 8 or IM13 = 9)) hepb0 = 8.
variable label hepb0 "HepB0".
value label hepb0 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* HepB1 (or DPTHepB1).
* Include the variables from the vaccination card: IM3H1 and 
* if vaccination card was not availabe from mother's report: IM13, IM14
* and the number of times child received the vaccine: IM15.

compute hepb1 = 3.
if ((IM3H1D >= 1 and IM3H1D <= 31) or IM3H1D = 44 or (IM3H1D >= 97 and IM3H1D <=99)) hepb1 = 1.
if (hepb1 = 3 & (IM3H1D = 66 or (IM13 = 1 and IM14 <> 1))
   or (IM13 = 1 and IM14 = 1 and IM15 >= 2 and IM15 <96)) hepb1 = 2.
if (hepb1 = 3 & (IM13 = 8 or IM13 = 9 or (IM15 >= 96 and IM15 <= 99))) hepb1 = 8.
variable label hepb1 "HepB1".
value label hepb1 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* HepB2 (or DPTHepB2).
* Include the variables from the vaccination card: IM3H2 and 
* if vaccination card was not availabe from mother's report: IM13, IM14
* and the number of times child received the vaccine: IM15.

compute hepb2 = 3.
if ((IM3H2D >= 1 and IM3H2D <= 31) or IM3H2D = 44 or (IM3H2D >= 97 and IM3H2D <=99)) hepb2 = 1.
if (hepb2 = 3 & (IM3H2D = 66 or (IM13 = 1 and IM14 <> 1 and IM15 >= 2 and IM15 < 96))
    or (IM13 = 1 and IM14 = 1 and IM15 >=3 and IM15 <96)) hepb2 = 2.
if (hepb2 = 3 & (IM13 = 8 or IM13 = 9 or (IM15 >= 96 and IM15 <= 99))) hepb2 = 8.
variable label hepb2 "HepB2".
value label hepb2 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* HepB3 (or DPTHepB3).
* Include the variables from the vaccination card: IM3H3 and 
* if vaccination card was not availabe from mother's report: IM13, IM14
* and the number of times child received the vaccine: IM15.

compute hepb3 = 3.
if ((IM3H3D >= 1 and IM3H3D <= 31) or IM3H3D = 44 or (IM3H3D >= 97 and IM3H3D <=99)) hepb3 = 1.
if (hepb3 = 3 & (IM3H3D = 66 or (IM13 = 1 and IM14 <> 1 and IM15 >= 3 and IM15 < 96))
   or (IM13 = 1 and IM14 = 1 and IM15 >= 4 and IM15 < 96)) hepb3 = 2.
if (hepb3 = 3 & (IM13 = 8 or IM13 = 9 or (IM15 >= 96 and IM15 <= 99))) hepb3 = 8.
variable label hepb3 "HepB3".
value label hepb3 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* Measles (MMR).
* Include the variables from the vaccination card: IM3M and 
* if vaccination card was not availabe from mother's report: IM16.

compute measles = 3.
if ((IM3MD >= 1 and IM3MD <= 31) or IM3MD = 44 or (IM3MD >= 97 and IM3MD <=99)) measles = 1.
if (measles = 3 & (IM3MD = 66 or IM16 = 1)) measles = 2.
if (measles = 3 & (IM16 = 8 or IM16 = 9)) measles = 8.
variable label measles  "Measles (or MMR)".
value label measles 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* Yellow Fever.
* Include the variables from the vaccination card: IM3Y and 
* if vaccination card was not availabe from mother's report: IM17.

compute yf = 3.
if ((IM3YD >= 1 and IM3YD <= 31) or IM3YD = 44 or (IM3YD >= 97 and IM3YD <=99)) yf = 1.
if (yf = 3 & (IM3YD = 66 or IM17 = 1)) yf = 2.
if (yf = 3 & (IM17 = 8 or IM17 = 9)) yf = 8.
variable label yf "Yellow Fever".
value label  yf 1 "Vaccination card" 2 "Mother's report" 3 "Not vaccinated" 8 "DK".

* all vaccinations.
do if (bcg = 3 or measles = 3 or dpt1 = 3 or dpt2 = 3 or dpt3 = 3 or polio1 = 3 or polio2 = 3 or polio3 = 3 or hepb1 = 3 or hepb2 = 3 or hepb3 = 3 or yf = 3).
* at least one vaccination not given.
+  compute allvacc = 3.
else if (bcg = 8 or measles = 8 or dpt1 = 8 or dpt2 = 8 or dpt3 = 8 or polio1 = 8 or polio2 = 8 or polio3 = 8 or hepb1 = 8 or hepb2 = 8 or hepb3 = 8 or yf = 8).
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
do if (bcg = 3 & measles = 3 & dpt1 = 3 & dpt2 = 3 & dpt3 = 3 & polio1 = 3 & polio2 = 3 & polio3 = 3 & hepb1 = 3 & hepb2 = 3 & hepb3 = 3 & yf = 3).
* no vaccinations given.
+  if (IM1 = 1) novacc = 1.
+  if (IM1 <> 1) novacc = 2.
else if (bcg = 1 or measles = 1 or dpt1 = 1 or dpt2 = 1 or dpt3 = 1 or polio1 = 1 or polio2 = 1 or polio3 = 1 or hepb1 = 1 or hepb2 = 1 or hepb3 = 1 or yf = 1 or
           bcg = 2 or measles = 2 or dpt1 = 2 or dpt2 = 2 or dpt3 = 2 or polio1 = 2 or polio2 = 2 or polio3 = 2 or hepb1 = 2 or hepb2 = 2 or hepb3 = 2 or yf = 2).
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

recode bcg polio0 polio1 polio2 polio3 dpt1 dpt2 dpt3 measles hepb0 hepb1 hepb2 hepb3 yf allvacc novacc (8=sysmis).