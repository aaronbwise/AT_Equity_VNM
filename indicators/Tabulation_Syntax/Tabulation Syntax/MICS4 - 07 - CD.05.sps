include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

select if (cage >= 36).

weight by chweight.

compute total = 1.
value labels total  1 "".
variable label total "Number of children age 36-59 months".

recode EC8 (1 = 100) (else = 0).
recode EC9 (1 = 100) (else = 0).
recode EC10 (1 = 100) (else = 0).

count langcog = EC8 EC9 EC10 (100).

recode langcog (2,3 = 100) (else = 0) into langcog2.
variable label langcog2 "Literacy-numeracy".

recode EC11 (1 = 100) (else = 0).
recode EC12 (2 = 100) (else = 0).

count physical = EC11 EC12 (100).

recode physical (1,2 = 100) (else = 0) into physical2.
variable label physical2 "Physical".

recode EC15 (1 = 100) (else = 0).
recode EC16 (2 = 100) (else = 0).
recode EC17 (2 = 100) (else = 0).

count socemo = EC15 EC16 EC17 (100).

recode socemo (2,3 = 100) (else = 0) into socemo2.
variable label socemo2 "Social-Emotional".

recode EC13 (1 = 100) (else = 0).
recode EC14 (1 = 100) (else = 0).

count learn = EC13 EC14 (100).

recode learn (1,2 = 100) (else = 0) into learn2.
variable label learn2 "Learning".

count develop = langcog2 physical2 socemo2 learn2 (100).

recode develop (3,4 = 100) (else = 0) into target.
variable label target "Early child development index score [1]".

recode cage (36 thru 47 = 1) (else = 2) into age2.
variable label age2 "Age".
value label age2 1 "36-47 months" 2 "48-59 months".

compute ece = 2.
if (EC5 = 1) ece = 1.
variable label ece "Attendance to early childhood education".
value labels ece 
  1 "Attending"
  2 "Not attending ".

compute layer = 0.
variable lable layer "".
value label layer 0 "Percentage of children age 36-59 months who are developmentally on track for indicated domains".

compute tot1 = 1.
variable label tot1 "Total".
value label tot1 1" ".

* For labels in French uncomment commands bellow.

* variable label total " Nombre d'enfants âgés de 36-59 mois".
* variable label langcog2 " Alpabétiation-numéracie".
* variable label physical2 " Physique".
* variable label socemo2 " Social-Emotionnel".
* variable label learn2 " Apprentissage".
* variable label target " Score de l'indice de développement du jeune enfant [1]".
* value label age2 1 "36-47 mois" 2 "48-59 mois".
* variable label ece " Fréquentation à l'éducation du jeune enfant".
* value labels ece 
  1 "Fréquente"
  2 " Ne fréquente pas".
* value label layer 0 " Pourcentage d'enfants âgés de 36-59 ans en bonne voie de dévelopement pour le domaine de:".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer
     display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + age2 [c] + ece [c] +melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
          layer [c] > (langcog2 [s] [mean,'',f5.1] + physical2 [s] [mean,'',f5.1] + socemo2 [s] [mean,'',f5.1] + learn2 [s] [mean,'',f5.1]) + 
          target[s] [mean,'',f5.1] +  total [s] [sum,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible = no
  /title title=
  "Table CD.5: Early child development index" 
   "Percentage of children age 36-59 months who are developmentally on track in" +
   " literacy-numeracy, physical, social-emotional, and learning domains, " + 
   " and the early child development index score, " + surveyname
  caption=   
    "[1] MICS indicator 6.6".

* Ctables command in French.
*
ctables
  /vlabels variables = layer
     display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + age2 [c] + ece [c] +melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
          layer [c] > (langcog2 [s] [mean,'',f5.1] + physical2 [s] [mean,'',f5.1] + socemo2 [s] [mean,'',f5.1] + learn2 [s] [mean,'',f5.1]) + 
          target[s] [mean,'',f5.1] +  total [s] [sum,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible = no
  /title title=
  "Tableau CD.5: Indice de développement du jeune enfant" 
   "Pourcentage d'enfants âgés de 36-59 mois en bonne voie de développement " +
   "aux plans de l'alphabétisation-numéracie, physique, social-émotionnel, " + 
   "de l'apprentissage, et du score d'indice de développement du jeune enfant, " + surveyname
  caption=   
    "[1] MICS indicator 6.6".

new file.
