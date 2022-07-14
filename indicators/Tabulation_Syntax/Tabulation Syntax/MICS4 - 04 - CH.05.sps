* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
value labels total 1 "".
variable labels total "Number of children age 0-59 months".

* diarrhoea in last 2 weeks.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels diarrhea "Had diarrhoea in last two weeks".

do if (CA1 = 1).
+ compute dtotal = 1.
end if.
value labels dtotal 1 "Number of children aged 0-59 months with diarrhoea".
variable labels dtotal "".

recode CA2 (8,9 = 9) (else = copy).
variable labels CA2 "Drinking practices during diarrhoea:".
value labels CA2
  1 "Given much less to drink"
  2 "Given somewhat less to drink"
  3 "Given about the same to drink"
  4 "Given more to drink"
  5 "Given nothing to drink"
  9 "Missing/DK".

recode CA3 (8,9 = 9) (else = copy).
variable labels CA3 "Eating practices during diarrhoea:".
value labels CA3
  1 "Given much less to eat"
  2 "Given somewhat less to eat"
  3 "Given about the same to eat"
  4 "Given more to eat"
  5 "Stopped food"
  6 "Had never been given food"
  9 "Missing/DK".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands bellow.
* variable labels total " Nombre d'enfants âgés de 0-59 mois".
* variable labels diarrhea " A eu la diarrhée au cours des deux dernières semaines".
* value labels dtotal 1 " Nombre d'enfants de 0-59 mois qui ont eu la diarrhée dans les 2 dernières semaines".
* variable labels CA2 " Pratiques de consommation de liquides durant la diarrhée:".
* value labels CA2
  1 " Donné beaucoup moins à boire"
  2 " Donné un peu moins à boire "
  3 " Donné à peu près la même quantité à boire"
  4 " Donné plus à boire"
  5 " Rien donné à boire"
  9 " Manquant/NSP ".

* variable labels CA3 " Pratiques d'alimentation durant la diarrhée:".
* value labels CA3
  1 " Donné beaucoup moins à manger"
  2 " Donné un peu moins à manger "
  3 " Donné à peu près la même quantité à manger"
  4 " Donné plus à manger"
  5 " Arrêté les aliments "
  6 " N'a jamais reçu des aliments "
  9 " Manquant/NSP ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = tot dtotal
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
  	diarrhea [s] [mean,'',f5.1] + total [s] [count,'',f5.0] + 
  	CA2 [c] [rowpct.validn,'',f5.1] +
                  CA3 [c] [rowpct.validn,'',f5.1] + 
                  dtotal [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var = CA2 CA3 total = yes position = after label = "Total"
  /slabels position=column visible = no
  /titles title=
	 "Table CH.5: Feeding practices during diarrhoea"
	  "Percent distribution of children age 0-59 months with diarrhoea in the last two weeks " +
 	  "by amount of liquids and food given during episode of diarrhoea, " + surveyname.

* Ctables command in French.
*
ctables
  /vlabels variables = tot dtotal
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
  	diarrhea [s] [mean,'',f5.1] + total [s] [count,'',f5.0] + 
  	CA2 [c] [rowpct.validn,'',f5.1] +
                  CA3 [c] [rowpct.validn,'',f5.1] + 
                  dtotal [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var = CA2 CA3 total = yes position = after label = "Total"
  /slabels position=column visible = no
  /titles title=
	 "Tableau CH.5: Pratiques d'alimentation durant la diarrhée"
	  "Répartition en pourcentage des enfants âgés de 0-59 mois ayant eu la diarrhée au cours des deux dernières " +
 	  "semaines selon la quantité de liquides et d'aliments donnés durant l'épisode diarrhéique, " + surveyname.

new file.
