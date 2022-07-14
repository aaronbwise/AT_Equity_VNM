include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1 and ML1 = 1).

weight by chweight.

compute total = 1.
variable labels  total "".
value labels total 1 "Number of children age 0-59 months with fever in the last two weeks".

compute heelstick = 0.
if (ML2 = 1) heelstick = 100.
variable labels  heelstick "Had a finger or heel stick [1]".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands bellow.
* value labels total 1 " Nombre des enfant âgés de 0-59 mois ayant eu de la fièvre au cours des deux dernières semaines".
* variable labels  heelstick " Ont subi une piqûre au doigt ou au talon [1]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                heelstick [s] [mean,'',f5.1] + total [c] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.15: Malaria diagnostics usage"
  	"Percentage of children age 0-59 months who had a fever in the last two weeks and who had a finger or heel stick for malaria testing, " + surveyname
  caption=
    "[1] MICS indicator 3.16".

* Ctables command in French.
*
ctables
  /vlabels variables =  total tot
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                heelstick [s] [mean,'',f5.1] + total [c] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Tableau CH.15: Diagnostic du paludisme"
  	"Pourcentage d'enfants âgés de 0-59 mois ayant eu de la fièvre au cours des deux dernières semaines et qui ont subi une piqûre au doigt ou au talon pour tester le paludisme, " + surveyname
  caption=
    "[1] Indicaeur MICS 3.16".

new file.
