* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

do if (cage >= 0 and cage <= 5).
+ compute exbf5 = 0.
+ if (BF2 = 1 & (BF3 <> 1 & BF4 <> 1 & BF6 <> 1 & BF8 <> 1 & BF9 <> 1 & 
  BF12 <> 1 & BF13 <> 1 & BF15 <> 1 & BF16 <> 1)) exbf5 = 100.
end if.
variable labels exbf5 "Children age 0-5 months".

do if (cage >= 6 and cage <= 23).
+ compute approp1 = 0.
+ if (BF2 = 1 and BF16 = 1) approp1 = 100.
end if.
variable labels approp1 "Children age 6-23 months".

do if (cage >= 0 and cage <= 23).
+ compute approp = 0.
+ if (cage >= 0 and cage <= 5 and exbf5 = 100) approp = 100.
+ if (cage >=6 and cage <=23 and approp1 = 100) approp = 100.
end if.
variable labels approp "Children age 0-23 months".

compute total = 1.
variable labels total  "Total".
value labels total 1 " ".

* For labels in French uncomment commands bellow.
* variable labels exbf5 "Enfants âgés de 0-5 mois".
* variable labels approp1 "Enfants âgés de 6-23 mois".
* variable labels approp "Enfants âgés de 0-23 mois".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table hl4 [c] + hh7 [c] + hh6 [c] +  melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
           exbf5 [s] [mean,'Percent exclusively breastfed [1]',f5.1,validn 'Number of children' f5.0] +
           approp1 [s] [mean,'Percent currently breastfeeding and receiving solid, semi-solid or soft foods',f5.1,validn 'Number of children' f5.0] +
           approp [s] [mean,'Percent appropriately breastfed [2]',f5.1,validn 'Number of children' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
  "Table NU.5: Age-appropriate breastfeeding"
  "Percentage of children age 0-23 months who were appropriately breastfed during the previous day, " + surveyname 
  caption=
   "[1] MICS indicator 2.6	"							
   "[2] MICS indicator 2.14".	

* Ctables command in French.
*
ctables
  /table hl4 [c] + hh7 [c] + hh6 [c] +  melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
           exbf5 [s] [mean,'Pourcentage allaités exclusivement [1]',f5.1,validn 'Nombre d enfants' f5.0] +
           approp1 [s] [mean,'Pourcentage actuellement nourris au sein et recevant des aliments solides, semi-solides ou mous',f5.1,validn 'Nombre d enfants' f5.0] +
           approp [s] [mean,'Pourcentage convenablement allaités [2]',f5.1,validn 'Nombre d enfants' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
  "Tableau NU.5: Allaitement approprié à l'âge"
  "Pourcentage des enfants âgés de 0-23 mois ayant été convenablement allaités la veille, " + surveyname
  caption=
   "[1] Indicateur MICS  2.6"							
   "[2] Indicateur MICS 2.14".	
							

COMMENT -- End CTABLES command.
new file.
