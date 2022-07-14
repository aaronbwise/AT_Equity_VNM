* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

include file = "MICS4 - 04 - CH.01 RECODE.SPS".

select if (UF9 = 1).

weight by chweight.

select if (cage >= 12 and cage <= 23).

recode bcg (1,2 = 100) (3 = 0) into bcg_r.
variable label bcg_r "".

recode polio0 (1,2 = 100) (3 = 0) into polio0_r.
variable label polio0_r "".

recode polio1 (1,2 = 100) (3 = 0) into polio1_r.
variable label polio1_r "".

recode polio2 (1,2 = 100) (3 = 0) into polio2_r.
variable label polio2_r "".

recode polio3 (1,2 = 100) (3 = 0) into polio3_r.
variable label polio3_r "".

recode dpt1 (1,2 = 100) (3 = 0) into dpt1_r.
variable label dpt1_r "".

recode dpt2 (1,2 = 100) (3 = 0) into dpt2_r.
variable label dpt2_r "".

recode dpt3 (1,2 = 100) (3 = 0) into dpt3_r.
variable label dpt3_r "".

recode measles (1,2 = 100) (3 = 0) into measles_r.
variable label measles_r "".

recode hepb0 (1,2 = 100) (3 = 0) into hepb0_r.
variable label hepb0_r "".

recode hepb1 (1,2 = 100) (3 = 0) into hepb1_r.
variable label hepb1_r "".

recode hepb2 (1,2 = 100) (3 = 0) into hepb2_r.
variable label hepb2_r "".

recode hepb3 (1,2 = 100) (3 = 0) into hepb3_r.
variable label hepb3_r "".

recode yf (1,2 = 100) (3 = 0) into yf_r.
variable label yf_r "".

recode allvacc (1,2 = 100) (3 = 0) into all_r.
variable label all_r "".

recode novacc (1,2 = 100) (3 = 0) into no_r.
variable label no_r "".

recode hasvcard (1 = 100) (2 = 0) into card_r.
variable label card_r "".

compute layer = 0.
variable label layer "".
value label layer 0 "Percentage of children who received:".

compute tot = 1.
variable label tot "".
value label tot 1 "Total".

* For labels in French uncomment commands bellow.
* value label layer 0 "Pourcentage d'enfants ayant reçu:".

* Ctables command in English (currently active, comment it out if using different language).
ctables
   /vlabels variables = tot bcg_r polio0_r polio1_r polio2_r polio3_r dpt1_r dpt2_r dpt3_r measles_r hepb0_r hepb1_r hepb2_r hepb3_r yf_r no_r all_r card_r layer
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
  layer [c] >
   (bcg_r [s] [mean,'BCG',f5.1] + 
   polio0_r [s] [mean,'Polio at birth',f5.1] + polio1_r [s] [mean,'Polio 1',f5.1] + Polio2_r [s] [mean,'Polio 2',f5.1] + Polio3_r [s] [mean,'Polio 3',f5.1] +
   dpt1_r [s] [mean,'DPT 1',f5.1] + dpt2_r [s] [mean,'DPT 2',f5.1] + dpt3_r [s] [mean,'DPT 3',f5.1]+
   measles_r [s] [mean,'Measles',f5.1] + 
   hepb0_r [s] [mean,'HepB at birth',f5.1] + hepb1_r [s] [mean,'HepB 1',f5.1] + hepb2_r [s] [mean,'HepB 2',f5.1] + hepb3_r [s] [mean,'HepB 3',f5.1] +
   yf_r [s] [mean,'Yellow fever',f5.1] +
   no_r [s] [mean,'None',f5.1] + 
   all_r [s] [mean,'All',f5.1] )+
  card_r [s] [mean,'Percentage with vaccination card seen',f5.1,
  validn,'Number of children age 12-23 months',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
    "Table CH.2: Vaccinations by background characteristics"
		"Percentage of children age 12-23 months currently vaccinated against childhood diseases, " + surveyname.

* Ctables command in French.
*
ctables
   /vlabels variables = tot bcg_r polio0_r polio1_r polio2_r polio3_r dpt1_r dpt2_r dpt3_r meales_r hepb0_r hepb1_r hepb2_r hepb3_r yf_r no_r all_r card_r layer
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
  layer [c] >
   (bcg_r [s] [mean,'BCG',f5.1] + 
   polio0_r [s] [mean,'Polio a la naissance',f5.1] + polio1_r [s] [mean,'Polio 1',f5.1] + Polio2_r [s] [mean,'Polio 2',f5.1] + Polio3_r [s] [mean,'Polio 3',f5.1] +
   dpt1_r [s] [mean,'DPT 1',f5.1] + dpt2_r [s] [mean,'DPT 2',f5.1] + dpt3_r [s] [mean,'DPT 3',f5.1]+
   measles_r [s] [mean,'Measles',f5.1] + 
   hepb0_r [s] [mean,'HepB at birth',f5.1] + hepb1_r [s] [mean,'HepB 1',f5.1] + hepb2_r [s] [mean,'HepB 2',f5.1] + hepb3_r [s] [mean,'HepB 3',f5.1] +
   yf_r [s] [mean,'Fièvre jaune',f5.1] +
   no_r [s] [mean,'Aucune',f5.1] + 
   all_r [s] [mean,'Toutes',f5.1] )+
  card_r [s] [mean,'Pourcentage avec carte de vaccination vue',f5.1,
  validn,'Nombre d enfants âgés de 12-23 mois',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
    "Tableau CH.2: Vaccinations selon des caractéristiques de base"
		"Pourcentage d'enfants âgés de 12-23 mois actuellement vaccinés contre les maladie infantiles, " + surveyname.

new file.