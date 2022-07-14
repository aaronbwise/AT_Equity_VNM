include "surveyname.sps".

get file = 'mm.sav'.

select if (MWM7 = 1).

weight by mmweight.

compute total = 1.
value labels total 1 "Number of men age 15-49 years".
variable labels total "".

compute goesout = 0.
if (MDV1A = 1) goesout = 100.
variable labels goesout "If goes out without telling him".

compute neglects = 0.
if (MDV1B = 1) neglects = 100.
variable labels neglects "If she neglects the children".

compute argues = 0.
if (MDV1C = 1) argues = 100.
variable labels argues "If she argues with him".

compute refuses = 0.
if (MDV1D = 1) refuses = 100.
variable labels refuses "If she refuses sex with him".

compute burns = 0.
if (MDV1E = 1) burns = 100.
variable labels burns "If she burns the food".

compute any = 0.
if (goesout = 100 or neglects = 100 or argues = 100 or refuses = 100 or burns = 100) any = 100.
variable labels any "For any of these reasons [1]".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of men age 15-49 years who believe a husband is justified in beating his wife/partner:".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1 " ".

* For labels in French uncomment commands below.

* value labels total 1 "Nombre de hommes âgées de 15-49 ans".
* variable labels goesout "Si elle sort sans le lui dire".
* variable labels neglects "Si elle néglige les enfants".
* variable labels argues "Si elle argumente avec lui".
* variable labels refuses "Si elle refuse d'avoir des rapports sexuels avec lui".
* variable labels burns "Si elle brûle la nourriture".
* variable labels any "Pour toutes ces raisons[1]".
* value labels layer 0 "Pourcentage de hommes âgées de 15-49 ans qui croient qu'il est justifié qu'un mari batte sa femme/partenaire:".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer total display = none
  /table hh7 [c] + hh6 [c] + mage [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot1 [c]  by 
  layer [c] > (goesout [s] [mean,'',f5.1] + neglects [s] [mean,'',f5.1] + argues [s] [mean,'',f5.1] +
                   refuses [s] [mean,'',f5.1] + burns [s] [mean,'',f5.1] + any [s] [mean,'',f5.1]) +
  total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
  "Table CP.11M: Attitudes toward domestic violence"
  	"Percentage of men age 15-49 years who believe a husband is justified in beating his wife/partner in various circumstances, " + surveyname
  caption=
       "[1] MICS indicator 8.14".

* ctables command in French.
* ctables
  /vlabels variables = layer total display = none
  /table hh7 [c] + hh6 [c] + mage [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot1 [c]  by 
  layer [c] > (goesout [s] [mean,'',f5.1] + neglects [s] [mean,'',f5.1] + argues [s] [mean,'',f5.1] +
                   refuses [s] [mean,'',f5.1] + burns [s] [mean,'',f5.1] + any [s] [mean,'',f5.1]) +
  total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
  "Tableau CP.11M: Attitudes vis-à-vis de la violence domestique"
  	"Pourcentage de hommes âgées de 15-49 ans qui croient qu'il est justifié qu'un mari batte sa femme dans différentes situations, " + surveyname
  caption=
       "[1] Indicateur MICS 8.14".

new file.
