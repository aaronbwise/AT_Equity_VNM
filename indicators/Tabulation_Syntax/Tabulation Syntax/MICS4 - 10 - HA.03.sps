include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

compute total = 1.
value labels total 1 "Number of women".
variable labels total "".

compute know = 0.
if (HA8A = 1 or HA8B = 1 or HA8C = 1) know = 100.
variable labels know "Percentage who know HIV can be transmitted from mother to child".

recode HA8A (1 = 100) (else = 0) into preg.
variable labels preg "During pregnancy".

recode HA8B (1 = 100) (else = 0) into delivery.
variable labels delivery "During delivery".

recode HA8C (1 = 100) (else = 0) into bmilk.
variable labels bmilk "By breastfeeding".

compute three = 0.
if (HA8A = 1 and HA8B = 1 and HA8C = 1) three = 100.
variable labels three "All three means [1]".

compute none = 0.
if (HA8A <> 1 and HA8B <> 1 and HA8C <> 1) none = 100.
variable labels none "Does not know any of the specific means".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percent who know HIV can be transmitted:".

recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status".
value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode wage (1,2 = 1) (else = sysmis) into wage1.
recode wage (1,2 = copy) (else = sysmis) into wage2.
recode wage (3 = 3) (4,5 = 4) (6,7 = 5) (else = sysmis) into wage3.
variable labels wage1 "Age".
variable labels wage2 " ".
variable labels wage3 " ".
value labels wage1 1 "15-24".
value labels wage2 1 "  15-19" 2 "  20-24".
value labels wage3 3 "25-29" 4 "30-39" 5 "40-49".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* value labels total 1 "Nombre de femmes".
* variable labels know "Pourcentage de celles qui savent que le VIH peut être transmis de la mère à l'enfant".
* variable labels preg "durant la grossesse".
* variable labels delivery "durant l'accouchement".
* variable labels bmilk "par l'allaitement".
* variable labels three "tous les trois moyens [1]".
* variable labels none "Ne connaît pas les trois moyens spécifiques".
* value labels layer 0 "Pourcentage de celles qui savent que le VIH peut être transmis:".
* variable labels mstatus "Etat matrimonial".
* value labels mstatus
  1 "Déjà été mariée/vécu avec un homme"
  2 "N'a jamais été mariée/vécu avec un homme".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total layer tot display = none
  /table hh7 [c] + hh6 [c] + wage1 [c] + wage2 [c] + wage3 [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   know [s] [mean,'',f5.1] + 
                   layer [c] > (preg [s] [mean,'',f5.1] + delivery [s] [mean,'',f5.1] + bmilk [s] [mean,'',f5.1] + three [s] [mean,'',f5.1]) + 
                   none [s] [mean,'',f5.1] +
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.3: Knowledge of mother-to-child HIV transmission "
	  "Percentage of women age 15-49 years who correctly identify means of HIV transmission from mother to child, " + surveyname
  caption = 
   "[1] MICS indicator 9.3".

* ctables command in French.
* ctables
  /vlabels variables =  total layer tot display = none
  /table hh7 [c] + hh6 [c] + wage1 [c] + wage2 [c] + wage3 [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   know [s] [mean,'',f5.1] + 
                   layer [c] > (preg [s] [mean,'',f5.1] + delivery [s] [mean,'',f5.1] + bmilk [s] [mean,'',f5.1] + three [s] [mean,'',f5.1]) + 
                   none [s] [mean,'',f5.1] +
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Tableau HA.3: Connaissance de la tansmission du VIH de la mère à l'enfant"
	  "Pourcentage de femmes âgées de 15-49 ans qui identifient correctement les moyens de transmission du VIH de la mère à l'enfant, " + surveyname
  caption = 
   "[1] Indicateur MICS 9.3".

new file.
