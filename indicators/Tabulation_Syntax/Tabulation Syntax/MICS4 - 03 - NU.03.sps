* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

weight by chweight.

select if (UF9 = 1).

do if (cage >= 0 and cage <= 5).
+ compute ch5 = 100.
+ compute exbf5 = 0.
+ if (BF2 = 1 & (BF3 <> 1 & BF4 <> 1 & BF6 <> 1 & BF8 <> 1 & BF9 <> 1 & 
  BF12 <> 1 & BF13 <> 1 & BF15 <> 1 & BF16 <> 1)) exbf5 = 100.
+ compute prbf5 = 0.
+ if (BF2 = 1 & (BF4 <> 1 & BF6 <> 1 & BF13 <> 1 & BF15 <> 1 & BF16 <> 1)) prbf5 = 100.
end if.
value labels ch5 100 "Children 0-5 months".

do if (cage >= 12 and cage <= 15).
+ compute bf12_15 = 0.
+ if (BF2 = 1) bf12_15 = 100.
end if.
variable labels bf12_15 "Children 12-15 months".

do if (cage >= 20 and cage <= 23).
+ compute bf20_23 = 0.
+ if (BF2 = 1) bf20_23 = 100.
end if.
variable labels bf20_23 "Children 20-23 months".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* For labels in French uncomment commands bellow.
* value labels ch5 100 "Enfants âgé de 0-5 mois".
* variable labels bf12_15 "Enfants âgés de 12-15 mois".
* variable labels bf20_23 "Enfants âgés de 20-23 mois".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = ch5 exbf5 prbf5
   display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
	ch5 [c] > (exbf5[s] [mean,'Percent exclusively breastfed [1]',f5.1] + prbf5[s] [mean,'Percent predominantly breastfed [2]',f5.1] + prbf5[s] [validn,'Number of children',f5.0])+
	bf12_15 [s] [mean,'Percent breastfed (Continued breastfeeding at 1 year) [3]',f5.1,validn,'Number of children',f5.0]+
	bf20_23 [s] [mean,'Percent breastfed (Continued breastfeeding at 2 years) [4]',f5.1,validn,'Number of children',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
	"Table NU.3: Breastfeeding"
	"Percentage of living children according to breastfeeding status at selected age groups, " + surveyname
  caption=
        "[1] MICS indicator 2.6"					
        "[2] MICS indicator 2.9"									
        "[3] MICS indicator 2.7"									
        "[4] MICS indicator 2.8".	

* Ctables command in French.
*
ctables
  /vlabels variables = ch5 exbf5 prbf5
   display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
	ch5 [c] > (exbf5[s] [mean,'Pourcentage exclusivement allaités au sein [1]',f5.1] + prbf5[s] [mean,'Pourcentage principalement allaités au sein [2]',f5.1] + prbf5[s] [validn,'Nombre d enfants',f5.0])+
	bf12_15 [s] [mean,'Pourcentage allaités au sein (Poursuite allaitement au sein à 1 an) [3]',f5.1,validn,'Nombre d enfants',f5.0]+
	bf20_23 [s] [mean,'Pourcentage allaités au sein (Poursuite allaitement au sein à 2 ans) [4]',f5.1,validn,'Nombre d enfants',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
	"Tableau NU.3: Allaitement au sein"
	"Pourcentage des enfants vivants selon l'état d'allaitement selon certains groupes d'âges, " + surveyname
  caption=
        "[1] Indicateur MICS 2.6"					
        "[2] Indicateur MICS 2.9"									
        "[3] Indicateur MICS 2.7"									
        "[4] Indicateur MICS 2.8".	
									
new file.
