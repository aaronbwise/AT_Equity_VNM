* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

select if (cage >= 6 and cage <= 23).

recode cage (6,7,8 = 1) (9,10,11 = 2) (12 thru 17 = 3) (else = 4) into agecat. 
variable labels agecat "Age".
value labels agecat
  1 "6-8 months"
  2 "9-11 months"
  3 "12-17 months"
  4 "18-23 months".

compute ctotal = 1.
variable labels ctotal "Number of children age 6-23 months".
value labels ctotal 1 "".

compute layer = 0.
variable labels layer "".
value labels layer 0 "All".

* Recode system missing and missing to zero.
recode BF5 (sysmis, 97, 98, 99 = 0) (else = copy).
recode BF7 (sysmis, 97, 98, 99 = 0) (else = copy).
recode BF14 (sysmis, 97, 98, 99 = 0) (else = copy).
recode BF17 (sysmis, 97, 98, 99 = 0) (else = copy).

do if (BF2 = 1).
+ compute approp1 = 0.
+ if (cage >= 6 and cage <= 8 and BF17 >= 2) approp1 = 100.
+ if (cage >= 9 and cage <= 23 and BF17 >= 3) approp1 = 100.
end if.
variable labels approp1 "Currently breastfeeding".

do if (BF2 <> 1 or sysmis(BF2)).
+ compute nonbf =1.
end if.
variable labels nonbf "".
value labels nonbf 1 "Currently not breastfeeding".

compute minmilk = 0.
if (nonbf = 1 and (BF5 + BF7 + BF14 >= 2)) minmilk = 100.
variable labels minmilk "".

compute approp2 = 0.
if (nonbf = 1 and (BF17 + BF5 + BF7 + BF14 >= 4)) approp2 = 100.
variable labels approp2 "".

compute approp = 0.
if (approp1 = 100 or approp2 = 100) approp = 100.

compute total = 1.
variable labels total  "Total".
value labels total 1 " ".

* For labels in French uncomment commands bellow.
* value labels agecat
  1 "6-8 mois"
  2 "9-11 mois"
  3 "12-17 mois"
  4 "18-23 mois".

* variable labels ctotal "Nombre d'enfants âgé de 6-23 mois".

* value labels layer 0 "Tous".

* variable labels approp1 "Allaité actuellement".
* value labels nonbf 1 "Pas allaité actuellement".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer nonbf approp2 minmilk approp
           display = none
  /table hl4 [c] + agecat [c] + hh7 [c] + hh6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
           approp1 [s] [mean,'Percent receiving solid, semi-solid and soft foods the minimum number of times',f5.1,validn 'Number of children age 6-23 months' f5.0] +
           nonbf [c] > (minmilk [s] [mean,'Percent receiving at least 2 milk feeds [1]',f5.1] + 
                            approp2 [s] [mean,'Percent  receiving solid, semi-solid and soft foods or milk feeds 4 times or more',f5.1] +
                            approp2 [s] [validn,'Number of children age 6-23 months',f5.0])+
           layer [c] > approp [s] [mean,'Percent with minimum meal frequency [2]',f5.1,validn 'Number of children age 6-23 months' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
  "Table NU.7: Minimum meal frequency"
  "Percentage of children age 6-23 months who received solid, semi-solid, or soft foods (and milk feeds for non-breastfeeding children) "+
  "the minimum number of times or more during the previous day, according to breastfeeding status, " + surveyname
  caption=
  "[1] MICS indicator 2.15"								
  "[2] MICS indicator 2.13".	

* Ctables command in French.
* 
ctables
  /vlabels variables = layer nonbf approp2 minmilk approp
           display = none
  /table hl4 [c] + agecat [c] + hh7 [c] + hh6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
           approp1 [s] [mean,'Pourcentage de ceux reçevant des aliments solides, semi-solides et mous le nombre de fois minimum ',f5.1,validn 'Nombre des enfants âgés de 6-23 mois' f5.0] +
           nonbf [c] > (minmilk [s] [mean,'Pourcentage de ceux reçevant au moins 2 aliments à base de lait [1]',f5.1] + 
                            approp2 [s] [mean,'Pourcentage de ceux  recevant des aliments solides, semi-solides et mous ou du lait 4 fois ou plus',f5.1] +
                            approp2 [s] [validn,'Nombre des enfants âgés de 6-23 mois',f5.0])+
           layer [c] > approp [s] [mean,'Pourcentage de ceux reçevant la fréquence minimum de repas [2]',f5.1,validn 'Nombre des enfants âgés de 6-23 mois' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
  "Tableau NU.7: Fréquence minimum de repas"
  "Pourcentage d'enfants âgés de 6-23 mois qui ont reçu des aliments solides, semi-solides ou mous (et des aliments d'allaitement pour les enfants non nourris au sein) "+
  " le nombre de fois minimum ou plus la veille, selon l'état d'allaitement, " + surveyname
  caption=
  "[1] Indicateur MICS 2.15"								
  "[2] Indicateur MICS 2.13".
									
new file.
