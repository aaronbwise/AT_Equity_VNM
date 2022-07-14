include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

recode CM10 (sysmis = 0) (else = copy).

compute brth15 = 0.
if ((wdobfc - wdob)/12 < 15) brth15 = 100.
variable labels brth15 " ".

do if (WB2 >= 20).
+ compute brth18 = 0.
+ if ((wdobfc - wdob)/12 < 18) brth18 = 100.
end if.
variable labels brth18" ".

do if (HH6 = 1).
+ compute brth15ur = 0.
+ if ((wdobfc - wdob)/12 < 15) brth15ur = 100.
end if.
variable labels brth15ur " ".

do if (HH6 = 1 and WB2 >= 20).
+ compute brth18ur = 0.
+ if ((wdobfc - wdob)/12 < 18) brth18ur = 100.
end if.
variable labels brth18ur " ".

do if (HH6 = 2).
+ compute brth15ru = 0.
+ if ((wdobfc - wdob)/12 < 15) brth15ru = 100.
end if.
variable labels brth15ru " ".

do if (HH6 = 2 and WB2 >= 20).
+ compute brth18ru = 0.
+ if ((wdobfc - wdob)/12 < 18) brth18ru = 100.
end if.
variable labels brth18ru" ".

compute layer1 = 0.
value labels layer1 0 "Urban".
variable lables layer1 " ".

compute layer2 = 0.
value labels layer2 0 "Rural".
variable lable layer2 " ".

compute layer3 = 0.
value labels layer3 0 "All".
variable lables layer3 " ".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1" ".

* For labels in French uncomment commands bellow.

* value label layer1 0 "Urbain".
* value label layer2 0 "Rural".
* value label layer3 0 "Toutes".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer1 layer2 layer3 brth15ur brth18ur brth15ru brth18ru brth15 brth18
           display = none
  /table wage [c] + tot1 [c] by 
       layer1 [c] > (brth15ur [s] [mean,"Percentage of women with a live birth before age 15",f5.1,validn,"Number of women age 15-49 years",f5.0] + 
                         brth18ur [s] [mean,"Percentage of women with a live birth before age 18",f5.1,,validn,"Number of women age 20-49 years",f5.0]) + 
       layer2 [c] > (brth15ru [s] [mean,"Percentage of women with a live birth before age 15",f5.1,validn,"Number of women age 15-49 years",f5.0] + 
                         brth18ru [s] [mean,"Percentage of women with a live birth before age 18",f5.1,validn,"Number of women age 20-49 years",f5.0]) + 
       layer3 [c] > (brth15 [s] [mean,"Percentage of women with a live birth before age 15",f5.1,validn,"Number of women age 15-49 years",f5.0] + 
                         brth18 [s] [mean,"Percentage of women with a live birth before age 18",f5.1,validn,"Number of women age 20-49 years",f5.0] )
  /title title=
   "Table RH.3: Trends in early childbearing"
		"Percentage of women who have had a live birth by age 15 and 18, by age groups, " + surveyname.

* Ctables command in French.
*
ctables
  /vlabels variables = layer1 layer2 layer3 brth15ur brth18ur brth15ru brth18ru brth15 brth18
           display = none
  /table wage [c] + tot1 [c] by 
       layer1 [c] > (brth15ur [s] [mean,"Pourcentage de femmes ayant eu une naissance vivant avant l'âge de 15 ans",f5.1,validn,"Nombre de femmes",f5.0] + 
                         brth18ur [s] [mean,"Pourcentage de femmes ayant eu une naissance vivante avant l'âge de 18 ans",f5.1,,validn,"Nombre de femmes",f5.0]) + 
       layer2 [c] > (brth15ru [s] [mean,"Pourcentage de femmes ayant eu une naissance vivant avant l'âge de 15 ans",f5.1,validn,"Nombre de femmes",f5.0] + 
                         brth18ru [s] [mean,"Pourcentage de femmes ayant eu une naissance vivante avant l'âge de 18 ans",f5.1,validn,"Nombre de femmes",f5.0]) + 
       layer3 [c] > (brth15 [s] [mean,"Pourcentage de femmes ayant eu une naissance vivant avant l'âge de 15 ans",f5.1,validn,"Nombre de femmes",f5.0] + 
                         brth18 [s] [mean,"Pourcentage de femmes ayant eu une naissance vivante avant l'âge de 18 ans",f5.1,validn,"Nombre de femmes",f5.0] )
  /title title=
   "Tableau RH.3: Tendances de la grossesse précoce"
		"Pourcentage de femmes ayant eu une naissance vivante, à l'âge de 15 et 18 ans, selon la résidence et la tranche d'âge, " + surveyname.

new file.
