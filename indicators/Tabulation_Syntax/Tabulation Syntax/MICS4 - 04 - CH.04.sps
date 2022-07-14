* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
value labels total 1 "".
variable labels total "Number of children age 0-59 months".

* Diarrhoea in last 2 weeks.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels diarrhea "Had diarrhoea in last two weeks".

do if (CA1 = 1).
+ compute ortuse = 0.
+ compute recomall = 0.
+ compute orspack = 0.
+ if (CA4A = 1 or CA4B = 1) orspack = 100.
+ recode CA4C (1 = 100) (else = 0) into recom1.
+ recode CA4D (1 = 100) (else = 0) into recom2.
+ recode CA4E (1 = 100) (else = 0) into recom3.
+ if (recom1 = 100  or recom2 = 100  or recom3 = 100) recomall = 100.
+ if (orspack = 100 or recomall = 100) ortuse = 100.
+ compute dtotal = 1.
end if.
variable labels orspack "ORS (Fluid from ORS packet or pre-packaged ORS fluid)".
variable labels recom1 "Fluid X".
variable labels recom2 "Fluid Y".
variable labels recom3 "Fluid Z".
variable labels recomall "Any recommended homemade fluid".
variable labels ortuse "ORS or any recommended homemade fluid".
value labels dtotal 1 "Number of children aged 0-59 months with diarrhoea".
variable labels dtotal "".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Children with diarrhoea who received:".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Recommended homemade fluids".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands bellow.

* variable label total " Nombre d'enfants âgés de 0-59 mois".
* variable label diarrhea " A eu la diarrhée au cours des deux dernières semaines ".
* variable label orspack " SRO (Sachet SRO ou liquide SRO pré-emballé)".
* variable label recom1 " Liquide X".
* variable label recom2 " Liquide Y".
* variable label recom3 " Liquide Z".
* variable label recomall " N'importe quel liquide maison recommandé".
* variable label ortuse " SRO ou n'importe quel liquide maison recommandé".
* value label dtotal 1 " Nombre d'enfants âgés de 0-59 mois ayant eu la diarrhée au cours des 2 dernières semaines".
* value label layer 0 " Enfants avec diarrhée ayant reçu:"
* value label layer2 0 " des liquides maison recommandés".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer layer2 tot dtotal
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
  diarrhea [s] [mean,'',f5.1] + total [s] [count,'',f5.0] +
  layer [c] > (orspack [s] [mean,'',f5.1] + 
                  layer2 [c] > (recom1 [s] [mean,'',f5.1] + recom2 [s] [mean,'',f5.1] + recom3 [s] [mean,'',f5.1] + recomall [s] [mean,'',f5.1]) + ortuse [s] [mean,'',f5.1])+ 
  dtotal [c] [count,'',f5.0]
 /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.4: Oral rehydration solutions and recommended homemade fluids"
  	"Percentage of children age 0-59 months with diarrhoea in the last two weeks, " +
                  "and treatment with oral rehydration solutions and recommended homemade fluids, " + surveyname.


* Ctables command in French.
*
ctables
  /vlabels variables = layer layer2 tot dtotal
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
  diarrhea [s] [mean,'',f5.1] + total [s] [count,'',f5.0] +
  layer [c] > (orspack [s] [mean,'',f5.1] + 
                  layer2 [c] > (recom1 [s] [mean,'',f5.1] + recom2 [s] [mean,'',f5.1] + recom3 [s] [mean,'',f5.1] + recomall [s] [mean,'',f5.1]) + ortuse [s] [mean,'',f5.1])+ 
  dtotal [c] [count,'',f5.0]
 /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Tableau CH.4: Solutions de rehydratation orale et liquides maison recommandés"
  	"Pourcentage d'enfants âgés 0-59 mois ayant eu la diarrhée au cours des deux dernières semaines, " +
                  "et traitement avec des solutions de rehydratation orale et des liquides maison recommandés, " + surveyname.
							
new file.
