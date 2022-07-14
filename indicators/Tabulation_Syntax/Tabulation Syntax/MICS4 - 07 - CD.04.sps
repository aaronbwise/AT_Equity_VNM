include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 100.
variable label total "Number of children under age 5".
value label total 100 "".

recode cage (0 thru 23 = 1) (else = 2) into agegrp .
variable label agegrp "Age".
value label agegrp 1 "0-23" 2 "24-59".

recode EC3A (0 = 0) (else = 100) into alone.
variable label  alone "Left alone in the past week".

recode EC3B (0 = 0) (else = 100) into care.
variable label  care "Left in the care of another child younger than 10 years of age in the past week".

compute inadeq = 0.
if (care = 100 or alone  = 100) inadeq  = 100.
variable label inadeq "Left with inadequate care in the past week [1]".

compute layer = 0.
variable lable layer "".
value label layer 0 "Percentage of children under age 5".

compute tot1 = 1.
variable label tot1 "Total".
value label tot1 1" ".

* For labels in French uncomment commands bellow.

* variable label total " Nombre d'enfants de moins de 5 ans".
* value label agegrp 1 "0-23 mois" 2 "24-59 mois".
* variable label  alone " laissés seuls au cours de la semaine passée".
* variable label  care " laissés à la garde d'un autre enfant âgé de moins de 10 ans au cours de la semaine passée".
* variable label inadeq " laissés avec une garde inadéquate a cours de la semaine passée [1]".
* value label layer 0 " Pourcentage d'enfants de moins de 5 ans".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer
         display = none
  /table hl4 [c] + hh7 [c]+ hh6 [c] + agegrp [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
             layer [c] > (alone [s] [mean,'',f5.1] + care [s] [mean,'',f5.1] + inadeq [s] [mean,'',f5.1]) + total [s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible = no
  /title title=
  "Table CD.4: Inadequate care"
  "Percentage of children under age 5 left alone or left in the care of other children under the age of 10 years for more than one hour at least once during the past week, " + surveyname
  caption=
 	"[1] MICS indicator 6.5".

* Ctables command in French.
*
ctables
  /vlabels variables = layer
         display = none
  /table hl4 [c] + hh7 [c]+ hh6 [c] + agegrp [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
             layer [c] > (alone [s] [mean,'',f5.1] + care [s] [mean,'',f5.1] + inadeq [s] [mean,'',f5.1]) + total [s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible = no
  /title title=
  "Tableau CD.4: Garde inadéquate"
	"Pourcentage d'enfants de moins de 5 ans laissés seuls ou laissés à la garde d'un autre enfant âgé de moins de 10 ans pendant plus, "
	"d'une heure, au moins une fois au cours de la semaine passée, " + surveyname
  caption=
 	"[1] Indicateur MICS 6.5".				

new file.
