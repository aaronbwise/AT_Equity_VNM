include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
value labels total  1 "Number of children under age 5".
variable labels total "".

* remove don't know and missing from future calculations (e.g., medians).

recode EC1 (98,99 = sysmis).

recode EC1 (3 thru 10 = 100) (else = 0) into  cbooks3.
variable labels  cbooks3 "3 or more children's books [1]".

recode EC1 (10 = 100) (else = 0) into  cbooks10.
variable labels  cbooks10 "10 or more children's books".

recode EC2A (1 = 100)  (else = 0) into hobjects.
variable labels hobjects "Homemade toys".

recode EC2B (1 = 100)  (else = 0) into outside.
variable labels outside "Toys from a shop/manufactured toys".

recode EC2C  (1 = 100)  (else = 0) into homem.
variable labels homem "Household objects/objects found outside".

count typeplay = hobjects outside homem (100).

recode typeplay (2,3 = 100) (else = 0) into type2.
variable labels type2 "Two or more types of playthings [2]".

recode cage (0 thru 23 = 1) (else = 2) into age2.
variable labels age2 "Age".
value labels age2 1 "0-23 months" 2 "24-59 months".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Household has for the child:".

compute layer3 = 0.
variable labels layer3 "".
value labels layer3 0 "Child plays with:".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1" ".

* For labels in French uncomment commands bellow.

* variable labels total " Nombre d'enfants de moins de 5 ans".
* variable labels  cbooks3 "3 livres pour enfants ou plus [1]".
* variable labels  cbooks10 "10 livres pour enfants ou plus".
* variable labels hobjects " des jouets fabriqués à la maison".
* variable labels outside " des jouets d'un magasin/des jouets d'un fabricant".
* variable labels homem " des objets du ménage/objets trouvés dehors".
* variable labels type2 " Deux types de jouets ou plus [2]".
* value labels age2 1 "0-23 mois" 2 "24-59 mois".
* value labels layer2 0 " Le ménage a pour l'enfant:".
* value labels layer3 0 " L'enfant joue avec:".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer2 layer3 total
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + age2 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
          layer2 [c] > (cbooks3 [s] [mean,'',f5.1] + cbooks10 [s] [mean,'',f5.1]) +
          layer3 [c]> (hobjects [s] [mean,'',f5.1] + outside [s] [mean,'',f5.1] + homem[s] [mean,'',f5.1])  + 
          type2 [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible = no
  /title title=
   "Table CD.3: Learning materials"
   "Percentage of children under age 5 by numbers of children's books present in the household, and by playthings that child plays with, " + surveyname
  caption=   
	"[1] MICS indicator 6.3"
	"[2] MICS indicator 6.4".

* Ctables command in French.
*
ctables
  /vlabels variables = layer2 layer3 total
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + age2 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
          layer2 [c] > (cbooks3 [s] [mean,'',f5.1] + cbooks10 [s] [mean,'',f5.1]) +
          layer3 [c]> (hobjects [s] [mean,'',f5.1] + outside [s] [mean,'',f5.1] + homem[s] [mean,'',f5.1])  + 
          type2 [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible = no
  /title title=
   "Tableau CD.3: Matériel didactique"
   "Pourcentage d'enfants âgés de moins de 5 ans selon le nombre de livres d'enfants présents dans le ménage, et le type de jouets avec lesquels joue l'enfant, " + surveyname
  caption=   
	"[1] Indicateur MICS 6.3"
	"[2] Indicateur MICS 6.4".							

new file.
