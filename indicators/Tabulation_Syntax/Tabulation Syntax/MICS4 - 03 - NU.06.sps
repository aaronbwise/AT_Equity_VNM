* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

select if (cage >= 6 and cage <= 8).

compute ctotal = 1.
variable labels ctotal "Number of children age 6-8 months".
value labels ctotal 1 "".

compute approp = 0.
if (BF16 = 1) approp = 100.
variable labels approp " ".

compute layer = 1.
variable labels layer "".
value labels layer 1 "All".

do if (BF2 = 1).
+ compute approp1 = 0.
+ if (BF16 = 1) approp1 = 100.
end if.
variable labels approp1 "Currently breastfeeding".

do if (BF2 <> 1 or sysmis(BF2)).
+ compute approp2 = 0.
+ if (BF16 = 1) approp2 = 100.
end if.
variable labels approp2 "Currently not breastfeeding".

compute total = 1.
variable labels total  "Total".
value labels total 1 " ".

* For labels in French uncomment commands bellow.
* variable labels ctotal "Nombre d'enfants âgés de 6-8 mois".
* value labels layer 1 "Tous".
* variable labels approp1 "Allaités actuellement".
* variable labels approp2 "Pas allaités".

* Ctables command in English (currently active, comment it out if using different language).	 	
ctables
  /vlabels variables = layer approp
           display = none
  /table hl4 [c] + hh6 [c] + total [c] by 
           approp1 [s] [mean,'Percent receiving solid, semi-solid or soft foods',f5.1,validn 'Number of children age 6-8 months' f5.0] +
           approp2 [s] [mean,'Percent receiving solid, semi-solid or soft foods',f5.1,validn 'Number of children age 6-8 months' f5.0] +
           layer [c] > (approp [s] [mean,'Percent receiving solid, semi-solid or soft foods [1]',f5.1,validn 'Number of children age 6-8 months' f5.0])
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
  "Table NU.6: Introduction of solid, semi-solid or soft food"
  "Percentage of infants age 6-8 months who received solid, semi-solid or soft foods during the previous day, " + surveyname
  caption=
   "[1] MICS indicator 2.12".	

* Ctables command in French.
*
ctables
  /vlabels variables = layer approp
           display = none
  /table hl4 [c] + hh6 [c] + total [c] by 
           approp1 [s] [mean,'Pourcentage reçevant des aliments solides, semi-solides ou mous',f5.1,validn 'Nombre d enfants âgés de 6-8 mois' f5.0] +
           approp2 [s] [mean,'Pourcentage reçevant des aliments solides, semi-solides ou mous',f5.1,validn 'Nombre d enfants âgés de 6-8 mois' f5.0] +
           layer [c] > (approp [s] [mean,'Pourcentage reçevant des aliments solides, semi-solides ou mous [1]',f5.1,validn 'Nombre d enfants âgés de 6-8 mois' f5.0])
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
  "Tableau NU.6: Introduction d'aliments solides, semi-solides ou mous"
  "Pourcentage des enfants âgés de 6-8 mois ayant reçu des aliments solides, semi-solides ou mous la veille " + surveyname
  caption=
   "[1] Indicateur  MICS 2.12".											
							
new file.
