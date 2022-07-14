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

select if (cage >= 18 and cage <= 29).


compute total = 1.
variable label total "Number of children".
value label total 1 "".

recode hepb1 (1,2 = 100) (3 = 0) into hepb1_r.
variable label hepb1_r "".

recode hepb2 (1,2 = 100) (3 = 0) into hepb2_r.
variable label hepb2_r "".

recode hepb3 (1,2 = 100) (3 = 0) into hepb3_r.
variable label hepb3_r "".

recode hib1 (1,2 = 100) (3 = 0) into hib1_r.
variable label hib1_r "".

recode hib2 (1,2 = 100) (3 = 0) into hib2_r.
variable label hib2_r "".

recode hib3 (1,2 = 100) (3 = 0) into hib3_r.
variable label hib3_r "".

recode yf (1,2 = 100) (3 = 0) into yf_r.
variable label yf_r "".

recode hasvcard (1 = 100) (2 = 0) into card_r.
variable label card_r "".

tables
  /format = zero
  /observation = hepb1_r hepb2_r hepb3_r hib1_r hib2_r hib3_r yf_r card_r
  /ftotal = tot1 "Total"
  /table = HL4 + hh7 + hh6 + melevel + wlthind5 + HC1B + tot1 by 
		hepb1_r + hepb2_r + hepb3_r + hib1_r + hib2_r + hib3_r + yf_r + card_r
  /statistics
    mean(hepb1_r (f5.1) 'HepB1')
    mean(hepb2_r (f5.1) 'HepB2')
    mean(hepb3_r (f5.1) 'HepB3')
    mean(hib1_r (f5.1) 'Hib1')
    mean(hib2_r (f5.1) 'Hib2')
    mean(hib3_r (f5.1) 'Hib3')
    mean(yf_r (f5.1) 'Yellow Fever')
    mean(card_r (f5.1) 'Percent with health card')
    validn(card_r (f5.0) 'Number of children aged 18-29 months')
  /title
    "Table CH.2c: Vaccinations by background characteristics (continued)"
		"Percentage of children aged 18-29 months currently vaccinated against "+
		"childhood diseases, Country, Year".

new file.
