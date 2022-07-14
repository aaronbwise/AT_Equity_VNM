include "surveyname.sps".

get file = 'mm.sav'.

select if (MWM7 = 1 and MMC1 = 1).

weight by mmweight.

recode MMC3 (8,9 = 8) (else = copy) into person.
variable labels person "Person performing circumcision:".
value labels person 
 1 "Traditional practitioner/family/friend" 
 2 "Health worker/professional" 
 6 "Other" 
 8 "Don't know/Missing".

recode MMC4 (8,9 = 8) (else = copy) into place.
variable labels place "Place of circumcision:".
value labels place 
 1 "Health facility" 
 2 "Home of a health worker/professional" 
 3 "At home" 
 4 "Ritual site" 
 6 "Other home/place" 
 8 "Don't know/Missing".

recode mage (1,2 = 1) (else = sysmis) into mage1.
recode mage (1,2 = copy) (else = sysmis) into mage2.
recode mage (3 = 3) (4,5 = 4) (6,7 = 5) (else = sysmis) into mage3.
variable labels mage1 "Age".
variable labels mage2 " ".
variable labels mage3 " ".
value labels mage1 1 "15-24".
value labels mage2 1 "  15-19" 2 "  20-24".
value labels mage3 3 "25-29" 4 "30-39" 5 "40-49".

compute total = 1.
variable labels total "".
value labels total 1 "Number of men circumcised".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* value labels total 1 "Nombre de hommes circoncis".
* variable labels person "Fournisseur de la circoncision:".
* value labels person
 1 "Praticien traditionnel/famille/amis" 
 2 "Professionnel de la santé" 
 6 "Autre" 
 8 "Manquant/NSP".
* variable labels place "Lieu de la circoncision:".
* value labels place 
 1 "Structure de santé" 
 2 "Domicile d'un professionnel de la santé" 
 3 "Domicile" 
 4 "Site rituel" 
 6 "Autre domicile/lieu" 
 8 "Manquant/NSP".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total tot display = none
  /table hh7 [c] + hh6 [c] + mage1 [c] + mage2 [c] + mage3 [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   person [c] [rowpct.validn,'',f5.1] + place [c] [rowpct.validn,'',f5.1] + total [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /categories var = person place total = yes position = after label = "Total"
  /slabels position = column visible = no
  /title title=
   "Table HA.15: Provider and location of circumcision"
	  "Percent distribution of circumcised men by person performing circumcision and the location where circumcision was perfomed, " +
	  "by background characteristics, " + surveyname.

* ctables command in French.
* ctables
  /vlabels variables = total tot display = none
  /table hh7 [c] + hh6 [c] + mage1 [c] + mage2 [c] + mage3 [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   person [c] [rowpct.validn,'',f5.1] + place [c] [rowpct.validn,'',f5.1] + total [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /categories var = person place total = yes position = after label = "Total"
  /slabels position = column visible = no
  /title title=
   "Tableau HA.15: Fournisseur et le lieu de la circoncision"
   "Répartition en pourcentage des hommes circoncis par la fournisseur et le lieu de la circoncision," +
   "par les caractéristiques caractéristiques sociodémographiques, " + surveyname.

new file.
