* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
value labels total 1 "".
variable labels  total "Number of children age 0-59 months".

* Diarrhoea in last 2 weeks.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels  diarrhea "Had diarrhoea in last two weeks".

do if (CA1 = 1).

+ compute orsdmore = 0.
+ if (CA4A = 1 or CA4B = 1 or CA2 = 4) orsdmore = 100.

+ compute ort = 0.
+ if (CA4A = 1 or CA4B = 1 or CA4C = 1 or CA4D = 1 or CA4E = 1 or CA2 = 4) ort = 100.

+ compute ortfeed= 0.
+ if (ort = 100 and  (CA3 = 2 or CA3=3 or CA3 = 4)) ortfeed = 100.

+ compute antibioticp = 0.
+ if (CA6A = "A") antibioticp = 100.
+ compute antimotility = 0.
+ if (CA6B = "B") antimotility = 100.
+ compute zinc = 0.
+ if (CA6C = "C") zinc = 100.
+ compute otherpill = 0.
+ if (CA6G = "G") otherpill = 100.
+ compute dkpill = 0.
+ if (CA6H = "H") dkpill = 100.
+ compute antibiotici = 0.
+ if (CA6L = "L") antibiotici = 100.
+ compute nonantii = 0.
+ if (CA6M = "M") nonantii = 100.
+ compute dkinj = 0.
+ if (CA6N = "N") dkinj = 100.
+ compute intravenous = 0.
+ if (CA6O = "O") intravenous = 100.
+ compute homerem = 0.
+ if (CA6Q = "Q") homerem = 100.
+ compute other = 0.
+ if (CA6X = "X") other = 100.

+ compute notreat = 0.
+ if (ort = 0 and ortfeed = 0 and antibioticp = 0 and antimotility = 0 and zinc = 0 and otherpill = 0 and dkpill = 0 
     and antibiotici = 0 and nonantii = 0 and dkinj = 0 and intravenous = 0 and  homerem = 0 and other = 0) notreat = 100.

+ compute dtotal = 1.

end if.

variable labels  ort "ORT (ORS or recommended homemade fluids or increased fluids)".
variable labels  ortfeed "ORT with continued feeding [1]".
variable labels  orsdmore "ORS or increased fluids".
variable labels  antibioticp "Pill or syrup: Antibiotic".
variable labels  antimotility "Pill or syrup: Antimotility".
variable labels  zinc "Pill or syrup: Zinc".
variable labels  otherpill "Pill or syrup: Other ".
variable labels  dkpill "Pill or syrup: Unknown".
variable labels  antibiotici "Injection: Antibiotic".
variable labels  nonantii "Injection: Non-antibiotic".
variable labels  dkinj "Injection: Unknown".
variable labels  intravenous "Intravenous".
variable labels  homerem "Home remedy/Herbal medicine".
variable labels  other "Other".
value labels dtotal 1 "Number of children aged 0-59 months with diarrhoea".
variable labels  dtotal "".
variable labels  notreat "Not given any treatment or drug".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Children with diarrhoea who received:".

compute layer2 = 0.
variable labels  layer2 "".
value labels layer2 0 "Other treatment:".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands bellow.

* variable labels  ort " TRO (SRO ou liquides maison recommandés ou augmentation de liquides)".
* variable labels  ortfeed " TRO avec poursuite de l'alimentation [1]".
* variable labels  orsdmore " SRO ou augmentation de liquides".
* variable labels  antibioticp " Pilule ou sirop: Antibiothérapie".
* variable labels  antimotility " Pilule ou sirop: Anti-motilité ".
* variable labels  zinc " Pilule ou sirop: Zinc".
* variable labels  otherpill " Pilule ou sirop: Autre".
* variable labels  dkpill " Pilule ou sirop: Inconnu".
* variable labels  antibiotici "Injection: Antibiothérapie ".
* variable labels  nonantii "Injection: Non-antibiothérapie".
* variable labels  dkinj "Injection: Inconnu".
* variable labels  intravenous " Intraveineux".
* variable labels  homerem " Remède maison, herbe médicinale".
* variable labels  other " Aucun autre traitement".
* value labels dtotal 1 " Nombre d'enfants âgés de 0-59 mois ayant eu la diarrhée au cours des deux dernières semaines".
* variable labels  notreat " N'ont reçu aucun traitement ou médicament".
* value labels layer 0 " Enfants ayant eu la diarrhée et reçu:".
* value labels layer2 0 " Autres traitements:".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer layer2 tot dtotal
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
              layer [c] > (orsdmore [s] [mean,'',f5.1] + ort [s] [mean,'',f5.1] + ortfeed [s] [mean,'',f5.1]) +
              layer2 [c] > (antibioticp [s] [mean,'',f5.1] + antimotility [s] [mean,'',f5.1] + zinc [s] [mean,'',f5.1] + 
                                otherpill [s] [mean,'',f5.1] + dkpill [s] [mean,'',f5.1] + antibiotici [s] [mean,'',f5.1] + 
                                nonantii [s] [mean,'',f5.1] + dkinj [s] [mean,'',f5.1] + intravenous [s] [mean,'',f5.1] +
                                homerem [s] [mean,'',f5.1] + other [s] [mean,'',f5.1]) +
              notreat [s] [mean,'',f5.1] +
              dtotal [c] [count,'',f5.0]
 /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.6: Oral rehydration therapy with continued feeding and other treatments"
  	"Percentage of children age 0-59 months with diarrhoea in the last two weeks " +
                  "who received oral rehydration therapy with continued feeding, and percentage of " +
                  "children with diarrhoea who received other treatments, " + surveyname
  caption =
    "[1] MICS indicator 3.8".

* Ctables command in French.
*
ctables
  /vlabels variables = layer layer2 tot dtotal
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
              layer [c] > (orsdmore [s] [mean,'',f5.1] + ort [s] [mean,'',f5.1] + ortfeed [s] [mean,'',f5.1]) +
              layer2 [c] > (antibioticp [s] [mean,'',f5.1] + antimotility [s] [mean,'',f5.1] + zinc [s] [mean,'',f5.1] + 
                                otherpill [s] [mean,'',f5.1] + dkpill [s] [mean,'',f5.1] + antibiotici [s] [mean,'',f5.1] + 
                                nonantii [s] [mean,'',f5.1] + dkinj [s] [mean,'',f5.1] + intravenous [s] [mean,'',f5.1] +
                                homerem [s] [mean,'',f5.1] + other [s] [mean,'',f5.1]) +
              notreat [s] [mean,'',f5.1] +
              dtotal [c] [count,'',f5.0]
 /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Tableau CH.6: Thérapie de la rehydratation orale avec poursuite de l'alimentation et d'autres traitements"
  	"Pourcentage d'enfants âgés de 0-59 mois ayant eu la diarrhée au cours des deux dernières semaines et reçu une thérapie  " +
                  "de rehydratation orale avec poursuite de l'alimentation," +
                  "et pourcentage d'enfants ayant eu la diarrhée et reçu d'autres traitements, " + surveyname
  caption =
    "[1] Indicateur MICS 3.8".

new file.
