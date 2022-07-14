include "surveyname.sps".

get file = 'mm.sav'.

select if (MWM7 = 1).

weight by mmweight.

compute total = 1.
value labels total 1 "Number of men".
variable labels total "".

compute know = 0.
if (MHA8A = 1 or MHA8B = 1 or MHA8C = 1) know = 100.
variable labels know "Percentage who know HIV can be transmitted from mother to child".

recode MHA8A (1 = 100) (else = 0) into preg.
variable labels preg "During pregnancy".

recode MHA8B (1 = 100) (else = 0) into delivery.
variable labels delivery "During delivery".

recode MHA8C (1 = 100) (else = 0) into bmilk.
variable labels bmilk "By breastfeeding".

compute three = 0.
if (MHA8A = 1 and MHA8B = 1 and MHA8C = 1) three = 100.
variable labels three "All three means [1]".

compute none = 0.
if (MHA8A <> 1 and MHA8B <> 1 and MHA8C <> 1) none = 100.
variable labels none "Does not know any of the specific means".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percent who know HIV can be transmitted:".

recode mmstatus (1,2 = 1) (3 = 2).
variable labels mmstatus "Marital status".
value labels mmstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode mage (1,2 = 1) (else = sysmis) into mage1.
recode mage (1,2 = copy) (else = sysmis) into mage2.
recode mage (3 = 3) (4,5 = 4) (6,7 = 5) (else = sysmis) into mage3.
variable labels mage1 "Age".
variable labels mage2 " ".
variable labels mage3 " ".
value labels mage1 1 "15-24".
value labels mage2 1 "  15-19" 2 "  20-24".
value labels mage3 3 "25-29" 4 "30-39" 5 "40-49".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* value labels total 1 "Nombre de hommes".
* variable labels know "Pourcentage de celles qui savent que le VIH peut être transmis de la mère à l'enfant".
* variable labels preg "durant la grossesse".
* variable labels delivery "durant l'accouchement".
* variable labels bmilk "par l'allaitement".
* variable labels three "tous les trois moyens [1]".
* variable labels none "Ne connaît pas les trois moyens spécifiques".
* value labels layer 0 "Pourcentage de celles qui savent que le VIH peut être transmis:".
* variable labels mmstatus "Etat matrimonial".
* value labels mmstatus
  1 "Déjà été mariée/vécu avec une femme"
  2 "N'a jamais été mariée/vécu avec une femme".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total layer tot display = none
  /table hh7 [c] + hh6 [c] + mage1 [c] + mage2 [c] + mage3 [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] +tot [c] by 
                   know [s] [mean,'',f5.1] + 
                   layer [c] > (preg [s] [mean,'',f5.1] + delivery [s] [mean,'',f5.1] + bmilk [s] [mean,'',f5.1] + three [s] [mean,'',f5.1]) + 
                   none [s] [mean,'',f5.1] +
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
  	"Table HA.3M: Knowledge of mother-to-child HIV transmission "
	  "Percentage of men age 15-49 years who correctly identify means of HIV transmission from mother to child, " + surveyname
  caption = 
   "[1] MICS indicator 9.3".

* ctables command in French.
* ctables
  /vlabels variables =  total layer tot display = none
  /table hh7 [c] + hh6 [c] + mage1 [c] + mage2 [c] + mage3 [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   know [s] [mean,'',f5.1] + 
                   layer [c] > (preg [s] [mean,'',f5.1] + delivery [s] [mean,'',f5.1] + bmilk [s] [mean,'',f5.1] + three [s] [mean,'',f5.1]) + 
                   none [s] [mean,'',f5.1] +
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Tableau HA.3M: Connaissance de la tansmission du VIH de la mère à l'enfant"
	  "Pourcentage de hommes âgées de 15-49 ans qui identifient correctement les moyens de transmission du VIH de la mère à l'enfant, " + surveyname
  caption = 
   "[1] Indicateur MICS 9.3".

new file.
