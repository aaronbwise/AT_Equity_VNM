include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

compute total = 1.
variable labels total "".
value labels total 1 "Number of women".

compute place = 0.
if (HA16 = 1 or HA20 = 1 or HA22 = 1 or HA24 = 1 or HA27 = 1)  place = 100.
variable labels place "Know a place to get tested [1]".

compute tested = 0.
if (HA16 = 1 or HA20 = 1 or HA22 = 1 or HA24 = 1) tested = 100.
variable labels tested "Have ever been tested".

compute tested12 = 0.
if (HA23 = 1 or HA25 = 1) tested12 = 100.
variable labels tested12 "Have been tested in the last 12 months".

compute results = 0.
if ((HA23 = 1 and (HA17 = 1 or HA21 = 1)) or (HA25 = 1 and HA26 = 1)) results = 100.
variable labels results "Have been tested in the last 12 months and have been told result [2]".

recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status".
value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode wage (1,2 = 1) (else = sysmis) into wage1.
recode wage (1,2 = copy) (else = sysmis) into wage2.
recode wage (3 = 3) (4,5 = 4) (6,7 = 5) (else = sysmis) into wage3.
variable labels wage1 "Age".
variable labels wage2 " ".
variable labels wage3 " ".
value labels wage1 1 "15-24".
value labels wage2 1 "  15-19" 2 "  20-24".
value labels wage3 3 "25-29" 4 "30-39" 5 "40-49".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women who:".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* value labels total 1 "Nombre de femmes".
* variable labels place "connaissent un endroit où se faire tester [1]".
* variable labels tested "ont déjà été testées".
* variable labels tested12 "ont été testées au cours des 12 derniers mois".
* variable labels results "ont été testées et ont reçu le résultat [2]".
* variable labels mstatus "Etat matrimonial".
* value labels mstatus
  1 "Déjà été mariée/vécu avec un homme"
  2 "N'a jamais été mariée/vécu avec un homme".
* value labels layer 0 "Pourcentage de femmes qui:".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total tot layer display = none
  /table hh7 [c] + hh6 [c] + wage1 [c] + wage2 [c] + wage3 [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c]  > (place [s] [mean,'',f5.1] + tested [s] [mean,'',f5.1] + tested12 [s] [mean,'',f5.1] + results [s] [mean,'',f5.1]) +  
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
  	"Table HA.5: Knowledge of a place for HIV testing"
  	"Percentage of women age 15-49 years who know where to get an HIV test, " +
   "percentage of women who have ever been tested, percentage of women who have "+
   "been tested in the last 12 months, and percentage of women who have been tested "+
   "and have been told the result, " + surveyname
  caption = 
	  "[1] MICS indicator 9.5"					
	  "[2] MICS indicator 9.6".	

* ctables command in French.
* ctables
  /vlabels variables = total tot layer display = none
  /table hh7 [c] + hh6 [c] + wage1 [c] + wage2 [c] + wage3 [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c]  > (place [s] [mean,'',f5.1] + tested [s] [mean,'',f5.1] + tested12 [s] [mean,'',f5.1] + results [s] [mean,'',f5.1]) +  
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
  	"Tableau HA.5: Connaissance d'un endroit pour le test de dépistage du VIH"
	  "Pourcentage de femmes âgées de 15-49 ans qui connaissent là où subir un test de dépistage du VIH, " + 
	  "pourcentage de femmes qui ont déjà été testées, pourcentage de femmes qui ont été testées au cours des 12 derniers mois, " + 
	  "et pourcentage de femmes qui ont été testées mais n'ont pas reçu le résultat, " + surveyname
  caption = 
	  "[1] Indicateur MICS 9.5"					
	  "[2] Indicateur MICS 9.6".	

new file.
