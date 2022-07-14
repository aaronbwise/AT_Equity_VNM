* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

select if (cage >= 6).

* Set random number seed.
set seed = 1003.

* Calculate months since most recent Vitamin A dose if the Vitamin A was given.
do if (IM3VD <> 0 and IM3VD <> 44 and IM3VD <> 66 and IM3VY < 9996 and IM3VM < 96).
+ compute cmcva = (IM3VY - 1900)*12 + IM3VM.
+ if (cdoi - cmcva = 24) cmcva = cmcva + 1 .
else if (IM3VY < 9996).
+ compute uva = (IM3VY - 1900)*12 + 12.
+ compute lva = (IM3VY - 1900)*12 + 1.
+ if (cdoi - lva >= 24) lva = cdoi - 23.
+ compute cmcva = trunc(rv.uniform(lva,uva)).
end if.
compute mslva = cdoi - cmcva.
variable labels mslva "Months since most recent Vitamin A dose".
variable labels cmcva "Date of most recent vitamin A dose (CMC)".

compute vitacard = 0.
if (mslva < 6) vitacard = 100.
variable labels vitacard "Child health book/card/vaccination card".

compute vutamoth = 0.
if (IM18 = 1) vutamoth = 100.
variable labels vutamoth "Mother's report".

compute vitamina = 1.
variable labels vitamina "".
value labels vitamina 1 "Percentage who received Vitamin A according to:".

compute vitA6 = 0.
if (vitacard = 100 or vutamoth = 100) vitA6 = 100.
variable labels vitA6 "Percentage of children who received Vitamin A during the last 6 months [1]".

compute ctotal = 1.
variable labels ctotal "".
value labels ctotal 1 "Number of children age 6-59 months". 

compute total = 1.
variable labels total "Total".
value labels total 1 " ". 

* For labels in French uncomment commands bellow.

* variable labels vitacard "ivret/carte de santé/carte de vaccination de l'enfant".
* variable labels vutamoth "déclaration de la mère".
* value labels vitamina 1 "Pourcentage de ceux ayant reçu de la Vitamine A selon:".
* variable labels vitA6 "Pourcentage d'enfants ayant reçu de la Vitamine A au cours des 6 derniers mois [1]".
* value labels ctotal 1 "Nombre d'enfants âgés de 6-59 mois". 
			
* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable = vitamina ctotal
              display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
              vitamina [c] > (vitacard [s] [mean,'',f5.1] + vutamoth [s] [mean,'',f5.1]) +
              vitA6 [s] [mean,'',f5.1] +
              ctotal [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visable = no
  /titles title =
  "Table NU.10: Children's vitamin A supplementation"
  "Percent distribution of children age 6-59 months by receipt of a high dose vitamin A supplement in the last 6 months, " + surveyname
  caption =
     "[1] MICS indicator 2.17".

* Ctables command in French.
*
ctables
  /vlabels variable = vitamina ctotal
              display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
              vitamina [c] > (vitacard [s] [mean,'',f5.1] + vutamoth [s] [mean,'',f5.1]) +
              vitA6 [s] [mean,'',f5.1] +
              ctotal [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visable = no
  /titles title =
  "Tableau NU.10: Supplémentation des enfants en vitamine A	"
  "Répartition en pourcentage des enfants âgés de 6-59 mois selon la réception d'une forte dose de supplement de vitamine A au cours des 6 derniers mois, " + surveyname
  caption =
     "[1] Indicateur MICS 2.17".
			
new file.
