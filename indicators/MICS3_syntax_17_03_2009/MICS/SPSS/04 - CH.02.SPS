get file = 'ch.sav'.

include file = "04 - chrecvac.sps".

select if (UF9 = 1).

weight by chweight.

select if (cage >= 12 and cage <= 23).

recode bcg (1,2 = 100) (3 = 0) into bcg_r.
variable label bcg_r "".

recode dpt1 (1,2 = 100) (3 = 0) into dpt1_r.
variable label dpt1_r "".

recode dpt2 (1,2 = 100) (3 = 0) into dpt2_r.
variable label dpt2_r "".

recode dpt3 (1,2 = 100) (3 = 0) into dpt3_r.
variable label dpt3_r "".

recode polio0 (1,2 = 100) (3 = 0) into polio0_r.
variable label polio0_r "".

recode polio1 (1,2 = 100) (3 = 0) into polio1_r.
variable label polio1_r "".

recode polio2 (1,2 = 100) (3 = 0) into polio2_r.
variable label polio2_r "".

recode polio3 (1,2 = 100) (3 = 0) into polio3_r.
variable label polio3_r "".

recode measles (1,2 = 100) (3 = 0) into meales_r.
variable label meales_r "".

recode allvacc (1,2 = 100) (3 = 0) into all_r.
variable label all_r "".

recode novacc (1,2 = 100) (3 = 0) into no_r.
variable label no_r "".

recode hasvcard (1 = 100) (2 = 0) into card_r.
variable label card_r "".

tables
  /format = zero
  /observation = bcg_r dpt1_r dpt2_r dpt3_r polio0_r polio1_r polio2_r polio3_r meales_r
	  all_r no_r card_r
  /ftotal = tot1 "Total"
  /table = HL4 + HH7 + HH6 + melevel + wlthind5 + HC1B + tot1 by
           bcg_r + dpt1_r + dpt2_r + dpt3_r + polio0_r + polio1_r + polio2_r + polio3_r +
					 meales_r + all_r + no_r + card_r
  /statistics
    mean(bcg_r (f5.1) 'BCG')
    mean(dpt1_r (f5.1) 'DPT1')
    mean(dpt2_r (f5.1) 'DPT2')
    mean(dpt3_r (f5.1) 'DPT3')
    mean(polio0_r (f5.1) 'Polio 0')
    mean(polio1_r (f5.1) 'Polio 1')
    mean(polio2_r (f5.1) 'Polio 2')
    mean(polio3_r (f5.1) 'Polio 3')
    mean(meales_r (f5.1) 'MMR')
    mean(all_r (f5.1) 'All')
    mean(no_r (f5.1) 'None')
    mean(card_r (f5.1) 'Percent with health card')
    validn(card_r (f5.0) 'Number of children aged 12-23 months')
  /title
    "Table CH.2: Vaccinations by background characteristics"
		"Percentage of children aged 12-23 months currently vaccinated against "+
		"childhood diseases, Country, Year".

new file.
