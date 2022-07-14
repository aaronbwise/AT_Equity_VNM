include "surveyname.sps".

get file = "ch.sav".

weight by chweight.

select if (UF9 = 1).

select if (cage >= 36 and cage <= 59).

recode EC5 (1 = 100) (else = 0) into ecep.

compute agerange = 9.
if (cage >= 36 and cage <=47) agerange = 1.
if (cage >= 48 and cage <=59) agerange = 2.

variable label agerange "Age of child".
value labels agerange
  1 "36-47 months"
  2 "48-59 months".

compute tot1 = 1.
variable label tot1 "Total".
value label tot1 1" ".

* For labels in French uncomment commands bellow.

*variable label agerange "Age de l'enfant".
*value labels agerange
  1 "36-47 mois "
  2 "48-59 mois ".


* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable = ecep
     display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + agerange [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c]
         by ecep [s] [mean,  'Percentage of children age 36-59 months currently attending early childhood education [1]',f5.1,
                            validn,'Number of children aged 36-59 months',f5.0]
  /slabels position=column visible=yes
  /categories var=all empty=exclude missing=exclude
  /title title=
     "Table CD.1: Early childhood education"
      "Percentage of children age 36-59 months who are attending some form of organized early childhood education programme, " + surveyname
  caption=
      "[1] MICS indicator 6.7".

* Ctables command in French.
*
ctables
  /vlabels variable = ecep
     display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + agerange [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c]
         by ecep [s] [mean, "Pourcentage d'enfants âgés de 36-59 mois suivant actuellement une éducation préscolaire [1]",f5.1,
                            validn,"Nombre d'enfants âgés de 36-59 mois",f5.0]
  /slabels position=column visible=yes
  /categories var=all empty=exclude missing=exclude
  /title title=
     "Tableau CD.1: Education du jeune enfant"
      "Pourcentage d'enfants âgés de 36-59 mois suivant un programme d'apprentissage préscolaire organisé, " + surveyname
  caption=
      "[1] Indicateur MICS 6.7".
		
new file.


